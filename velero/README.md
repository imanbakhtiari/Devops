# Velero: Namespace Backup & Restore (with/without volumes)

This guide is copy/paste friendly for **Kubernetes** clusters using an **S3-compatible** object store (AWS S3 / MinIO / etc.). It covers:

* Backup **namespace resources only** (no PV data)
* Backup **namespace + volumes** using **CSI snapshots** (recommended when supported)
* Backup **namespace + volumes** using **file-level** backup (**Restic/Kopia**)
* Restore into the same or another cluster

> Assumptions
>
> * You have `kubectl` access to both clusters (source + destination)
> * You have an S3 bucket and credentials
> * Your storage supports either CSI snapshots (preferred) or you’ll use Restic/Kopia

---

## 0) Variables you should set

Replace these with your values:

* `BUCKET=my-velero-bucket`
* `REGION=us-east-1` (or your S3 region)
* `S3_URL=https://minio.example.com` (only for MinIO / S3-compatible)
* `NAMESPACE_TO_BACKUP=my-namespace`
* `BACKUP_NAME=my-namespace-2026-01-31`

Create a credentials file (AWS style):

```bash
cat > credentials-velero <<'EOF'
[default]
aws_access_key_id=YOUR_ACCESS_KEY
aws_secret_access_key=YOUR_SECRET_KEY
EOF
```

---

## 1) Install Velero (core + S3 plugin)

### 1.1 Install the Velero CLI

* Linux:

```bash
curl -L https://github.com/vmware-tanzu/velero/releases/latest/download/velero-linux-amd64.tar.gz \
  | tar -xz
sudo mv velero-*/velero /usr/local/bin/velero
velero version
```

### 1.2 Install Velero server into the cluster

#### A) AWS S3 (native)

```bash
velero install \
  --provider aws \
  --plugins velero/velero-plugin-for-aws:v1.10.0 \
  --bucket $BUCKET \
  --secret-file ./credentials-velero \
  --backup-location-config region=$REGION
```

#### B) MinIO / S3-compatible (custom endpoint)

```bash
velero install \
  --provider aws \
  --plugins velero/velero-plugin-for-aws:v1.10.0 \
  --bucket $BUCKET \
  --secret-file ./credentials-velero \
  --backup-location-config region=$REGION,s3ForcePathStyle="true",s3Url=$S3_URL
```

Verify:

```bash
kubectl -n velero get pods
velero backup-location get
```

---

## 2) Backup WITHOUT volumes (resources only)

This backs up **Kubernetes objects** in the namespace but **does not back up PV data**.

```bash
velero backup create $BACKUP_NAME \
  --include-namespaces $NAMESPACE_TO_BACKUP \
  --snapshot-volumes=false
```

Watch status:

```bash
velero backup describe $BACKUP_NAME --details
velero backup logs $BACKUP_NAME
```

---

## 3) Backup WITH volumes (Method 1 — CSI snapshots, recommended)

Use this when your CSI driver supports snapshots (Longhorn, EBS, etc.).

### 3.1 Install Velero CSI plugin

```bash
velero plugin add velero/velero-plugin-for-csi:v0.8.0
```

Verify the plugin is registered:

```bash
velero plugin get
```

### 3.2 Ensure VolumeSnapshot CRDs exist

```bash
kubectl get crd | grep volumesnapshot
```

If you don’t see them, install the CSI snapshotter CRDs (usually your distro or CSI driver installs them). Longhorn typically provides them.

### 3.3 Ensure a VolumeSnapshotClass exists

```bash
kubectl get volumesnapshotclass
```

For Longhorn, you typically want something like a snapshot class with:

* `driver: driver.longhorn.io`

### 3.4 Create a snapshot-based backup

```bash
velero backup create $BACKUP_NAME \
  --include-namespaces $NAMESPACE_TO_BACKUP \
  --snapshot-volumes=true
```

Check status/logs:

```bash
velero backup describe $BACKUP_NAME --details
velero backup logs $BACKUP_NAME
```

> Notes
>
> * Snapshots are usually **crash-consistent** (like pulling the plug). For databases, see the “Database note” section below.

---

## 4) Backup WITH volumes (Method 2 — Restic/Kopia file-level)

Use this when snapshots are not available or you want a portable file-level backup.

### 4.1 Enable file-level backups

Depending on your Velero version, you’ll typically use **Kopia** or **Restic**.

#### A) Quick approach: default all volumes to Restic

```bash
velero backup create $BACKUP_NAME \
  --include-namespaces $NAMESPACE_TO_BACKUP \
  --default-volumes-to-restic
```

#### B) Per-pod annotation approach

Add this annotation to pods that have volumes you want backed up:

```yaml
metadata:
  annotations:
    backup.velero.io/backup-volumes: data
```

Where `data` is the *volume name* in the Pod spec.

---

## 5) “Zero-regret” approach: snapshots + file-level fallback

This is a strong production pattern:

```bash
velero backup create $BACKUP_NAME \
  --include-namespaces $NAMESPACE_TO_BACKUP \
  --snapshot-volumes=true \
  --default-volumes-to-restic
```

Velero will:

* Attempt CSI snapshots
* Also capture file-level backups (useful if snapshot restore fails later)

---

## 6) Restore a namespace backup

### 6.1 Restore into the same cluster

```bash
velero restore create \
  --from-backup $BACKUP_NAME
```

Monitor:

```bash
velero restore get
velero restore describe <RESTORE_NAME> --details
velero restore logs <RESTORE_NAME>
```

### 6.2 Restore into another cluster (migration)

On the **destination cluster**:

1. Install Velero with the **same bucket** and credentials (Section 1)
2. Install the same required plugins (AWS + CSI if you used snapshots)
3. Ensure your destination cluster has:

* Same `StorageClass` name used by PVCs (e.g. `longhorn`)
* `VolumeSnapshotClass` (if snapshot-based restore)

Then run:

```bash
velero restore create \
  --from-backup $BACKUP_NAME
```

---

## 7) Common checks & troubleshooting

### 7.1 Does Velero see snapshots and volume backups?

```bash
velero backup describe $BACKUP_NAME --details
```

Look for:

* `Velero-Native Snapshots:`
* `CSI Snapshots:`
* `Pod Volume Backups:`

### 7.2 StorageClass mismatch on restore

Check the PVCs in backup namespace and ensure destination cluster has same class:

```bash
kubectl get pvc -n $NAMESPACE_TO_BACKUP -o wide
kubectl get storageclass
```

### 7.3 CSI snapshot objects

```bash
kubectl get volumesnapshot -A
kubectl get volumesnapshotcontent -A
```

---

## 8) Database note (important)

Snapshots are typically **crash-consistent**. For databases:

* Prefer application-level backups (logical dump) or
* Use quiescing hooks / pre-backup commands if supported

At minimum, consider:

* Pausing writes during snapshot
* Using DB-native backup tooling

---

## 9) Minimal command summary

### Install (S3-compatible)

```bash
velero install \
  --provider aws \
  --plugins velero/velero-plugin-for-aws:v1.10.0 \
  --bucket $BUCKET \
  --secret-file ./credentials-velero \
  --backup-location-config region=$REGION,s3ForcePathStyle="true",s3Url=$S3_URL
```

### Add CSI plugin

```bash
velero plugin add velero/velero-plugin-for-csi:v0.8.0
```

### Backup namespace (no volumes)

```bash
velero backup create $BACKUP_NAME \
  --include-namespaces $NAMESPACE_TO_BACKUP \
  --snapshot-volumes=false
```

### Backup namespace + CSI snapshots

```bash
velero backup create $BACKUP_NAME \
  --include-namespaces $NAMESPACE_TO_BACKUP \
  --snapshot-volumes=true
```

### Restore

```bash
velero restore create --from-backup $BACKUP_NAME
```


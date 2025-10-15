```
git clone https://github.com/CrunchyData/postgres-operator-examples.git
cd postgres-operator-examples
```

```
kubectl apply -k kustomize/install/namespace
kubectl apply --server-side -k kustomize/install/default
```

```
kubectl -n postgres-operator get pods --selector=postgres-operator.crunchydata.com/control-plane=postgres-operator --field-selector=status.phase=Running
```

- then edit 

```
apiVersion: postgres-operator.crunchydata.com/v1beta1
kind: PostgresCluster
metadata:
  name: hippo
  namespace: postgres-operator
spec:
  postgresVersion: 16
  users:
    - name: rhino
      databases:
        - zoo
    - name: postgres     # no options needed
  instances:
    - name: instance1
      replicas: 3
      dataVolumeClaimSpec:
        storageClassName: longhorn
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 10Gi
  monitoring:
    pgmonitor: { exporter: {} }
  proxy:
    pgBouncer:
      replicas: 3
      config:
        global:
          pool_mode: transaction
      resources:
        limits:
          cpu: 500m
          memory: 2048Mi
---
apiVersion: v1
kind: Service
metadata:
  name: hippo-exporter
  namespace: postgres-operator
spec:
  selector:
    postgres-operator.crunchydata.com/cluster: hippo
    postgres-operator.crunchydata.com/instance-set: instance1
  ports:
    - name: metrics
      port: 9187
      targetPort: 9187
  clusterIP: None
```
- and then

```
kubectl apply -k kustomize/postgres
```





- how to check the master
```
kubectl -n postgres-operator get pods   -l 'postgres-operator.crunchydata.com/role=master'   -o name
```


```
 kubectl port-forward  -n postgres-operator pod/hippo-instance1-7njf-0 5555:5432 
```

```
export PGPASSWORD="$(kubectl -n postgres-operator get secret hippo-pguser-postgres -o jsonpath='{.data.password}' | base64 -d)"
```



```
psql -h 127.0.0.1 -p 5555 -U postgres -d postgres
```



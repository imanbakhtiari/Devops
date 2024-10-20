Step-by-Step Commands
Generate a Private Key for the CA:
```
openssl genrsa -out ca.key 2048
```


Create a Self-Signed CA Certificate:
```
openssl req -new -x509 -days 365 -key ca.key -out ca.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=Self-Signed CA"
```


Generate a Private Key for the Domain:
```
openssl genrsa -out private.key 2048
```


Create a Certificate Signing Request (CSR) for the Domain:

```
openssl req -new -key private.key -out request.csr -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=mail.basa.ir"
```


Sign the CSR with the CA Certificate:

```
openssl x509 -req -days 365 -in request.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out certificate.crt
```


## Summary of Files Generated
## After executing these commands, you will have the following files:

- CA Private Key: ca.key
- CA Certificate: ca.crt
- Domain Private Key: private.key
- Certificate Signing Request: request.csr (optional; used for signing)
- Signed Domain Certificate: certificate.crt

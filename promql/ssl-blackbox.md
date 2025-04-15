

```
sort(
  label_replace(
    (probe_ssl_earliest_cert_expiry{job="blackbox-ssl"} - time()) / 86400,
    "instance",
    "$1",
    "instance",
    "https://(.*)"
  )
) < 7 or
sort(
  label_replace(
    (probe_ssl_earliest_cert_expiry{job="blackbox-ssl"} - time()) / 86400,
    "instance",
    "$1",
    "instance",
    "https://(.*)"
  )
) < 30 or
sort(
  label_replace(
    (probe_ssl_earliest_cert_expiry{job="blackbox-ssl"} - time()) / 86400,
    "instance",
    "$1",
    "instance",
    "https://(.*)"
  )
) >= 30
```

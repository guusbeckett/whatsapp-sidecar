# Dockerfile for Ubuntu with xtail
Just an Ubuntu image with xtail installed, used for monitoring and restarting the WhatsApp core container.

Xtail is used to monitor the entire log folder.

Please note, this image is only tested with a WhatsApp Web/Core app combination connected to a Postgres server.

Image can be downloaded from dockerhub at https://hub.docker.com/r/guusbeckett/whatsapp-sidecar

How to use in Kubernetes:

First, make sure you've enabled `shareProcessNamespace` in your pod (pod containing WhatsApp web, WhatsApp coreapp and this sidecar). This value should be located in the same `spec` as the containers, on the same level as the containers dictionary.
This is used to be able kill the main process in the WhatsApp core container when an error is detected by the sidecar.


Add the following to your WhatsApp pod manifest;
Under `volumes` (same level as `shareProcessNamespace`):
```yaml
- name: wacore-logs
  emptyDir: {}
```
Under `volumeMounts` (in WhatsApp core app `container` value):
```yaml
- name: wacore-logs
  mountPath: /usr/local/waent/logs
```

Add the following definition as a new entry in `containers`:
```yaml
- name: sidecar
  image: proget-nwv1.cmtest.nl/dockerfeed/whatsapp/waweb:v2.23.4
  command: ["/bin/sh", "-c", "((xtail /usr/local/waent/logs/. &) | grep -q \"QSqlError(\\|57P01\") && pkill wa-service"]
  volumeMounts:
  - name: wacore-logs
    mountPath: /usr/local/waent/logs
```


# docker-centos-services
Docker Centos Services

## Usage

```yml
version: "2"

services:
  centos:
    build:
      context: ./
    image: reduardo7/centos-services
    dns: 8.8.8.8
    cap_add:
      - SYS_ADMIN
      - NET_ADMIN
      - NET_RAW
    security_opt:
      - seccomp:unconfined
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
```

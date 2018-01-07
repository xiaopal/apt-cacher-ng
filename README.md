# apt-cacher-ng docker image

## http proxy
```
docker run -d \
    -p 3142:3142 \
    -v /var/cache/apt-cacher-ng:/var/cache/apt-cacher-ng \
    xiaopal/apt-cacher-ng:latest

echo 'Acquire::http { Proxy "http://127.0.0.1:3142"; }' >/etc/apt/apt.conf.d/00proxy
apt-get update

# https proxy
cat<<EOF >/etc/apt/sources.list.d/docker.list
deb http://HTTPS///get.docker.com/ubuntu docker main
EOF

```

## mirror(1)
```
docker run -d \
    -p 3142:3142 \
    -v /var/cache/apt-cacher-ng:/var/cache/apt-cacher-ng \
    xiaopal/apt-cacher-ng:latest

cat<<EOF >/etc/apt/sources.list
deb http://127.0.0.1:3142/mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb http://127.0.0.1:3142/mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://127.0.0.1:3142/mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://127.0.0.1:3142/mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
deb http://127.0.0.1:3142/HTTPS///get.docker.com/ubuntu docker main
EOF

apt-get update

```

## mirror(remap)
```
docker run -d \
    -p 80:3142 \
    -v /var/cache/apt-cacher-ng:/var/cache/apt-cacher-ng \
    -e 'APT_REMAPS=debian debian_security docker_ce' \
    -e 'APT_REMAP_DEBIAN=http://deb.debian.org/debian /debian ; http://mirrors.aliyun.com/debian' \
    -e 'APT_REMAP_DEBIAN_SECURITY=http://security.debian.org /debian-security ; http://mirrors.aliyun.com/debian-security' \
    -e 'APT_REMAP_DOCKER_CE=/docker-ce ; http://mirrors.aliyun.com/docker-engine/apt/repo' \
    xiaopal/apt-cacher-ng:latest

cat<<EOF >/etc/apt/sources.list
deb http://127.0.0.1/debian jessie main
deb http://127.0.0.1/debian jessie-updates main
deb http://127.0.0.1/debian-security jessie/updates main
EOF

apt-get update

```


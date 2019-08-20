# Greenbone Vulnerability Management in Docker
https://github.com/dgiorgio/gvm-docker
### How to use this image
##### Run with docker-compose
```console
$ cd gvm-docker/docker-compose/stable
$ docker-compose -p gvm -f docker-compose.yml up -d
```
or
##### Run docker-compose with ansible
```console
$ cd ansible-gvm
$ ansible-playbook start_gvm.yml
```

## License

This Docker image is licensed under the BSD, see [LICENSE](LICENSE.md).

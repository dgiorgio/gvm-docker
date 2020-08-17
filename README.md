# Greenbone Vulnerability Management in Docker
https://github.com/dgiorgio/gvm-docker
![Dashboard](https://github.com/dgiorgio/gvm-docker/raw/master/images/Dashboard.png)

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
### Access
Get 'admin' password:
```console
$ docker logs gvm_gvm-gvmd_1 2> /dev/null | grep 'password:'
```
![ShowPassword](https://github.com/dgiorgio/gvm-docker/raw/master/images/ShowPassword.png)
##### Reset admin password
```console
$ docker exec -ti gvm_gvm-gvmd_1 gvmd --user=admin --new-password=gvmpass
```
![ChangePassword](https://github.com/dgiorgio/gvm-docker/raw/master/images/ChangePassword.png)

## License

This Docker image is licensed under the BSD, see [LICENSE](LICENSE.md).

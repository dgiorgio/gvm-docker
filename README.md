# Use the official project: https://greenbone.github.io/docs/latest/22.4/container/index.html

# [DEPRECATED] Greenbone Vulnerability Management in Docker
https://github.com/dgiorgio/gvm-docker
![Dashboard](https://github.com/dgiorgio/gvm-docker/raw/master/images/Dashboard.png)

### How to use this image
##### Run with docker-compose
```console
$ cd gvm-docker/docker-compose/stable
$ ./run_compose.sh
```
or
```console
$ cd gvm-docker/docker-compose/stable
$ docker-compose -p gvm --env-file "../../dockerfile/VERSIONS" -f docker-compose.yml up -d
```
##### Run docker-compose with ansible
```console
$ cd ansible-gvm
$ ansible-playbook start_gvm.yml
```
### Password
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

### Access
Access web browser: https://localhost

### Greenbone Feed Updates and system checks
Check the feed logs of the gvmd and openvas containers.
```console
docker logs -f --tail 25 gvm_gvm-gvmd_1
docker logs -f --tail 25 gvm_gvm-openvas-scanner_1
```
![UpdateSCAPDATA](https://github.com/dgiorgio/gvm-docker/raw/master/images/UpdateSCAPDATA.png)

Check the content of the pages through the GSA.
```console
https://localhost/nvts
https://localhost/cves
https://localhost/cpes
https://localhost/portlists
https://localhost/scanconfigs
```
![CheckNVTs](https://github.com/dgiorgio/gvm-docker/raw/master/images/CheckNVTs.png)

If the pages are empty, or display an error message.
You should check the update of the feeds, it may take a long time to install.

### Private feed server
You can use a private feed server to optimize updates, more details in the project below.

https://github.com/dgiorgio/gvm-feed-server

## License

This Docker image is licensed under the BSD, see [LICENSE](LICENSE.md).

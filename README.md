# Greenbone Vulnerability Management in Docker

https://github.com/dgiorgio/gvm-docker/tree/legacy
### How to use this image
```console
$ docker run -p 80:80 -p 443:443 -p 9390-9393:9390-9393 dgiorgio/gvm-docker
```
or
##### Run with docker-compose
```console
$ cd gvm-docker/docker-compose/stable
$ docker-compose -f docker-compose-master.yml up
```
or
##### Run docker-compose with ansible
```console
$ cd ansible-gvm
$ ansible-playbook start_gvm.yml
```

## Understanding the tags
#### sqlite
dgiorgio/gvm-docker: **master-20190813-stable**

| type | version | release |
| --------- | ----- | ----- |
| master - slave - sshvpn | 'date' | stable - dev |

#### postgres
dgiorgio/gvm-docker: **master-20190813-postgres-stable**

| type | version | database | release |
| --------- | ----- | ----- | ----- |
| master - slave - sshvpn | 'date' | postgres | stable - dev |

## Difference between master, slave, sshvpn
|        | master | slave | sshvpn |
| --------- | -----:| -----:| -----:|
| gvm-libs | x | x | x |
| gvm | x | x  | x |
| openvas-smb | x | x | x |
| openvas | x |  x | x |
| gsa | x |  |  |
| ssmtp | x |  |  |
| cron | x | x | x |
| sshvpn |  |  | x |

## License

This Docker image is licensed under the BSD, see [LICENSE](LICENSE.md).

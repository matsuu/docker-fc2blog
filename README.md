Docker-fc2blog
==============

Dockerfile for fc2blog

#### Requirements

* Docker
* CoreOS(optional)

#### Prepare

    git clone http://github.com/matsuu/docker-fc2blog
    cd docker-fc2blog

#### Build (CentOS)

    docker pull centos
    ./build.sh

#### Build (Gentoo)

    docker pull plabedan/gentoo-minimal
    OS=gentoo ./build.sh

#### Build (Ubuntu)

    docker pull ubuntu
    OS=ubuntu ./build.sh

#### Run

    docker run --name=fc2blog-mysql fc2blog/mysql
    docker run --name=fc2blog-apache --publish=80:80 --link=fc2blog-mysql:mysql fc2blog/apache

#### Run on fleet(CoreOS)

    sudo systemdctl start etcd.service
    sudo systemdctl start fleet.service
    fleetctl start systemd/fc2blog-mysql.service
    fleetctl start systemd/fc2blog-apache.service
    fleetctl list-units

#### See also

* [fc2blog/blog](https://github.com/fc2blog/blog)
* [Docker](https://www.docker.io/)
* [CoreOS](https://coreos.com/)

#### TODO

* ~~Unlink /admin/install.php after installation~~
* ~~Support other distributions~~
* Support log handling
* Execute mysql_secure_install
* Support MySQL Master-Slave
* ~~Integrate with fleet on CoreOS~~
* ~~Integrate with etcd+fleet on CoreOS~~
* Support Nginx

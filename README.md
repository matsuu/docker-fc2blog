Docker-fc2blog
==============

Dockerfile for fc2blog

#### Requirements

* Docker
* CoreOS(optional)

#### Installation (CentOS)

    docker pull centos
    git clone http://github.com/matsuu/docker-fc2blog
    cd docker-fc2blog
    cd centos
    vi run.sh
    sh run.sh

#### Installation (Gentoo)

    docker pull plabedan/gentoo-minimal
    git clone http://github.com/matsuu/docker-fc2blog
    cd docker-fc2blog
    cd gentoo
    vi run.sh
    sh run.sh

#### Installation (Ubuntu)

    docker pull ubuntu
    git clone http://github.com/matsuu/docker-fc2blog
    cd docker-fc2blog
    cd ubuntu
    vi run.sh
    sh run.sh

#### CoreOS + fleet

    sudo systemdctl start fleet.service
    fleetctl start systemd/fc2blog-mysql.service
    fleetctl start systemd/fc2blog-apache.service
    fleetctl list-units

#### See also

* [fc2blog/blog](https://github.com/fc2blog/blog)
* [Docker](https://www.docker.io/)
* [CoreOS](https://coreos.com/)

#### TODO

* Unlink /admin/install.php after installation
* ~~Support other distributions~~
* Support log handling
* Execute mysql_secure_install
* Support MySQL Master-Slave
* ~~Integrate with fleet on CoreOS~~
* Integrate with etcd+fleet on CoreOS
* Support Nginx

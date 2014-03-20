ocker-fc2blog
==============

Dockerfile for fc2blog

#### Requirements

* Docker

#### Installation (CentOS)

    docker pull centos
    git clone http://github.com/matsuu/docker-fc2blog
    cd docker-fc2blog
    cd centos
    vi run.sh
    sh run.sh

#### Installation (Ubuntu)

    docker pull ubuntu
    git clone http://github.com/matsuu/docker-fc2blog
    cd docker-fc2blog
    cd ubuntu
    vi run.sh
    sh run.sh

#### See also

* [fc2blog/blog](https://github.com/fc2blog/blog)
* [Docker](https://www.docker.io/)

#### TODO

* Unlink /admin/install.php after installation
* Support other distributions
* Support log handling
* Execute mysql_secure_install
* Support MySQL Master-Slave
* Integrate with etcd+fleet for CoreOS
* Support Nginx

[<img src='/wmap_logo.jpg' width='350' height='350'>](https://github.com/yangsec888/www_wmap)
=====================

- [Wmap Web Portal](#wmap-web-portal)
- [Demo](#demo)
  - [Demo Instance Access](#demo-instance-access)
- [Technology Stacks](#technology-stacks)
- [Build and Run in Docker](#build-and-run-in-docker)
  - [Why Docker](#why-docker)
  - [Run In Docker](#run-in-docker)
  - [Docker Trouble-shooting](#docker-trouble-shooting)
  - [Build In Docker (Optional)](#build-in-docker-optional)
- [Linux Deployment](#linux-deployment)
- [Usage](#usage)
- [To Dos](#to-dos)

---

### Wmap Web Portal

The web app is part of the [OWASP Web Mapper Project](https://www.owasp.org/index.php/OWASP_Web_Mapper_Project). It's developed to help discover and keep track of web application asset with scale.

To further explore the full power of OWASP Wmap library, please refer to the <a href="https://github.com/yangsec888/wmap" target="_blank"> WMAP </a> Git repository.


### Demo

Click to watch the Youtube video below to see how to perform a successful application asset discovery:
[![Web Mapper Demo](https://img.youtube.com/vi/TL1occsk3Fc/0.jpg)](https://www.youtube.com/watch?v=TL1occsk3Fc "Web Mapper Demo")

#### Demo Instance Access
The application is deployed into a demo instance at [www.wmap.io](https://www.wmap.io/). You can logon to it by using demo user 'admin' and password 'admin123'.


### Technology Stacks

WMAP Web Portal depends on a number of open source projects to work properly:

* [Ruby on Rails 5.x](https://rubyonrails.org/) - A web-application framework that includes everything.
* [Devise](https://github.com/plataformatec/devise/wiki) - Rails authentication and user session management solution.
* [Twitter Bootstrap](https://getbootstrap.com/) - A great UI boilerplate for modern web apps.
* [jQuery](https://jquery.com/) - Great JavaScript library for JavaScript integration.
* [CodeMirror](https://codemirror.net/) - CodeMirror is a versatile text editor implemented in JavaScript.
* [jstree](https://www.jstree.com/) -  jsTree is a JavaScript based tree UI implementation.
* [Sidekiq](https://github.com/mperham/sidekiq) - A background processing manager (asynchronous and non-blocking IO) for RoR.
* [Redis](https://redis.io/) - A high performance in-memory key value pair data store.
* [MariaDB](https://mariadb.org/) - A community supported fork of MySQL relational database.
* [wmap](https://github.com/yangsec888/wmap) - Backend Web Mapper gem for the heavy lifting.
* [Postfix](http://www.postfix.org/) - Background email notification service.

### Build and Run in Docker

If you have [docker engine](https://docs.docker.com/install/) ready, you can have the app build and run in no time.

#### Why Docker
The docker is becoming popular in the development community. Because it can standadize the developing, building for everyone. The technology may also help deploy your customize app into your favorite cloud infrastructure later on.

#### Run In Docker

'docker-compose up' would run the app from the containers.
It should produce the output similar to below:
```sh
$ docker-compose up
Starting wmap_db    ... done
Starting wmap_redis ... done
Starting www_wmap_sidekiq_1 ... done
Starting wmap_web           ... done
Starting www_wmap_nginx_1   ... done
Attaching to wmap_db, wmap_redis, www_wmap_sidekiq_1, wmap_web, www_wmap_nginx_1
wmap_db    | mariadb 20:25:19.20
...
```
Open a local browser and point it at 'http://localhost/'. You will see the app in action.

Depend on the cloud infrastructure you use, you might need to customize the containers further before the deployment. Please feel free to contact me if you need the help.

#### Docker Trouble-shooting
Following the onscreen error log when you bring up the containers. You can use the following docker command to verify the containers are running in your host
```
$ docker ps
CONTAINER ID   IMAGE                                COMMAND                  CREATED          STATUS          PORTS                    NAMES
8d4681f9dfef   yangsec888/www_wmap_sidekiq:latest   "sh ./config/docker/…"   48 minutes ago   Up 48 minutes   3000/tcp                 www_wmap_sidekiq_1
59769eec9fbb   nginx:1.16.1                         "nginx -g 'daemon of…"   2 hours ago      Up 48 minutes   0.0.0.0:80->80/tcp       www_wmap_nginx_1
6845611441b5   yangsec888/www_wmap_web:latest       "sh ./config/docker/…"   2 hours ago      Up 48 minutes   0.0.0.0:3000->3000/tcp   wmap_web
a1158c1d52e5   redis:alpine                         "docker-entrypoint.s…"   4 hours ago      Up 48 minutes   6379/tcp                 wmap_redis
293f77c2c5f5   bitnami/mariadb:10.3                 "/opt/bitnami/script…"   4 hours ago      Up 48 minutes   0.0.0.0:3306->3306/tcp   wmap_db
```
If you running into problem, you can refer to the [docker online document](https://docs.docker.com) for further assistance.


#### Build in Docker (Optional)   
```sh
$ git clone https://github.com/yangsec888/www_wmap.git
$ cd www_wmap
$ docker-compose build
```
'docker-compose build' will build the containers for the app.


### Linux Deployment   
The project can be built, deployed and run in the linux distribution natively. For more information on local installation, please use the deployment example at [Setup.md](Setup.md) for your reference.


### Usage
Under the home page, click on "Start" button to start. Follow the on-screen instructions, in order to launch a successfully WMAP discovery. The discovery result should be tracked under the "Discovery" menu tab.


### To Dos

 - Package this up into a docker containers
 - Write (integration, deployment) tests
 - Enhance performance (squeeze the next bit out of cpu / network IO )
 - Upgrade to Rails 6.x
 - Fix bugs!

[<img src='/wmap_logo.jpg' width='350' height='350'>](https://github.com/yangsec888/www_wmap)
=====================

- [Wmap Web Portal](#wmap-web-portal)
- [Technology Stacks](#technology-stacks)
- [Build and Run in Docker](#build-and-run-in-docker)
- [Local Installation](#local-installation)
- [Demo Instance](#demo-instance)
- [Usage](#usage)
- [To Dos](#to-dos)

---

### Wmap Web Portal

The web app is part of the [OWASP Web Mapper Project](https://www.owasp.org/index.php/OWASP_Web_Mapper_Project). It's developed to help discover and keep track of web application asset with scale.

To further explore the full power of OWASP Wmap library, please refer to the <a href="https://github.com/yangsec888/wmap" target="_blank"> WMAP </a> Git repository.


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
The docker technology may help deploy your customize app into your favorite cloud infrastructure later on.

#### Build in Docker   
```sh
$ git clone https://github.com/yangsec888/www_wmap.git
$ cd www_wmap
$ docker-compose build
```
'docker-compose build' will build the containers for the app.

#### Run In Docker

'docker-compose up' would run the app from the containers.
It should produce the output similar to below:
```sh
$ docker-compose up
Starting redis                    ... done
Starting wmap_db                  ... done
Recreating www_wmap_postfix_587_1 ... done
Recreating www_wmap_sidekiq_1     ... done
Recreating www_wmap               ... done
Attaching to redis, wmap_db, www_wmap_postfix_587_1, www_wmap_sidekiq_1, www_wmap
...
```
Open a local browser and point it at http://localhost:3000/. You will see the app in action.

Depend on the cloud infrastructure you use, you might need to customize the containers further before the deployment.
Please feel free to contact me if you need the help.

### Local Installation

WMAP App requires [Ruby on Rails](http://rubyonrails.org) v5.2.x, [MariaDB](https://www.mysql.com/) v10.4.x database, [Redis](https://redis.io/) 5.x in-memory data store, in order to run properly.

Install the environment dependencies, and ensure the database server is running. For example, in our Linux / Mac laptop,

#### Install MariaDB v10.4.x
* [How to Install MariaDB in Ubuntu 18.0.4](https://linuxize.com/post/how-to-install-mariadb-on-ubuntu-18-04/)

* Instal the mysql client support
```sh
$ sudo apt-get install libmysqlclient-dev
$ gem install mysql2 -v '0.5.2' --source 'https://rubygems.org/'
```

#### Install and Redis v5.x Server
```sh
$ sudo apt-get install redis-server redis-tools
```

#### Start the Rails Server

```sh
$ cd www_wmap
$ bundle install
$ rake db:create
$ rake db:migration
$ rails server
```

### Demo Instance
The application is deployed into a demo instance at [www.wmap.io](https://www.wmap.io/). You can logon to it by using demo user 'admin' and password 'admin123'.


####  Demo Instance Setup Details  
For more information on local installation, please use my demo instance deployment at [Setup.md](Setup.md) for your reference.


### Usage
Under the home page, click on "Start" button to start. Follow the on-screen instructions, in order to launch a successfully WMAP discovery. The discovery result should be tracked under the "Discovery" menu tab.

### To Dos

 - Package this up into a docker containers
 - Write (integration, deployment) tests
 - Enhance performance (squeeze the next bit out of cpu / network IO )
 - Upgrade to Rails 6.x
 - Fix bugs!

[<img src='/wmap_logo.jpg' width='350' height='350'>](https://github.com/yangsec888/wmap)
=====================

- [Wmap Web Portal](#wmap-web-portal)
- [Technology Stacks](#technology-stacks)
- [Local Installation](#local-installation)
- [Production Instance Setup](#production-instance-setup)
- [Usage](#usage)
- [To Dos](#to-dos)

---

### Wmap Web Portal

The web app is based on the OWASP Wmap App. It's developed to help keep track of web application asset. To further explore the full power of OWASP Wmap library, please refer to the <a href="https://github.com/yangsec888/wmap" target="_blank"> WMAP </a> Got repository.


### Technology Stacks

WMAP Web Portal depends on a number of open source projects to work properly:

* [Ruby on Rails 5.x](https://rubyonrails.org/) - A web-application framework that includes everything.
* [Devise](https://github.com/plataformatec/devise/wiki) - Rails authentication and user session management solution.
* [Twitter Bootstrap](https://getbootstrap.com/) - A great UI boilerplate for modern web apps.
* [jQuery](https://jquery.com/) - Great JavaScript library for JavaScript integration.
* [CodeMirror](https://codemirror.net/) - CodeMirror is a versatile text editor implemented in JavaScript.
* [jstree](https://www.jstree.com/) -  jsTree is a JavaScript based tree UI implementation.
* [wmap](https://github.com/yangsec888/wmap) - Backend Web Mapper gem for the heavy lifting.


### Local Installation

WMAP App requires [Ruby on Rails](http://rubyonrails.org) v5.2.1 and [MariaDB](https://www.mysql.com/) database to run properly.

Install the environment dependencies, and ensure the database server is running. For example, in our Linux / Mac laptop,

```sh
$ cd www_wmap
$ bundle install
$ rake db:create
$ rake db:migration
$ rails server
```

### Production Instance Setup
The application is deployed into production instance at [wmap](https://wmap.io/). The running environment setup can be found [here](Setup.md)


### Usage
Under the home page, click on "Start" button to start. Follow the on-screen instructions, in order to launch a successfully WMAP discovery. The discovery result should be tracked under the "Discovery" menu tab.

### To Dos

 - Package this up into a docker container
 - Write defensible code :)
 - Write (integration, deployment) tests
 - Enhance performance (squeeze the next bit out of cpu / network IO )
 - Fix bugs!

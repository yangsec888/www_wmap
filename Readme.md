# WMAP Demo App

The web app is developed under Ruby on Rails framework, in order to showcase the basic usage of the wmap library. To explore further and utilize the full power of wmap library, please refer to the Documents section.


### Technology Stacks

WMAP Demo App depends on a number of open source projects to work properly:

* [Ruby on Rails] - A web-application framework that includes everything!
* [Twitter Bootstrap] - great UI boilerplate for modern web apps
* [devise] - Rails app authentication and user session management solution
* [wmap](https://github.com/yangsec888/wmap) - Web Mapper gem of course


WMAP Demo App is open source with a [www_wmap] project on GitHub.

### Local Installation

WMAP Demo App requires [Ruby on Rails](http://rubyonrails.org) v5.1.4 and [Mysql](https://www.mysql.com/) database to run.

Install the environment dependencies, and ensure the database server is running. For example, in our Linux / Mac laptop,

```sh
$ cd www_wmap
$ bundle install
$ rake db:create
$ rake db:migration
$ rails server
```

### Live Demo

* [Demo Wmap Portal](http://wmap.io/) See this demo app in the action.


### Usage
Under the home page, click on "Start" button to start. Follow the on-screen instructions, in order to launch a successfully WMAP discovery. The discovery result should be tracked under the "Discovery" menu tab.

### Todos

 - Write protection code :)
 - Write more features (refer to wmap bin utilities)
 - Write (unit, deployment) tests
 - Enhance Performance
 - Fix Bugs!

### License
----
https://creativecommons.org/licenses/

**Free Software**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [wmap]: <https://github.com/yangsec888/wmap>
   [www_wmap]: <https://github.com/yangsec888/www_wmap>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [Ruby on Rails]: <http://rubyonrails.org>
   [devise]: <https://github.com/plataformatec/devise>

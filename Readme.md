# WMAP Demo App

The web app is developed under Ruby on Rails framework, in order to showcase the basic usage of the wmap library. To explore further and utilize the full power of wmap library, please refer to the Documents section.


### Tech

WMAP Demo App uses a number of open source projects to work properly:

* [Ruby on Rails] - A web-application framework that includes everything!
* [Twitter Bootstrap] - great UI boilerplate for modern web apps
* [devise] - Rails app authentication and user session management solution
* [wmap](https://github.com/yangsec888/wmap) - Web Mapper gem of course


WMAP Demo App is open source with a [www_wmap] project on GitHub.

### Local Installation

WMAP Demo App requires [Ruby on Rails](http://rubyonrails.org) v4.2+ and [Mysql](https://www.mysql.com/) database to run.

Install the environment dependencies, and ensure the database server is running. For example, in our Linux / Mac laptop,

```sh
$ cd www_wmap
$ bundle install
$ rake db:create
$ rake db:migration
$ rails server
```

### Free Cloud Deployment

It would be also easy to deploy the application to cloud. Here are the example based on [Heroku](https://www.heroku.com) and [GitHub](https://github.com). You can use your favorite repository and web hosting service. For the benefit of the most users, we will do it using the web dashboard for those non technical sophisticate users.  But if you are a IT specialist, it is your call to fly in CLI mode.

Heroku Deployment Example:
First of all, you need to register a [GitHub](https://github.com) account and a [Heroku](https://www.heroku.com) account first.
 1. Login you GitHub account, start a project, enter Repository name and Description (optional).
 2. Choose import code from another repository, enter the clone URL with "https://github.com/yangsec888/www_wmap.git" which is the url of this project the GitHub. You can also visit it on the GitHub and see the URL via "Clone or Download" button.
 3. Click begin import and wait until GitHub showing "Importing complete! Your new repository XXX/YYY is ready."  Now you have a copy of the project source codes under your own GitHub account.
 4. Next, you will deploy it into Heroku. It is quite easy and straightforward since Heroku deployment process can be linked to your GitHub account.
 5. Login you Heroku account, Create a new app, choose GitHub as Deployment method in the Deploy tab of apps in the Heroku Dashboard, press 'Connect to GitHub' button.
 6. You will need to use GitHub credential to connect this app to GitHub to enable code diffs and deploy.
 7. After successful connection, you can see your Github username in repository selections before repo-name field. You need to put your repository name in Github, then 'search' and 'connect' your github project.
 8. Because the web app is built on top of the MySQL sever which is optional for Heroku account, we need to enable it in Heroku.  In the Resources tab of apps in the Heroku Dashboard, search for 'ClearDB MySQL' in 'Add-ons' and provision. You will need to add your payment information for the verification purpose only (the free plan is sufficient for us).  [cleardb installation reference.](https://devcenter.heroku.com/articles/cleardb)
 9. After the add-on cleardb MySQL component is successfully installed, we need to configure MySQL add-on in the Settings tab. Add below two links to Buildpacks.
  * https://github.com/heroku/heroku-buildpack-ruby
  * https://github.com/gunpowderlabs/buildpack-ruby-rake-deploy-tasks
10. In Config Variables
* Change "CLEARDB_DATABASE_URL" value from "mysql://xyz" to "mysql2://xyz"
* Add [key]DEPLOY_TASKS => [value]db:migrate db:seed
* Add [key]DATABASE_URL => [value] same value as CLEARDB_DATABASE_URL
11. Once the MySQL database add-on is enable, the database will be automatically created for you. However, you still need to create the tables for the app. Under menu 'More' in the upper right corner, choose 'Run console', enter Heroku 'bash' environment, run command 'rake db:migrate'
12. Finally, Go back to Deploy tab,  and click Deploy Branch "master" in manually at the bottom. Once deploy, you can open your Online Quiz App to examine. *Congratulations!*

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

   [www_wmap]: <https://github.com/yangsec888/www_wmap>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [jQuery]: <http://jquery.com>
   [Ruby on Rails]: <http://rubyonrails.org>
   [devise]: <https://github.com/plataformatec/devise>

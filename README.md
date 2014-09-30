# Introduction

*gitoku* (name borrowed from git and Hiroku) is a small set of scripts to allow easy provisioning of rails-capable servers and deployment of rails applications via git push command.

I'm planning on splitting the project into two parts: gitoku-core and gitoku-shell.

*gitoku-core* is the part of gitoku where the git push post-processing is handled and is very much runnable alone on a machine with some "small" ruby/git footprint.

This is also what's already working in the current version.

*gitoku-shell* (the shell around the core, so-to-speak) is a suite of scripts to provide a very simple servers for your projects very fast. Currently I use the packed Vagrantfile to create a server.

These provisioned servers shall be enabled to provide some very basic functions:

* Create new projects (via addproject.rb, partly working).
* Remove projects
* Get list of projects including their status

Every project should automatically be added as a hostname alias to the /etc/hosts file to be served via *dnsmasq*. Also each project should be served through a nginx server block. This way you can create a new project and have it available as project-name.your-host.com (or whatever) when you point your DNS lookups to your-host.com.

For later I could also think of a solution to use nsupdate to update some BIND9 service. But that's for way later.


## Roadmap

* allow `Gitokufile` file to configure the rails runtime environment (dependencies, webrick?, thin?, unicorn?, passenger?...).
* setting of runtime environment via some mechanism
* restarting of server according to `Gitokufile`
* setting of database connection via environment
* adding of projects (addproject.rb)
* remove a project
* list available projects
* modify /etc/hosts to include projects


## Help out
Help is definitly warmly appreciated. Just send me your comments, issues or pull requests.

# How to bootstrap the server

Instead of you manually installing a server and all packages required in order to fire up your rails application you can just run a series of commands and let the provided scripts work for you.

## Using vagrant

Just run `vagrant up` inside the git folder. You'll get a new machine up and running with everything you need.

The machines has support for bundling rails apps using `mysql2`, `pg`, and `sqlite3` gems.
Also `rbenv` is installed by default using Ruby 2.1.2 globally. 

I'll enhance this howto as soon as I have a plan, really... :)

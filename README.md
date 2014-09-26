# Introduction

*gitoku* (name borrowed from git and Hiroku) is a small set of scripts to allow easy provisioning of rails-capable servers and deployment of rails applications via git push command.

Currently vagrant and ssh-based bootstrapping is supported (very experimental, both).

I'm woking on this.


## Roadmap

* allow `Gitokufile` file to configure the rails runtime environment (dependencies, webrick?, thin?, unicorn?, passenger?...).
* enable setting of runtime environment via some mechanism
* enable restarting of server according to `Gitokufile`



## Help out
Help is definitly warmly appreciated. Just send me your comments, issues or pull requests.




# How to bootstrap the server

Instead of you manually installing a server and all packages required in order to fire up your rails application you can just run a series of commands and let the provided scripts work for you.

## Using vagrant

Just run `vagrant up` inside the git folder. You'll get a new machine up and running with everything you need.

The machines has support for bundling rails apps using `mysql2`, `pg`, and `sqlite3` gems.
Also `rbenv` is installed by default using Ruby 2.1.2 globally. 
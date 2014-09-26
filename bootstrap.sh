#!/usr/bin/env bash

# install all the little helpers needed
echo "Updating System"
apt-get -qq update
apt-get -qq install -y libssl-dev build-essential libsqlite3-dev git curl libpq-dev libmysqlclient-dev

if [ -s "/vagrant/initial-profile" ] ; then
	# add to root's profile
	cat /vagrant/initial-profile >> /root/.profile
	# set up initial user preferences
	cat /vagrant/initial-profile >> /etc/skel/.profile
else 
  if [ -s "initial-profile" ] ; then
		# add to users's profile
		cat initial-profile >> /${USER}/.profile
		# add to root's profile
		cat initial-profile >> /root/.profile
		# set up initial user preferences
		cat initial-profile >> /etc/skel/.profile
	  rm initial-profile
	else
		echo "ERROR: No updates for the user profiles found. Something is WRONG!"
	  exit		
  fi
fi

# install rbenv to manage ruby versions 
git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
git clone https://github.com/sstephenson/rbenv-gem-rehash.git /usr/local/rbenv/plugins/rbenv-gem-rehash

export RBENV_ROOT=/usr/local/rbenv
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"
export GEM_HOME="$HOME/.gem"
export GEM_PATH="$HOME/.gem"
export PATH="$HOME/.gem/bin:$PATH"

# create a working user
useradd git -d /var/git -m -p git

rbenv install 2.1.2
rbenv global 2.1.2

echo "Checking ruby version for user git."
su -lc "ruby -v" git



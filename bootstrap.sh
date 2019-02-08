#!/bin/bash
# Preparation work
sudo yum install -y epel-release
sudo yum update
sudo yum groupinstall -y "Development tools"
sudo yum install -y vim
sudo yum install -y wget
sudo yum install -y screen

# For nginx
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# JS runtime
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum -y install nodejs

# Dependencies for gems
sudo yum install -y xorg-x11-server-Xvfb
sudo yum install -y qtwebkit-devel
sudo ln -s /usr/lib64/qt4/bin/qmake /usr/bin/qmake
# dependencies for ruby build
sudo yum install -y gcc bzip2 openssl-devel libyaml-devel libffi-devel
sudo yum install -y readline-devel zlib-devel gdbm-devel ncurses-devel

# project setup
git clone https://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
sudo chown vagrant .rbenv -R
echo 'export PATH="/home/vagrant/.rbenv/bin:$PATH"' >> /home/vagrant/.bash_profile
echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bash_profile
source /home/vagrant/.bash_profile
git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
git clone https://github.com/sstephenson/rbenv-gem-rehash.git /home/vagrant/.rbenv/plugins/rbenv-gem-rehash
git clone https://github.com/sstephenson/rbenv-vars.git /home/vagrant/.rbenv/plugins/rbenv-vars
sudo chown vagrant .rbenv -R
rbenv install -v 2.3.3
rbenv shell 2.3.3
rbenv global 2.3.3
rbenv rehash

# for postgres
sudo yum install -y postgresql-server
sudo yum install -y postgresql-devel
sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql
cd ~postgres/
sudo -i -u postgres
sudo -u postgres psql -c "create user nusskylab SUPERUSER login password 'nusskylab';"
#exit
sudo sed -i 's/peer/md5/g' /var/lib/pgsql/data/pg_hba.conf
sudo systemctl restart postgresql

#install rails
cd /vagrant
gem install bundler -v 1.17.3
bundle update

echo "Inserting dummy tokens to run rails"
sh ./dummyToken.sh

source ~/.bash_profile

#populate with rails data
echo "Populating rails databases"
bundle exec rake db:create
bundle exec rake db:migrate
echo "Testing rails console"
rails console

# setup nginx forwarding
block="
    server {
        listen 80;
        server_name localhost;
        root /home/vagrant/sync/public; # the path to your app directory + /public
                                     # the default Rails public folder in an app

        location / {
            proxy_pass http://127.0.0.1:9292;
            proxy_set_header Host http://127.0.0.1:9292;
        }

        location ~* ^/assets/ {
            # Per RFC2616 - 1 year maximum expiry
            expires 1y;
            add_header Cache-Control public;

            # Some browsers still send conditional-GET requests if there's a
            # Last-Modified header or an ETag header even if they haven't
            # reached the expiry date sent in the Expires header.
            add_header Last-Modified \"\";
            add_header ETag \"\";
            break;
        }
    }
"

echo "$block" | sudo tee /etc/nginx/conf.d/nusskylab.conf
sudo systemctl restart nginx

# Note that for development, nginx is not needed.
# some other configuration for nginx may be needed such as disable SELinux,
# disable default index.html. Also remember to run as production server

# for development, remember to user `rails server -b 0.0.0.0` to make server
# bind to 0.0.0.0

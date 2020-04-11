This is a Wiki guiding you through the process of setting up production server with stack: Nginx, puma, Postgres on CentOS.

Please recall that the version requirements for the four software are:
* Nginx
* Puma
* Postgres

So first, install Nginx with the the following command:
```
sudo yum install -y epel-release
sudo yum update
# installation for general use
sudo yum groupinstall -y "Development tools"
sudo yum install -y vim
sudo yum install -y wget
sudo yum install nginx
```

Make sure other processes are not taking port 80(for example, Apache httpd) by turning them off or configure them to listen on other ports instead. Note that the School of Computing requires virtual machines to only use the standard port 80 for http connections. Then start Nginx with:
```
service nginx start
service nginx status -l  # for checking status of the server
```

Clone the repo by
```
git clone https://github.com/nusskylab/nusskylab.git
```

So to run puma | rails application, you need a Ruby interpreter installed and you should install it. The recommended way is to have a Ruby version manager like rvm or rbenv. The instruction for installing rbenv is as follows:
```
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
# Ubuntu Desktop note: Modify your ~/.bashrc instead of ~/.bash_profile.
# Zsh note: Modify your ~/.zshrc file instead of ~/.bash_profile.
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
# Restart your shell so that PATH changes take effect
type rbenv
# for rbenv install: ruby-build
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
# rbenv-gemrehash
git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
# rbenv-vars
git clone https://github.com/sstephenson/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars
```

For Postgres:
```
yum install postgresql-server
yum install postgresql-devel
# initdb and add postgres to startup
sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql
# Or refer to here:http://www.postgresql.org/download/linux/redhat/ for more/newer versions
```

There are also additional steps for Postgres user's creation and authentication settings:
```
sudo -i -u postgres
psql -c "create user nusskylab with createdb login password 'nusskylab';"
exit
# change default local authentication to md5 so that we can login as nusskylab by our password
sudo sed -i 's/peer/md5/g' /var/lib/pgsql/data/pg_hba.conf
sudo systemctl restart postgresql
```

And some requirements for particular gems:
```
yum install xorg-x11-server-Xvfb
yum install qtwebkit-devel
# linking required for CentOS
sudo ln -s /usr/lib64/qt4/bin/qmake /usr/bin/qmake
# JS runtime, for uglify-js
curl --silent --location https://rpm.nodesource.com/setup_5.x | sudo bash -
sudo yum -y install nodejs
```

Navigate to the cloned app folder and run <code>bundle install</code> for installing all gems.
Then setup the database by first changing the configuration for database in config/database.yml to match with your Postgres super user credentials(you can use manually create 3 databases for one user and use that user's credentials and omit the db:create step) and run:
```
bundle exec rake db:create
bundle exec rake db:migrate
```

Also you need to make sure secrects.yml and other environmental variables are set. For environmental variables, see rbenv-vars's use.

Run <code>./server.sh</code> to start up the production server, which listens on port 9292. Then configure Nginx to forward requests to 9292. A sample forward declaration for the server in /etc/nginx/nginx.conf looks like:
```
upstream my_app {
  server 127.0.0.1:9292;  # or the port you configured in puma configuration file
}

server {
  listen 80;
  server_name my_app_url.com; # change to match your URL, or localhost for simplicity
  root /var/www/my_app/public; # the path to your app directory + /public
                               # the default Rails public folder in an app

  location / {
    proxy_pass http://my_app; # match the name of upstream directive which is defined above
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }

  location ~* ^/assets/ {
    # Per RFC2616 - 1 year maximum expiry
    expires 1y;
    add_header Cache-Control public;

    # Some browsers still send conditional-GET requests if there's a
    # Last-Modified header or an ETag header even if they haven't
    # reached the expiry date sent in the Expires header.
    add_header Last-Modified "";
    add_header ETag "";
    break;
  }
}
```

Run <code>service nginx retart</code> for reloading the nginx server and you are done~

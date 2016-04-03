# Preparation work
sudo yum install -y epel-release
sudo yum update
sudo yum groupinstall -y "Development tools"
sudo yum install -y vim
sudo yum install -y wget

# For nginx
sudo yum install -y nginx

# for postgres
sudo yum install -y postgresql-server

# Dependencies for gems
sudo yum install -y xorg-x11-server-Xvfb
sudo yum install -y qtwebkit-devel
# dependencies for ruby build
sudo yum install -y gcc bzip2 openssl-devel libyaml-devel libffi-devel
sudo yum install -y readline-devel zlib-devel gdbm-devel ncurses-devel

git clone https://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.bash_profile
echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bash_profile
source /home/vagrant/.bash_profile
git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
git clone https://github.com/sstephenson/rbenv-gem-rehash.git /home/vagrant/.rbenv/plugins/rbenv-gem-rehash
git clone https://github.com/sstephenson/rbenv-vars.git /home/vagrant/.rbenv/plugins/rbenv-vars
rbenv install 2.2.1
rbenv shell 2.2.1
gem install bundler
cd /home/vagrant/sync
bundle install

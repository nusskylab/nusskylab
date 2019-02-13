The recommended installation procedure in setup using Vagrant. 
However, if you decide to not use vagrant, this is an installation guide to help you run the app on your local machine for Mac OS.

_Tested by [Bok Woon](https://github.com/bokwoon95) as of 2019 Feb 13 for macOS Mojave._

# Prerequisites
Make sure you have Homebrew, if not go [install it](https://brew.sh).  

# Installing PostgreSQL
```
$ brew install postgresql
```

# Installing Ruby
macOS Mojave already comes with a system ruby version 2.3.7 built in, but we specifically need ruby 2.3.3 so we will have to use a ruby version manager to install this older version of ruby.

Using a a ruby version manager is not too difficult as long as you use `rbenv` and not `RVM` (which hijacks your `cd` command and is generally a Bad Idea for newcomers).

**Follow the intructions on [rbenv's github page](https://github.com/rbenv/rbenv) to use homebrew to install `rbenv` for macOS.**

Using `rbenv` is simple. Run the below commands to download ruby 2.3.3 and configure nusskylab's project directory to use the downloaded ruby 2.3.3:
```
cd path/to/nusskylab/ # navigate to where you cloned 'nusskylab' to
rbenv versions        # show all versions of ruby that you have downloaded
rbenv version         # show which version of ruby you are currently using
rbenv install --list  # displays all available versions of ruby you can download
rbenv install 2.3.3   # downloads ruby 2.3.3
rbenv local 2.3.3     # sets current directory (and all subdirectories) to use ruby 2.3.3
```
The thing to note is that whenever you run `ruby local <version number>`, the file `.ruby-version` will be created that stores `<version number>` in it. This is how `rbenv` knows which version of ruby to switch to everytime you navigate into this directory.

**Note: anytime a `ruby/gem/bundler` command throws an unexpected error not mentioned here, always check you are using the correct ruby version with `ruby -v`. You should see the output `ruby 2.3.3p222 (2016-11-21 revision 56859) [x86_64-darwin18]`. Every ruby related command must be run while ruby 2.3.3 is active.  
This is because your computer might sometimes revert to system ruby 2.3.7 silently without telling you. If you are not using ruby 2.3.3 simply run `rbenv local 2.3.3` to switch back to ruby 2.3.3.**

# Installing Bundler
```
gem install bundler
```

# Installing Xcode and setting the correct version
The Xcode IDE provides certain command line tools that are needed for development (even if it doesn't use Xcode itself). It used to be that you had to download the entire ~5GB Xcode application to use those command line tools, but now Apple provides a separate 'Command Line Tools for Xcode' package which is only about ~180MB. However some things break if you try to use the standalone Command Line Tools, and for that reason we are going to have to install the entire Xcode.app instead for its Command Line Tools.

Specifically we need Xcode 9.4, because only [Xcode 9.4 works](https://stackoverflow.com/a/53642942) for Qt 5.5, which is needed for `qmake`, which is needed for the `capybara-webkit` gem. It doesn't matter if you already have Xcode 10 or some other version installed, you can manage multiple versions of Xcode on the same machine.  

**Install Xcode 9.4 from [https://developer.apple.com/download/more/?name=Xcode](https://developer.apple.com/download/more/?name=Xcode).** 

Sign up for an Apple Developer Account if you don't have one already. **Extract Xcode.app from the zip file, then rename it to Xcode9.4.app so that you don't confuse it with other Xcode versions on your computer.** It is up to you where you want to place this Xcode.app application, but you need to note down where you placed it. I suggest you place it in `/Applications/Xcode9.4.app`.

Once you have installed Xcode 9.4, you need to set the Command Line Tools you are using to Xcode 9.4. To check which Command Line Tools you are currently using, run `xcode-select --print-path`. You might see something like this, if you had previously installed the standalone Command Line Tools before Xcode:
```
$ xcode-select --print-path
/Library/Developer/CommandLineTools
```
To switch it to Xcode 9.4, run `sudo xcode-select --switch <Xcode9.4.app's location>`. If you installed Xcode9.4.app under /Applications/ like I suggested, the command you need to run is:
```
$ sudo xcode-select --switch /Applications/Xcode9.4.app
```
To check if you switched paths properly, run `xcode-select --print-path again`. You should see that it has been updated to Xcode 9.4:
```
$ xcode-select --print-path
/Applications/Xcode9.4.app/Contents/Developer
```
Then, run `sudo xcodebuild -license` to view and accept the license for Xcode 9.4. Press space a few times until you reach the end of the document, then type 'agree' and press enter.

# Installing Qt
**Homebrew has [removed Qt 5.5 from its list](https://github.com/thoughtbot/capybara-webkit/issues/1072#issuecomment-425716220), as such it is better to download Qt 5.5 directly from their website: https://download.qt.io/archive/qt/5.5/5.5.0/qt-opensource-mac-x64-clang-5.5.0.dmg. You will need to sign up for a Qt account. Run the installer and let it finish.** Then symlink the installed `qmake` binary into `/usr/local/bin/` by running the command:
```
$ ln -s ~/Qt5.5.0/5.5/clang_64/bin/qmake /usr/local/bin/qmake
```

Also, you have to change a line in a Qt config file. Open this file in any editor you like:
```
~/Qt5.5.0/5.5/clang_64/mkspecs/features/mac/default_pre.prf
```
Search for this line:
```
isEmpty($$list($$system("/usr/bin/xcrun -find xcrun 2>/dev/null")))      # Search for this line
```
Replace 'xcrun' with 'xcodebuild':
```
isEmpty($$list($$system("/usr/bin/xcrun -find xcodebuild 2>/dev/null"))) # Replace it with this line
```
Check if you can access `qmake` in the terminal by running
```
$ qmake
Usage: qmake [mode] [options] [files]

QMake has two modes, one mode for generating project files based on
some heuristics, and the other for generating makefiles. Normally you
shouldn't need to specify a mode, as makefile generation is the default
mode for qmake, but you may use this to test qmake on an existing project

...
```
If you get something like `qmake: command not found`, it means you either didn't symlink qmake properly or you didn't install Qt properly.

# Installing openssl
`puma` needs openssl, so you need to install openssl via homebrew first
```
$ brew install openssl
```
Then, configure `bundler` (which you should already have installed) to use homebrew's `openssl` for building the `puma` gem.
```
$ bundle config build.puma --with-opt-dir=/usr/local/opt/openssl
```

# Making -lgcc_s.10.4 available
The C library gcc_s.10.4 is required to build the `ffi` gem. Check if the libraries are available in `/usr/local/lib/` by running the command:
```
$ ls -alF /usr/local/lib/ | grep libgcc
```
If you don't see any output that contains the string "libgcc_s.10.4", it means the libraries are not available. Run this command to symlink the libraries in:
```
$ sudo ln -s /usr/lib/libSystem.B.dylib /usr/local/lib/libgcc_s.10.5.dylib
$ sudo ln -s /usr/lib/libSystem.B.dylib /usr/local/lib/libgcc_s.10.4.dylib
```
Then check if the libraries are now available:
```
$ ls -alF /usr/local/lib/ | grep libgcc
lrwxr-xr-x    1 root     staff      27 Jan 27 19:28 libgcc_s.10.4.dylib@ -> ../../lib/libSystem.B.dylib
lrwxr-xr-x    1 root     staff      27 Jan 27 19:28 libgcc_s.10.5.dylib@ -> ../../lib/libSystem.B.dylib
```

<!-- # Edit Gemfile to install Rails 4.2.8 and above -->
<!-- In ruby 2.4 there was a breaking change made that unified the `Fixnum` and `Bignum` integer types into `Integer`. As such you may encounter an error 'stack level too deep' later on if using a Rails version < 4.2.8. with a ruby version > 2.3-->
<!--  -->
<!-- Open the file titled `Gemfile`, this is where the list of gems that bundler will install. Look for the 'rails' entry by searching for a line containing this string: `gem 'rails', `. Look at what version is being specified. If it is '4.2.7.1', change the line to this string: -->
<!-- ``` -->
<!-- gem 'rails', '~> 4.2.8' -->
<!-- ``` -->
<!-- Save and close the `Gemfile`, then run -->
<!-- ``` -->
<!-- $ bundle update rails -->
<!-- ``` -->
<!-- to update all the dependencies. -->

# Install all Ruby gems
```
$ bundle install
```
After following all the instructions above, `bundle install` should work without a hitch.

# Set the `SECRET_KEY_BASE` and `DEVISE_SECRET_TOKEN`
You need some random keys for rails to handle some security stuff. Run this command to export two randomly generated secret keys (one for `SECRET_KEY_BASE` and one for `DEVISE_SECRET_TOKEN`) into your environment:
```
$ echo "export SECRET_KEY_BASE=$(bundle exec rake secret)\nexport DEVISE_SECRET_TOKEN=$(bundle exec rake secret)" >> ~/.bash_profile
$ source ~/.bash_profile
```
To check if ruby can pick up your `SECRET_KEY_BASE` and `DEVISE_SECRET_TOKEN` from the environment, run `ENV["SECRET_KEY_BASE"]` and `ENV["DEVISE_SECRET_TOKEN"]` in the ruby irb interpreter:
```
$ irb
irb(main):001:0> ENV["SECRET_KEY_BASE"]
=> <128 char alphanumeric string> # if you see 'nil' instead it means ruby cannot find your secret key base
irb(main):002:0> ENV["DEVISE_SECRET_TOKEN"]
=> <128 char alphanumeric string> # if you see 'nil' instead it means ruby cannot find your devise secret token
```

**Note: If you are using the zsh instead of bash, you will need to run this command instead:**
```
$ echo "export SECRET_KEY_BASE=$(bundle exec rake secret)\nexport DEVISE_SECRET_TOKEN=$(bundle exec rake secret)" >> ~/.zshenv
$ source ~/.zshenv
```

# Setup database
```
$ initdb nusskylab-db               # initializes a new db cluster
$ postgres -D nusskylab-db          # initializes the created database
```
Do not close this window. Open a new terminal window for the next few commands.
```
$ cd path/to/nusskylab
$ eval "(rbenv init -)"
$ ruby -v # Check that you are using rbenv ruby 2.3.3, not system ruby 2.3.7
ruby 2.3.3p222 (2016-11-21 revision 56859) [x86_64-darwin18]
$ psql postgres

postgres=# create user nusskylab with createdb login password 'nusskylab';  #creates the default user
postgres=# \q                                                               #exit the postgres instance

$ bundle exec rake db:create
$ bundle exec rake db:migrate
$ rails server -b 0.0.0.0
```

# Configuring the first ever admin
1. Log in using NUS OpenID at `0.0.0.0:3000`. Click the "Sign in with NUS" button, then log in with your NUS OpenID.

2. Check your `id` in `nusskylab_dev` database, `users` table.
```
$ psql -d nusskylab_dev

nusskylab_dev=# SELECT id,user_name,email,uid,created_at FROM users;
 id |   user_name   |       email        |                uid                 |        created_at
----+---------------+--------------------+------------------------------------+---------------------------
  1 | Chua Bok Woon | e0031874@u.nus.edu | https://openid.nus.edu.sg/e0031874 | 2019-02-13 13:33:46.03479
  ^ This is the id you need
```
&nbsp;
3. Create new entry in `nusskylab_dev` database, `admins` table. **Replace `user_id` with your user `id` referenced previously.**
```
INSERT INTO admins VALUES (1, **user_id** , current_timestamp, current_timestamp, extract(year from current_date));
```

# Up and running
Now whenever you want to start developing locally, simply start the db server as well as the rails server with these two commands:
```
postgres -D nusskylab-db         # start the db instance
rails server -b 0.0.0.0          # start the rails server
```

On your browser visit `0.0.0.0:3000` to access Skylab.

# Reference
ffi error  
https://gist.github.com/Dreyer/0a0976f5606c0c963ab9a622f03ee26d

capybara-webkit error  
https://github.com/thoughtbot/capybara-webkit/issues/1072#issuecomment-430311949
https://stackoverflow.com/a/53642942

puma error  
https://github.com/puma/puma/issues/783#issuecomment-153008019

Qt error  
https://stackoverflow.com/a/35098040

devise.secret_key error  
https://stackoverflow.com/questions/18080910/devise-secret-key-was-not-set
https://til.hashrocket.com/posts/8b8b4d00a3-generate-a-rails-secret-key
https://stackoverflow.com/questions/32397607/missing-secret-token-and-secret-key-base-for-development-environment-set
<!--  -->
<!-- stack level too deep error   -->
<!-- https://stackoverflow.com/questions/41504106/ruby-2-4-and-rails-4-stack-level-too-deep-systemstackerror -->

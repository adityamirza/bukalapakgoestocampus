## Install Ruby 2.5.1 using rvm
    
   ```bash
   curl -L get.rvm.io | bash -s stable
   source ~/.bash_profile
   ```
   Then run `rvm requirements` and follow the instructions

   ```bash
   rvm install 2.5.1
   ```
   Setting the default ruby
   
   `rvm --default use 2.5.1`

   Verify defaut ruby that used is 2.5.1
   ```bash
   ruby -v
   ```
   Result:

   ![image](https://user-images.githubusercontent.com/19463315/40603150-4e2675f8-6285-11e8-9e2c-fc2a8d8a5fbc.png)


## Install Dependencies
   ```
   sudo apt-get install libmysqlclient-dev
   sudo apt-get install cmake pkg-config 
   sudo ln -s /usr/bin/make /usr/bin/gmake
   sudo apt-get install libav-tools
   sudo apt-get install xvfb
   ```

## Setup Git 
1. Install Git
   ```
   sudo apt-get install git
   ```
2. Configure Git
   ```
   git config --global user.name "Your Name Here"
   git config --global user.email "your-github-email@example.com"
   ```
3. Generate Public Key
   ```
   ssh-keygen # then, just press enter
   ```
4. Add key to Github
   ```
   cat ~/.ssh/id_rsa.pub # copy the content to github
   ```

## Setup Firefox ESR

1. Download firefox esr [here](https://download.mozilla.org/?product=firefox-60.0.1esr-SSL&os=linux64&lang=en-US)
   
2. Extract downloaded file into /opt
   ```
   sudo tar -xvjf firefox-60.0.1esr.tar.bz2 -C /opt
   ```
3. Back up your existing symbolic link to the default Firefox executable
   ```
   sudo mv /usr/bin/firefox /usr/bin/firefox-old
   ```
4. Create a symbolic link to the Firefox ESR executable:
   ```
   sudo ln -s /opt/firefox/firefox /usr/bin/firefox
   ```

## Setup bukalapak_web_automation
1. Clone the project
   ```
   git clone git@github.com:bukalapak/bukalapak_web_automation.git 
   cd bukalapak_web_automation
   ```
2. Copy .env file
   ```
   cp env.sample .env
   ```
3. Install [bundler](http://bundler.io/)
   ```
   gem install bundler
   ```
4. Run bundle install
   ```
   bundle install
   ```
   or if you like to keep it simple
   ```
   bundle
   ```
5. Run cucumber to make sure everything is installed
   ```
   bundle exec cucumber --tag @initiate
   ```
   Verify result should be passed:

   ![image](https://user-images.githubusercontent.com/19463315/39985255-3ea399a6-5788-11e8-9716-3f23529056b6.png)

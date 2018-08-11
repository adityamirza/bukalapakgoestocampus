### Install node.js without using sudo
1. Do not install node.js through apt-get, which will need sudo rights and appium will not work if node.js is installed as sudo user. If you have already installed remove it using commands:

   `sudo apt-get remove nodejs`\
   `sudo apt-get remove npm`
2. Download latest nodejs linux binaries from [here](https://nodejs.org/download/release/latest/) 
                                              into a folder for example /home/`your_name`/Downloads (your_name is your username and you have downloaded the file in Downloads)
![image](https://user-images.githubusercontent.com/19463315/40552716-b71c3542-606a-11e8-911a-27403bdc008b.png)
                                              
3. Install it under /usr/local using (note: check tar file name)
  `cd /usr/local
 tar --strip-components 1 -xzf /home/your_name/Downloads/node-v8.2.1-linux-x64.tar.gz`
        
4. Check the installation\
  `which node`\
  it should give you output `usr/local/bin/node`\
  `node -v` \
should give you output `v8.2.1` (or whichever version you have installed)
                                      
### Install java, jdk and jre-
 1. Install oracle jdk  & jre\
    `sudo apt-get update`\
    `sudo apt-get install default-jre`\
    `sudo apt-get install default-jdk`
 
 2. Install oracle jdk\
    `sudo add-apt-repository ppa:webupd8team/java`\
    `sudo apt-get update`\
    `sudo apt-get install oracle-java8-installer`
 
### Set the JAVA HOME path-
 1. Open bashrc file\
   ` nano ~/.bashrc`\
   `export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64`\
   `export PATH=${PATH}:${JAVA_HOME}/bin`
 
 2. Run following command to verify the path\
    `echo $JAVA_HOME`\
    `echo $PATH`

### Download android studio and set the ANDROID HOME path-

1. load android studio for ubuntu from [here](https://developer.android.com/studio/) and extract it in the HOME directory
open terminal and enter:

    `cd android-studio/bin`\
    `./studio.sh`

2. Once android sdk is installed add ANDROID_HOME to environment using:

    `nano ~/.bashrc`
    
    Add following lines at the end of the file and then save (`username`-> check using `pwd` on terminal)
    
    `export ANDROID_HOME=/home/user_name/Android/Sdk`\
    `export PATH=$PATH:/home/user_name/Android/Sdk/tools`\
    `export PATH=$PATH:/home/user_name/Android/Sdk/platform-tools`\
    `source ~/.bashrc`
    
### Install appium globally
 1. Install appium
 
    `npm install -g appium`
 
 2. Check if appium is installed using:
   
     `appium`
   
 3. Install appium-doctor to troubleshoot the errors if any using:
  
    `npm install -g appium-doctor`
 
 4. Check if aappium-doctor is installed using:
  
    `appium-doctor`

### Running PWA on Android Chrome Browser
 1. Run emulator from android studio`Tools` -> `AVD Manager` -> choose emulator -> launch
 
    ![image](https://user-images.githubusercontent.com/19463315/40553728-c6c7b34c-606d-11e8-8633-b1504d205e7b.png)
 2. Check appium-doctor and run appium
 
    ![image](https://user-images.githubusercontent.com/19463315/40553824-053f85f0-606e-11e8-894b-83b891bac041.png)
 3. Check emulator device name: `abd devices`
 
    ![image](https://user-images.githubusercontent.com/19463315/40554291-758668d2-606f-11e8-8de7-d3afd66da3b3.png)
 4. Add env -> `emulator-5554` is device name
 
    `APPIUM_URL = http://127.0.0.1:4723/wd/hub/`\
    `HIVE_QUEUE_NAME = emulator-5554`\
    `BROWSER=Chrome`
 5. Run PWA
 
    `bundle exec cucumber -p web-pwa --tag @pwa`


# iOSTestApp

Single View Application developed in Swift 4 and XCode 8 for testing purposes.

[![Build Status](https://travis-ci.com/estefafdez/iOSTestApp.svg?branch=master)](https://travis-ci.com/estefafdez/iOSTestApp)

<img src="http://i.imgur.com/4JUKNuC.png"/>
<img height="40%" width="40%" src="http://i.imgur.com/nwsbQSl.gif"/>
_______________________________________

## 1. Download the project. 

In order to start using the project you need to create your own Fork on Github and then clone the project:

```bash
git clone https://github.com/XXXX/iOSTestApp
```

## 2. Use your application for testing purposes.

You can download this repository and use this application to start with Appium and run some automated test on it. 
The availables option on this application are:

- Enter your name: enter a name on the text field, click on the button and check your name on the label. 
- Switch Button: click on the switch button and check the text on the label: ON/OFF. 
- Increase/Decrease the text using the UISlider: You can increase and decrease the font size of the text displayed. 

## 3. Export your app to get the .ipa file. 

If you want to export the .ipa file yourself, please go to:

http://www.fitzweekly.com/2016/11/how-to-export-xcode-project-to-ipa-file.html

and follow the instructions. 

## 4. Get the app file. 

To be able to test your app using Appium, you need to get the .app file. In order to obtain it, you need to click on Product -> Build. 

Once the build is done, you can find the .app file in the following path:

~/Library/Developer/Xcode/DerivedData/{app name}/Build/Products/{your-compilation(debug, release...)}/ {yourpp.app}

## 5. Future improvements. 
This app was build on a single day, I will be uploading new version with more functionalities to test. If you want to collaborate and add new functionalities, please create a pull request into this repository. 

## 6. Enjoy!

Enjoy your testing!


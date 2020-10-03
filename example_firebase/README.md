# About   

This specific folder was created to provide sample codes for those who want to provide   
Kakao login as an sign-in options on their app using Firebase as a backend.  

**In order to remove alerts from IDE, type 'npm install' in this folder**  

# Instruction  

1. In your Flutter project, set up firebase functions with 'firebase init' command.  

2. When you get 'functions' folder, add your Kakao app's appId (normally 4~5 digits) using firebase config (firebase functions:config:set kakao.appid="YOUR KAKAO APP KEY").  

3. Then simply copy 'kakao.ts' and 'index.ts' files into your src folder before deploying it.  
   (If you want to use Javascript version, refer to https://pub.dev/packages/firebase_auth_simplify package's github source code)  

4. Invoke the cloud message by using CloudFunction in Flutter code with function name as 'customTokenFromKakao'.  
   Pass 'Kakao Access Token' you fetched from this package with 'token' parameter when invoking the cloud function.   

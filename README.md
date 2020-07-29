# flutter_login_test

A Flutter application which implements login with Email, facbook and Google.

## About project
 This project contains some third party dependencies defined below:
  1. google_sign_in: ^4.5.1
  2. firebase_auth: ^0.16.0
  3. cloud_firestore: ^0.13.5
  4. flutter_facebook_login: ^3.0.0
  5. shared_preferences: ^0.5.8
  
  This project demonstrates the login and saving the credentials locally using shared preferences.
  
  
  ## Setting up Google Login:
  It also uses firebase auth mechanism for google signIn so one has to add google json file in the app.
  Need to create an app on firebase with app id as: com.example.flutter_login_test
  Then you need to go to the authentication part and enable the google login and provide the SHA1 key.
  
  
  ## Setting up Facebool Login:
  You need to create an facebook app on developer facebook portal with the app id as: com.example.flutter_login_test.
  After that you need to copy the app_id and app_sercret of the facebook app to app in firbase app after enabling facebook login.
  Then you need to add the credentials to app in string.xmls for the android part.
  
  
  

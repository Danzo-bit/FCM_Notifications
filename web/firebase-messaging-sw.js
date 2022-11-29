importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js");

//Copy/paste firebaseConfig from Firebase Console
const firebaseConfig = {
    apiKey: "AIzaSyANJHf7a_mnHVZ4J-DbKcwF525YWWEpa_8",
    authDomain: "fir-cloudmsg-codelab.firebaseapp.com",
    projectId: "fir-cloudmsg-codelab",
    storageBucket: "fir-cloudmsg-codelab.appspot.com",
    messagingSenderId: "401183573677",
    appId: "1:401183573677:web:05e9187c136c527d956824"
  };

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

//Set up background message handler
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
   });
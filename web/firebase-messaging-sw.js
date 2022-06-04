importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyCniUnoOpZ6j2FasjhRF_qoT-nn-TV4BOI",
  authDomain: "project-5-97d71.firebaseapp.com",
  databaseURL: "https://project-5-97d71.firebaseio.com",
  projectId: "project-5-97d71",
  storageBucket: "project-5-97d71.appspot.com",
  messagingSenderId: "140657092147",
  appId: "1:140657092147:web:61b4af9421656244aae546",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
const functions = require("firebase-functions");

const admin = require("firebase-admin");

admin.initializeApp(functions.config().functions);

const db = admin.firestore();

var tokens = [];

var myToken = 'fY8FD1ZhTHmsS6teLLcpNi:APA91bFRh9De60zimdIudO2FXaNi9QeAqWNEoPMdg2Rcef-uuhiyo1reKL4VRuv1_3a6v1JWZSVkRCEoXaLwEeGHpguvJACD_OMVxAI39GMAR7do_dAmF2gX251n9pMKvSnPbYS3OuMI';

exports.newPost = functions.firestore
    .document('posts/{postId}')
    .onCreate(async (snap, context) => {

      const post = snap.data();

      const tokensRef = db.collection('tokens').doc('tokenList_1');

      const snapshot = await tokensRef.get();

      if (snapshot.empty) {
       console.log('No matching documents.');
       return;
      }  
      
      tokens = snapshot.data().tokens;
      

      if (tokens.length === 0)
      {
          console.log("No Tokens available");
      }
      else 
      {
        //console.log(tokens);

        try 
        {
          const message = {
            notification: {
              title: post.name,
              body: post.description,
              image: post.url
            },
            data: {
              messageId: post.postId,
              ownerId: post.ownerId
            },
            android: {
              priority: "high",
              notification: {
                imageUrl: post.url
              }
            },
            apns: {
              payload: {
                aps: {
                  'mutable-content': 1,
                  contentAvailable: true,
                }
              },
              fcm_options: {
                image: post.url
              },
              headers: {
                "apns-push-type": "background",
                "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
                "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier
              },
            },
            webpush: {
              headers: {
                image: post.url,
                Urgency: "high"
              },
              notification: {
                body: post.description,
                requireInteraction: "true",
                badge: "https://pngimg.com/uploads/letter_g/letter_g_PNG73.png"
              }
            },
            //topic: topicName,
            tokens: tokens,
          };
  
          admin.messaging().sendMulticast(message)
          .then((response) => {
            if (response.failureCount > 0) {
              const failedTokens = [];
              response.responses.forEach((resp, idx) => {
                if (!resp.success) {
                  failedTokens.push(registrationTokens[idx]);
                }
              });
              console.log('List of tokens that caused failures: ' + failedTokens);
            }
          });
        }
        catch (error) {
          console.error(error);
        }
        
      }


    });


exports.newFeed = functions.firestore
    .document('feed/{feedId}')
    .onCreate(async (snap, context) => {

      const feed = snap.data();

      const tokensRef = db.collection('tokens').doc('tokenList_1');

      const snapshot = await tokensRef.get();

      if (snapshot.empty) {
       console.log('No matching documents.');
       return;
      }  
      
      tokens = snapshot.data().tokens;
      

      if (tokens.length === 0)
      {
          console.log("No Tokens available");
      }
      else 
      {
        //console.log(tokens);

        try 
        {
          const message = {
            notification: {
              title: feed.username,
              body: feed.description,
              image: feed.urls[0]
            },
            data: {
              messageId: feed.postId,
              ownerId: feed.publisherID
            },
            android: {
              priority: "high",
              notification: {
                imageUrl: feed.urls[0]
              }
            },
            apns: {
              payload: {
                aps: {
                  'mutable-content': 1,
                  contentAvailable: true,
                }
              },
              fcm_options: {
                image: feed.urls[0]
              },
              headers: {
                "apns-push-type": "background",
                "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
                "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier
              },
            },
            webpush: {
              headers: {
                image: feed.urls[0],
                Urgency: "high"
              },
              notification: {
                body: feed.description,
                requireInteraction: "true",
                badge: "https://pngimg.com/uploads/letter_g/letter_g_PNG73.png"
              }
            },
            //topic: topicName,
            tokens: tokens,
          };
  
          admin.messaging().sendMulticast(message)
          .then((response) => {
            if (response.failureCount > 0) {
              const failedTokens = [];
              response.responses.forEach((resp, idx) => {
                if (!resp.success) {
                  failedTokens.push(registrationTokens[idx]);
                }
              });
              console.log('List of tokens that caused failures: ' + failedTokens);
            }
          });
        }
        catch (error) {
          console.error(error);
        }
        
      }


    });


exports.newSuggestion = functions.firestore.document('suggestions/{suggestionId}').onCreate(async (snap, context) => {
  const suggestion = snap.data();


  try{

    admin.messaging().send({
      token: myToken,
      notification: {
        title: suggestion.username + ' made a suggestion',
        body: suggestion.suggestion,
      },
      data: {
        suggestion: suggestion.suggestion,
        username: suggestion.username
      },
      // Set Android priority to "high"
      android: {
        priority: "high",
      },
      // Add APNS (Apple) config
      apns: {
        payload: {
          aps: {
            contentAvailable: true,
          },
        },
        headers: {
          "apns-push-type": "background",
          "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
          "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier
        },
      },
    });
  }catch (error) {
    console.error(error);
  }

});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

exports.messageSent = functions.firestore
  .document("users/{userId}/chats/{targetId}/messages/{message}")
  .onCreate(async (snapshot, context) => {
    if (snapshot.empty) {
          console.log("No message created");
          return;
    }

    const newValue = snapshot.data();
    const tId = newValue.targetID;
    const uId = newValue.userID;
    let sent;
    newValue.sentNotification != null ? sent = newValue.sentNotification : sent = true;
    const timeStamp = newValue.timeStamp;

    //console.log(`tId: ${tId}, uId: ${uId}`);

    const users = await admin.firestore().collection("users").get();

    if (users.empty) {
      console.log("No users exist =(");
      return;
    }

    const tokens = [];
    let senderDisplayName = "";

    users.forEach((user) => {
      if (user.data().deviceToken != null && user.data().deviceToken != "") {

        if (uId == user.data().userID) {
          senderDisplayName = user.data().displayName;
          senderID = user.data().userID;
        }
        if (tId == user.data().userID) {
          tokens.push(user.data().deviceToken);
          //console.log(`Token: ${user.data().deviceToken}`);
        }
      }
    })

    const payload = {
      notification: {
        title: "New message!",
        body: `From ${senderDisplayName}`,
        sound: "default",
      },
      data: {
        targetID: uId,
        displayName: senderDisplayName,
      },
    };

    try {
      if(!sent){
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log("Notification sent successfully");
        await admin.firestore()
          .collection("users")
          .doc(uId)
          .collection("chats")
          .doc(tId)
          .collection("messages")
          .where("timeStamp", "==", timeStamp)
          .get().then((messageSnapshot) => {
            messageSnapshot.forEach((document) => {
              try{
                document.ref.update({"sentNotification": true});
                //console.log("updated");
              } catch (error) {
                console.log(error);
              }
            });
          });
      }
    } catch (error) {
      console.log(error);
    }
  });

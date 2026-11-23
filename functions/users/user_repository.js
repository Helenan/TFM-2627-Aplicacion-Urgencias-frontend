const { getFirestore } = require("firebase-admin/firestore");
const { getAuth } = require("firebase-admin/auth");
const { HttpsError } = require("firebase-functions/v2/https");

firestore = getFirestore();
userCollection = "usuarios";

async function getUser(uid) {
  const userDoc = await getFirestore()
      .collection(userCollection)
      .doc(uid)
      .get();

  return userDoc;
}

async function createUser(email, password, user) {
  try {
    const userAuthRecord = await getAuth().createUser({
        email: email.trim(),
        password: password
    });

    const userFirestoreRecord = await getFirestore()
        .collection(userCollection)
        .doc(userAuthRecord.uid)
        .create({
          ...user,
          createdAt: Date.now(),
        });

    return {
        uid: userAuthRecord.uid,
        email: userAuthRecord.email
    };
  } catch (error) {
    console.error("User creation failed:", error);

    if (error.code === "auth/email-already-exists") {
      throw new HttpsError("already-exists", "An account with this name already exists.");
    }
    else if (userAuthRecord) {
      try {
        await getAuth().deleteUser(userAuthRecord.uid);
      } catch (rollbackError) {
        console.error("Failed to rollback:", error);
      }
    }

    throw new HttpsError("internal", "Unable to create user, something went wrong.");
  }
}

async function deleteUser(uid) {
  await getAuth().deleteUser(uid);

  await getFirestore()
      .collection(userCollection)
      .doc(uid)
      .delete();

  return;
}

module.exports = {
  getUser,
  createUser,
  deleteUser
};
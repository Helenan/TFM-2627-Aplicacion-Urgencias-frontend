/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {setGlobalOptions} = require("firebase-functions");
const {onRequest} = require("firebase-functions/https");
const logger = require("firebase-functions/logger");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");
const { getFirestore } = require("firebase-admin/firestore");

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });



initializeApp();


exports.createUser = onCall(async (request) => {
  console.log("Called 'createUser'")

  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "Debes iniciar sesión."
    );
  }

  const adminDoc = await getFirestore()
      .collection("usuarios")
      .doc(request.auth.uid)
      .get();

    logger.info("Diagnóstico de administrador", {
      projectId: process.env.GCLOUD_PROJECT,
      firestoreEmulator: process.env.FIRESTORE_EMULATOR_HOST ?? "no",
      uid: request.auth.uid,
      documentExists: adminDoc.exists,
      role: adminDoc.data()?.role ?? null,
    });

  if (!adminDoc.exists || adminDoc.data().role !== "admin") {
    throw new HttpsError(
      "permission-denied",
      "No tienes permisos para crear usuarios."
    );
  }

  const { email, password, user } = request.data ?? {};

  try {
    const userAuthRecord = await getAuth().createUser({
        email: email.trim(),
        password: password
    });

    const userFirestoreRecord = await getFirestore()
        .collection("usuarios")
        .doc(userAuthRecord.uid)
        .create({
          ...user,
          createdAt: Date.now()
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
})

exports.deleteUser = onCall(async (request) => {
  console.log("Called 'deleteUser'")

  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "Debes iniciar sesión."
    );
  }

  const adminDoc = await getFirestore()
      .collection("usuarios")
      .doc(request.auth.uid)
      .get();

    logger.info("Diagnóstico de administrador", {
      projectId: process.env.GCLOUD_PROJECT,
      firestoreEmulator: process.env.FIRESTORE_EMULATOR_HOST ?? "no",
      uid: request.auth.uid,
      documentExists: adminDoc.exists,
      role: adminDoc.data()?.role ?? null,
    });

  if (!adminDoc.exists || adminDoc.data().role !== "admin") {
    throw new HttpsError(
      "permission-denied",
      "No tienes permisos para eliminar usuarios."
    );
  }

  const uid = request.data.uid;

  if (typeof uid !== "string" || uid.trim() === "") {
    throw new HttpsError(
      "invalid-argument",
      "El UID no es válido."
    );
  }

  if (uid === request.auth.uid) {
    throw new HttpsError(
      "failed-precondition",
      "No puedes eliminar tu propia cuenta."
    );
  }

  await getAuth().deleteUser(uid);

  await getFirestore()
      .collection("usuarios")
      .doc(uid)
      .delete();

  return { success: true };
});
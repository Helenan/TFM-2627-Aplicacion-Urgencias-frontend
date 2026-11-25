const userRepository = require('./user_repository');
const { onCall, HttpsError } = require("firebase-functions/v2/https");

exports.createUser = onCall(async (request) => {
  console.log("Called 'createUser'")

  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "Debes iniciar sesión."
    );
  }

  const adminDoc = await userRepository.getUser(request.auth.uid);

  if (!adminDoc.exists || adminDoc.data().role !== "admin") {
    throw new HttpsError(
      "permission-denied",
      "No tienes permisos para crear usuarios."
    );
  }

  const { email, password, user } = request.data ?? {};

  return await userRepository.createUser(email, password, user);
});

exports.deleteUser = onCall(async (request) => {
  console.log("Called 'deleteUser'")

  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "Debes iniciar sesión."
    );
  }

  const adminDoc = await userRepository.getUser(request.auth.uid);

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

  await userRepository.deleteUser(uid);

  return { success: true };
});
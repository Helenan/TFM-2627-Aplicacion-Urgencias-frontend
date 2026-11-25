const { getFirestore } = require("firebase-admin/firestore");
const { HttpsError } = require("firebase-functions/v2/https");

registerCollection = "registros";

async function getRegister(uid) {
  const registerDoc = await getFirestore()
      .collection(registerCollection)
      .where('uid', '==', uid)
      .get();

  return registerDoc;
}

async function registerPatient(register) {
  try {
    const registerRef = getFirestore()
        .collection(registerCollection)
        .doc();

    await registerRef.create({
      ...register,
      createdAt: Date.now()
    });

    return {
      uid: registerRef.id
    };
  } catch (error) {
    console.error("Patient register failed:", error);

    throw new HttpsError("internal", "Unable to register patient, something went wrong.");
  }
}

module.exports = {
  getRegister,
  registerPatient
};
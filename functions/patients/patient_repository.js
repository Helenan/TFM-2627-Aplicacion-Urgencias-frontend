const { getFirestore } = require("firebase-admin/firestore");
const { HttpsError } = require("firebase-functions/v2/https");

patientCollection = "pacientes";

async function getPatient(identityDocument) {
  const patientDoc = await getFirestore()
      .collection(patientCollection)
      .where('identityDocument', '==', identityDocument)
      .get();

  return patientDoc;
}

async function getPatientsStartingWith(identityDocument) {
  const patients = await getFirestore()
      .collection(patientCollection)
      .where('identityDocument', '>=', identityDocument)
      .where('identityDocument', '<=', identityDocument + '\uf8ff')
      .get();

  return patients;
}

async function createPatient(patient) {
  try {
    // Remove uid from patient
    const {uid, ...patientData} = patient;

    const patientFirestoreRef = getFirestore()
        .collection(patientCollection)
        .doc();
    
    await patientFirestoreRef.create({
       ...patientData,
       createdAt: Date.now()
    });

      return {
        uid: patientFirestoreRef.id
      };
  } catch (error) {
    console.error("Patient creation failed:", error);

    throw new HttpsError("internal", "Unable to create patient, something went wrong.");
  }
}

async function updatePatient(uid, patient) {
  try {
    // Remove uid from patient, it is the document id
    const {uid: _uid, ...patientData} = patient;

    await getFirestore()
        .collection(patientCollection)
        .doc(uid)
        .update({
          ...patientData,
          updatedAt: Date.now()
        });

    return {
      uid: uid
    };
  } catch (error) {
    console.error("Patient update failed:", error);

    throw new HttpsError("internal", "Unable to update patient, something went wrong.");
  }
}

module.exports = {
  getPatient,
  getPatientsStartingWith,
  createPatient,
  updatePatient
};
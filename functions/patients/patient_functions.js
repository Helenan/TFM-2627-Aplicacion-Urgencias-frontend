const userRepository = require('../users/user_repository');
const patientRepository = require('../patients/patient_repository');
const { onCall, HttpsError } = require("firebase-functions/v2/https");

exports.createPatient = onCall(async (request) => {
    console.log("Called 'createPatient'")

    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "Debes iniciar sesión."
      );
    }

    const userDoc = await userRepository.getUser(request.auth.uid);

    if (!userDoc.exists || userDoc.data().role !== "doctor") {
      throw new HttpsError(
        "permission-denied",
        "No tienes permisos para crear pacientes."
        );
      }

    const {patient} = request.data ?? {};

    return await patientRepository.createPatient(patient);
});

exports.updatePatient = onCall(async (request) => {
    console.log("Called 'updatePatient'")

    if (!request.auth) {
          throw new HttpsError(
            "unauthenticated",
            "Debes iniciar sesión."
          );
        }

    const {patient} = request.data ?? {};

    findPatient({
        data: {
            identityDocument: patient.identityDocument
        }
    })

    const updatedPatient = await patientRepository.getPatient(identityDocument);

    return patient;
});

exports.findPatient = onCall(async (request) => {
    console.log("Called 'findPatient'")

    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "Debes iniciar sesión."
      );
    }

    const {identityDocument} = request.data ?? {};

    const patient = await patientRepository.getPatient(identityDocument);

    return patient;
});

exports.queryPatient = onCall(async (request) => {
    console.log("Called 'queryPatient'")

    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "Debes iniciar sesión."
      );
    }

    const {identityDocument} = request.data ?? {};

    if (!identityDocument) {
      return [];
    }

    const query = await patientRepository.getPatientsStartingWith(identityDocument);

    return query.docs.map((doc) => ({uid: doc.id, ...doc.data()}));
});

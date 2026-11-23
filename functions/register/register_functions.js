const userRepository = require('../users/user_repository');
const patientRepository = require('../patients/patient_repository');
const registerRepository = require('../register/register_repository');
const { onCall, HttpsError } = require("firebase-functions/v2/https");

exports.registerPatient = onCall(async (request) => {
    console.log("Called 'registerPatient'")

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
        "No tienes permisos para registrar pacientes."
      );
    }

    const {register} = request.data ?? {};
    const patient = register.patient;

    if (patient?.identityDocument == null) {
        throw new HttpsError("failed-precondition", "Missing unique attribute 'identityDocument'");
    }

    if (patient?.uid == null) { // unknown patient
        const existingPatients = await patientRepository.getPatient(patient.identityDocument);

        let patientDocUid;

        if (existingPatients.empty) {
            patientDocUid = (await patientRepository.createPatient(patient)).uid;
        } else {
            patientDocUid = existingPatients.docs[0].id;
            await patientRepository.updatePatient(patientDocUid, patient);
        }

        register.patient.uid = patientDocUid;
    }

    return await registerRepository.registerPatient(register);
});

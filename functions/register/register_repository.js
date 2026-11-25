const { getFirestore } = require("firebase-admin/firestore");
const { HttpsError } = require("firebase-functions/v2/https");
const userRepository = require("../users/user_repository");

registerCollection = "registros";

async function getRegister(uid) {
  const registerDoc = await getFirestore()
      .collection(registerCollection)
      .where('uid', '==', uid)
      .get();

  return registerDoc;
}

async function getOpenRegisters() {
  return await getFirestore()
      .collection(registerCollection)
      .where('isOpen', '==', true)
      .get();
}

function pickLeastBusy(userDocs, registerDocs, assignedField) {
  const loads = userDocs.map((user) => registerDocs
      .filter((register) => register.data()[assignedField] === user.id)
      .length);
  const min = Math.min(...loads);
  const candidates = userDocs.filter((_, index) => loads[index] === min);

  return candidates[Math.floor(Math.random() * candidates.length)];
}

async function registerPatient(register, creatorUid) {
  try {
    const registerRef = getFirestore()
        .collection(registerCollection)
        .doc();

    const doctors = await userRepository.getUsersByRole("doctor");
    const nurses = await userRepository.getUsersByRole("nurse");
    const openRegisters = (await getOpenRegisters()).docs;

    const availableDoctors = doctors.docs.filter((doc) => doc.id !== creatorUid);

    const otherDoctor = pickLeastBusy(availableDoctors, openRegisters, "doctor");
    const nurse = pickLeastBusy(nurses.docs, openRegisters, "nurse");

    await registerRef.create({
      ...register,
      doctor: otherDoctor?.id ?? creatorUid,
      nurse: nurse?.id ?? null,
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
const specialtyRepository = require('../specialty/specialty_repository');
const { onCall, HttpsError } = require("firebase-functions/v2/https");

exports.querySpecialty = onCall(async (request) => {
    console.log("Called 'querySpecialty'")

    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "Debes iniciar sesión."
      );
    }

    const {name} = request.data ?? {};

    if (!name) {
      return [];
    }

    return await specialtyRepository.getSpecialtiesStartingWith(name);
});

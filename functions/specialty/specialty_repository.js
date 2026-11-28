const { getFirestore } = require("firebase-admin/firestore");

specialtyCollection = "especialidades";

async function getSpecialty(uid) {
  const specialtyDoc = await getFirestore()
      .collection(specialtyCollection)
      .where('uid', '==', uid)
      .get();

  return specialtyDoc;
}

// Normalizes text to lowercase with no diacritics
function normalize(text) {
  return text.normalize("NFD").replace(/\p{Diacritic}/gu, "").toLowerCase();
}

function getDescendantIds(uid, specialtiesById, descendantIds = new Set()) {
  for (const id of specialtiesById.get(uid)?.subspecialties ?? []) {
    if (!descendantIds.has(id)) {
      descendantIds.add(id);
      getDescendantIds(id, specialtiesById, descendantIds);
    }
  }

  return descendantIds;
}

// Resolves specialties, but stops when no specialty or an ancestor specialty is found
function resolveSubspecialties(uid, specialtiesById, ancestorIds = []) {
  const specialty = specialtiesById.get(uid);
  const path = [...ancestorIds, uid];

  return {
    ...specialty,
    subspecialties: (specialty.subspecialties ?? [])
        .filter((id) => specialtiesById.has(id) && !path.includes(id))
        .map((id) => resolveSubspecialties(id, specialtiesById, path))
  };
}

async function getSpecialtiesStartingWith(name) {
  const specialties = await getFirestore()
      .collection(specialtyCollection)
      .orderBy('name')
      .get();
  const specialtiesById = new Map(
      specialties.docs.map((doc) => [doc.id, doc.data()]));
  const prefix = normalize(name.trim());
  const matches = specialties.docs
      .filter((doc) => normalize(doc.data().name).startsWith(prefix));

  const nestedIds = new Set(matches.flatMap(
      (doc) => [...getDescendantIds(doc.id, specialtiesById)]
          .filter((id) => id !== doc.id)));

  // Return not nested specialties
  return matches
      .filter((doc) => !nestedIds.has(doc.id))
      .map((doc) => resolveSubspecialties(doc.id, specialtiesById));
}

module.exports = {
  getSpecialty,
  getSpecialtiesStartingWith
};

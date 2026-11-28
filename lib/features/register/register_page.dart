import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/features/register/data/enums/allergy_knowledge.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/features/register/data/enums/biological_sex.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/services/patient_service.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/services/specialty_service.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/utils/allergy_knowledge_select.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/utils/biological_sex_select.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/utils/blood_group_select.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/utils/date_field.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/utils/querying_text_field.dart';

import '../../services/register_service.dart';
import '../../utils/error_banner.dart';
import '../../utils/sucess_banner.dart';
import 'data/enums/blood_group.dart';
import 'data/patient.dart';
import 'data/patient_register.dart';
import 'data/specialty.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _dateController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _otherBloodGroupController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _actualMedicationController = TextEditingController();
  final _chronicDiseasesController = TextEditingController();
  final _otherConditionsController = TextEditingController();
  final _specialtyController = TextEditingController();

  BiologicalSex _selectedBiologicalSex = BiologicalSex.unspecified;
  AllergyKnowledge _selectedAllergyKnowledge = AllergyKnowledge.unknown;
  BloodGroup _selectedBloodGroup = BloodGroup.unknown;

  late Patient? patient;
  Specialty? _selectedSpecialty;

  bool _isSubmitting = false;

  void _fillPatientData() {
    if (patient != null) {
      // The patient should be queried by identity,
      // so we don't need to set the identity
      setState(() {
        _nameController.text = patient!.firstName;
        _surnameController.text = patient!.lastName;
        _dateController.text = patient!.dateOfBirth;
        _selectedBiologicalSex = patient!.biologicalSex;
        _selectedBloodGroup = patient!.bloodGroup;
        _otherBloodGroupController.text = patient!.otherBloodGroup ?? "";
        _selectedAllergyKnowledge = patient!.allergyKnowledge;
        _allergiesController.text = patient!.allergies ?? "";
        _actualMedicationController.text = patient!.actualMedication ?? "";
        _chronicDiseasesController.text = patient!.chronicDiseases ?? "";
        _otherConditionsController.text =
            patient!.otherMedicalInformation ?? "";
      });
    } else {
      setState(() {
        _nameController.text = "";
        _surnameController.text = "";
        _dateController.text = "";
        _selectedBiologicalSex = BiologicalSex.unspecified;
        _selectedBloodGroup = BloodGroup.unknown;
        _otherBloodGroupController.text = "";
        _selectedAllergyKnowledge = AllergyKnowledge.unknown;
        _allergiesController.text = "";
        _actualMedicationController.text = "";
        _chronicDiseasesController.text = "";
        _otherConditionsController.text = "";
      });
    }
  }

  void _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final identityDocument = _identityController.text.trim();

    final Patient formPatient = Patient(
      identityDocument: identityDocument,
      dateOfBirth: _dateController.text.trim(),
      firstName: _nameController.text.trim(),
      lastName: _surnameController.text.trim(),
      biologicalSex: _selectedBiologicalSex,
      bloodGroup: _selectedBloodGroup,
      otherBloodGroup: _selectedBloodGroup == BloodGroup.other
          ? _otherBloodGroupController.text.trim()
          : "",
      allergyKnowledge: _selectedAllergyKnowledge,
      allergies:
          _selectedAllergyKnowledge == AllergyKnowledge.withKnownAllergies
          ? _allergiesController.text.trim()
          : "",
      actualMedication: _actualMedicationController.text.trim(),
      chronicDiseases: _chronicDiseasesController.text.trim(),
      otherMedicalInformation: _otherConditionsController.text.trim(),
    );

    try {
      await RegisterService().registerPatient(
        PatientRegister(
          patient: formPatient,
          symptoms: _symptomsController.text.trim(),
          specialty: _selectedSpecialty!,
        ),
      );

      if (!mounted) {
        return;
      }
      Navigator.pop(context);
      showSuccessBanner(context, 'Registro creado correctamente.');
    } catch (e) {
      if (!mounted) return;

      setState(() => _isSubmitting = false);

      showErrorBanner(
        context,
        'Ha ocurrido un error al crear el registro. Pruebe otra vez en unos minutos y si el problema persiste contacte con el administrador.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSubmitting,
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 420,
                          minHeight: constraints.maxHeight - 48,
                        ),
                        child: IntrinsicHeight(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Transform.translate(
                                      offset: const Offset(-24, 0),
                                      child: IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        tooltip: 'Volver',
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'Registrar un paciente',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    // Keeps the title centered, balancing the arrow
                                    const SizedBox(width: 48),
                                  ],
                                ),

                                const SizedBox(height: 36),

                                Text(
                                  'DNI/NIE/NIF',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),

                                QueryingTextField(
                                  controller: _identityController,
                                  queryMethod: PatientService().queryPatient,
                                  displayItem: (patient) =>
                                      '${patient.identityDocument} | ${patient.firstName} ${patient.lastName}',
                                  selectedText: (patient) =>
                                      patient.identityDocument,
                                  onSelected: (patient) {
                                    this.patient = patient;
                                    _fillPatientData();
                                  },
                                  onChanged: (value) {
                                    patient = null;
                                  },
                                  validator: (value) {
                                    if (value != null &&
                                        !RegExp(r'^[0-9]{8}[A-Z]$')
                                            .hasMatch(value)) {
                                      return "Debe introducir un DNI válido.";
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 22),

                                Text(
                                  'Nombre',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),

                                TextFormField(
                                  controller: _nameController,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => () {},
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Nombre del paciente';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 22),

                                Text(
                                  'Apellidos',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),

                                TextFormField(
                                  controller: _surnameController,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => () {},
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Apellidos del paciente';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 22),

                                DateField(
                                  label: 'Fecha de nacimiento',
                                  dateController: _dateController,
                                  submit: () {},
                                ),

                                const SizedBox(height: 22),

                                BiologicalSexSelect(
                                  selected: _selectedBiologicalSex,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedBiologicalSex =
                                          value ?? BiologicalSex.unspecified;
                                    });
                                  },
                                ),
                                const SizedBox(height: 22),

                                BloodGroupSelect(
                                  selected: _selectedBloodGroup,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedBloodGroup =
                                          value ?? BloodGroup.unknown;
                                    });
                                  },
                                ),

                                if (_selectedBloodGroup ==
                                    BloodGroup.other) ...[
                                  const SizedBox(height: 10),

                                  TextFormField(
                                    controller: _otherBloodGroupController,
                                    textInputAction: TextInputAction.done,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Especifique el grupo sanguíneo',
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Indique el grupo sanguíneo del paciente';
                                      }

                                      return null;
                                    },
                                  ),
                                ],

                                const SizedBox(height: 22),

                                AllergyKnowledgeSelect(
                                  selected: _selectedAllergyKnowledge,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAllergyKnowledge =
                                          value ?? AllergyKnowledge.unknown;
                                    });
                                  },
                                ),

                                if (_selectedAllergyKnowledge ==
                                    AllergyKnowledge.withKnownAllergies) ...[
                                  const SizedBox(height: 10),

                                  TextFormField(
                                    controller: _allergiesController,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => () {},
                                    minLines: 3,
                                    maxLines: 6,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Indique las alergias del paciente',
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Alergias del paciente';
                                      }

                                      return null;
                                    },
                                  ),
                                ],

                                const SizedBox(height: 22),

                                Text(
                                  'Medicación actual',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),

                                TextFormField(
                                  controller: _actualMedicationController,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => () {},
                                  minLines: 3,
                                  maxLines: 6,
                                ),

                                const SizedBox(height: 22),

                                Text(
                                  'Enfermedades crónicas',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),

                                TextFormField(
                                  controller: _chronicDiseasesController,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => () {},
                                  minLines: 3,
                                  maxLines: 6,
                                ),

                                const SizedBox(height: 22),

                                Text(
                                  'Otras condiciones médicas',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),

                                TextFormField(
                                  controller: _otherConditionsController,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => () {},
                                  minLines: 3,
                                  maxLines: 6,
                                ),

                                const SizedBox(height: 22),

                                Text(
                                  'Síntomas',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),

                                TextFormField(
                                  controller: _symptomsController,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => () {},
                                  minLines: 4,
                                  maxLines: 8,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Síntomas';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 22),

                                Text(
                                  'Especialidad',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),

                                QueryingTextField(
                                  controller: _specialtyController,
                                  queryMethod: SpecialtyService().querySpecialty,
                                  displayItem: (specialty) => specialty.name,
                                  childrenOf: (specialty) =>
                                      specialty.subspecialties,
                                  optionsMaxHeight: 300,
                                  hintText: 'Busca una especialidad',
                                  onSelected: (specialty) {
                                    _selectedSpecialty = specialty;
                                  },
                                  onChanged: (value) {
                                    _selectedSpecialty = null;
                                  },
                                  validator: (value) {
                                    if (_selectedSpecialty == null) {
                                      return 'Seleccione una especialidad de la lista';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 16),

                                SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: _isSubmitting ? null : _submit,
                                    child: const Text('Crear registro'),
                                  ),
                                ),

                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isSubmitting)
              Positioned.fill(
                child: AbsorbPointer(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: const ColoredBox(
                      color: Colors.black26,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

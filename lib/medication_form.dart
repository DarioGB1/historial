import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para Firestore
import 'package:firebase_core/firebase_core.dart'; // Para inicializar Firebase

class MedicationForm extends StatefulWidget {
  const MedicationForm({Key? key}) : super(key: key);

  @override
  _MedicationFormState createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  final TextEditingController _nroentrevista = TextEditingController();
  final TextEditingController _nropaciente = TextEditingController();
  final TextEditingController _centroSaludController = TextEditingController();
  final TextEditingController _redController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidoPaternoController =
      TextEditingController();
  final TextEditingController _apellidoMaternoController =
      TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _tallaController = TextEditingController();
  final TextEditingController _imcController = TextEditingController();
  final TextEditingController _medicinaalternativa = TextEditingController();
  final TextEditingController _resultadobaciloscopia = TextEditingController();
  final TextEditingController _resultadocultivo = TextEditingController();
  final TextEditingController _resultadogenexpert = TextEditingController();
  // Variables para manejar el estado de las selecciones
  // Añade estas variables al inicio de tu clase state
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  Future<void> _guardarFormulario() async {
  if (!_formKey.currentState!.validate()) return;

  try {
    // Recopilar datos del formulario
    Map<String, dynamic> formularioData = {
      'nro_entrevista': _nroentrevista.text,
      'fecha': FieldValue.serverTimestamp(),
      'institucion_salud': {
        'centro_salud': _centroSaludController.text,
        'red_salud': _redController.text,
      },
      'datos_paciente': {
        'nombres': _nombresController.text,
        'apellido_paterno': _apellidoPaternoController.text,
        'apellido_materno': _apellidoMaternoController.text,
        'grado_instruccion': _gradoInstruccion,
        'estado_civil': _estadoCivil,
        'edad': int.tryParse(_edadController.text) ?? 0,
        'sexo': _genero,
        'peso': double.tryParse(_pesoController.text) ?? 0.0,
        'talla': double.tryParse(_tallaController.text) ?? 0.0,
        'imc': double.tryParse(_imcController.text) ?? 0.0,
      },
      'estilo_vida': {
        'actividad_fisica': _actividadFisica,
        'consumo_alcohol': _consumoAlcohol,
        'fuma': _fuma,
        'consumo_tabaco': _consumoTabaco,
        'terapia_alternativa': _terapiaAlternativa,
        'hierbas_medicinales': _cualesTerapias,
      },
      'paciente_expuesto': _pacienteExpuesto,
    };

    // Añadir datos del test Morisky si es paciente expuesto
    if (_pacienteExpuesto == 'Expuesto') {
      formularioData['test_morisky'] = _getMoriskyData();
    }

    // Referencia al documento del paciente
    DocumentReference pacienteRef = _firestore
        .collection('form_soc')
        .doc(_nropaciente.text); // Usar nro_paciente como ID del documento

    // Verificar si el paciente ya existe
    DocumentSnapshot pacienteSnapshot = await pacienteRef.get();

    if (!pacienteSnapshot.exists) {
      // Si el paciente no existe, crear el documento con datos básicos
      await pacienteRef.set({
        'nro_paciente': _nropaciente.text,
        'datos_paciente': formularioData['datos_paciente'], // Datos generales
      });
    }

    // Agregar el formulario a la subcolección 'historial'
    await pacienteRef.collection('historial').add(formularioData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Formulario guardado en el historial del paciente.'),
        backgroundColor: Colors.green,
      ),
    );

    // Limpiar formulario después de guardar
    _limpiarFormulario();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al guardar: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  List<Map<String, dynamic>> _getMoriskyData() {
    List<Map<String, dynamic>> moriskyData = [];

    for (int i = 0; i < questions.length; i++) {
      moriskyData.add({
        'pregunta': questions[i],
        'respuesta': responses[i] ?? false,
        'numero_veces': times[i] ?? '0'
      });
    }

    return moriskyData;
  }

  void _limpiarFormulario() {
    _formKey.currentState!.reset();
    setState(() {
      _gradoInstruccion = null;
      _estadoCivil = null;
      _actividadFisica = null;
      _consumoAlcohol = null;
      _fuma = null;
      _consumoTabaco = null;
      _terapiaAlternativa = null;
      _cualesTerapias = null;
      _pacienteExpuesto = null;
      responses.clear();
      times.clear();
    });
  }

  String? _gradoInstruccion;
  String? _estadoCivil;
  String? _actividadFisica;
  String? _consumoAlcohol;
  String? _fuma;
  String? _consumoTabaco;
  String? _terapiaAlternativa;
  String? _cualesTerapias;
  String? _genero;
  final Map<int, bool?> responses = {};
  final Map<int, String?> times =
      {}; // Nuevo mapa para almacenar el número de veces
  final List<String> questions = [
    "¿Se olvida alguna vez tomar su medicación?",
    "¿Cuántas veces?",
    "¿Toma sus medicamentos a horas indicada por su médico?",
    "Cuando se encuentra bien ¿deja de tomarlos?",
    "Si alguna vez le sienta mal los medicamentos ¿deja de tomarlos?",
    "¿Cuántos días dejó de tomar?",
    "¿Cómo se siente después de tomar su medicación?",
    "Cuando toma su medicación, se sirve alimentos",
    "Si se siente deprimido deja de tomar sus medicamentos",
    "¿Cuántos días dejó de tomar cuando esta deprimido?",
    "Deja de tomar sus medicamentos porque no hay en el centro de salud",
    "¿Cuántos días dejó de tomar?",
    "Deja de tomar sus medicamentos porque son muchos",
    "¿Cuántos días dejó de tomar?",
    "Deja de tomar la medicación porque no puede llegar al centro de salud",
    "¿Cuántos días dejó de tomar?",
    "¿Su familia le colabora con su enfermedad?",
    "¿Su entorno sabe de su enfermedad?",
    "¿Le preocupa que sepan de su enfermedad?",
    "¿Prefiere no comunicar de su enfermedad?",
    "¿Presenta alguna otra enfermedad?",
    "¿Cuál o cuáles?",
    "¿Recibe tratamiento para la otra/s enfermedad/es",
    "¿Cuál es su tratamiento?",
    "¿Toma sus medicamentos a horas indicada por su médico?",
    "¿Siente alguna molestia cuando toma esa medicación?",
    "¿Qué molestias presenta?",
  ];

  // Variable para manejar la selección de Paciente Expuesto/No Expuesto
  String? _pacienteExpuesto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario Médico Combinado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _guardarFormulario,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormularioSociodemografico(),
              const SizedBox(height: 32),

              // Mostrar el Anexo 5 solo si el paciente está seleccionado como "Expuesto"
              Visibility(
                visible:
                    _pacienteExpuesto == 'Expuesto', // Condición de visibilidad
                child: _buildMedicationForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormularioSociodemografico() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) { // Modo móvil
            return Column(
              children: [
                // Título
                const Text(
                  'ANEXO 3 | Formulario sociodemográfico',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // Radio buttons
                _buildRadioButtonsResponsive(),
                const SizedBox(height: 16),
                
                // Campos de entrada
                _buildNumberInputsResponsive(),
              ],
            );
          } else { // Modo escritorio/tablet
            return Row(
              children: [
                // Título
                const Expanded(
                  flex: 2,
                  child: Text(
                    'ANEXO 3 | Formulario sociodemográfico',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                
                // Radio buttons
                Expanded(
                  flex: 3,
                  child: _buildRadioButtonsResponsive(),
                ),
                
                // Campos de entrada
                Expanded(
                  flex: 2,
                  child: _buildNumberInputsResponsive(),
                ),
              ],
            );
          }
        },
      ),
      const SizedBox(height: 16),

      // Resto del formulario
      _seccionReferenciaInstitucion(),
      const SizedBox(height: 16),
      _seccionDatosPaciente(),
      const SizedBox(height: 16),
      _seccionDatosFisicos(),
      const SizedBox(height: 16),
      _seccionCriteriosDeInclusion(),
      const SizedBox(height: 16),
      _seccionEstiloDeVida(),
    ],
  );
}

Widget _buildRadioButtonsResponsive() {
  return Wrap(
    spacing: 8,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: 'Expuesto',
            groupValue: _pacienteExpuesto,
            onChanged: (value) => setState(() => _pacienteExpuesto = value),
          ),
          const Text('Expuesto'),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: 'No Expuesto',
            groupValue: _pacienteExpuesto,
            onChanged: (value) => setState(() => _pacienteExpuesto = value),
          ),
          const Text('No Expuesto'),
        ],
      ),
    ],
  );
}

Widget _buildNumberInputsResponsive() {
  return Row(
    children: [
      Expanded(
        child: TextField(
          controller: _nroentrevista,
          decoration: const InputDecoration(
            labelText: 'Entrevista N°',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: TextField(
          controller: _nropaciente,
          decoration: const InputDecoration(
            labelText: 'Paciente N°',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
        ),
      ),
    ],
  );
}

  Widget _buildMedicationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ANEXO 5 | Test de Morisky, Gree y Levine modificado',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Preguntas',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                      Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                      Text('SI', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('N° de veces',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            ...List.generate(
              questions.length,
              (index) => TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(questions[index]),
                  ),
                  Radio<bool>(
                    value: false,
                    groupValue: responses[index],
                    onChanged: (value) {
                      setState(() {
                        responses[index] = value;
                        times[index] = null;
                      });
                    },
                  ),
                  Radio<bool>(
                    value: true,
                    groupValue: responses[index],
                    onChanged: (value) {
                      setState(() {
                        responses[index] = value;
                      });
                    },
                  ),
                  Visibility(
                    visible: responses[index] == true,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'N° de veces',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            times[index] = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            print(responses);
            print(times);
          },
          child: const Text('Guardar Respuestas'),
        ),
      ],
    );
  }

  Widget _seccionReferenciaInstitucion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Referencia de Institución de Salud',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _centroSaludController,
                decoration: InputDecoration(
                  labelText: 'Centro de salud',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: _redController,
                decoration: InputDecoration(
                  labelText: 'Red',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: _fechaController,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _seccionDatosPaciente() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Datos del paciente',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: _nombresController,
          decoration: const InputDecoration(
            labelText: 'Nombre(s)',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        const SizedBox(height: 12),
        
        LayoutBuilder(
          builder: (context, constraints) {
            return constraints.maxWidth < 600
                ? Column(
                    children: [
                      _buildApellidoField(_apellidoPaternoController, 'Apellido Paterno'),
                      const SizedBox(height: 12),
                      _buildApellidoField(_apellidoMaternoController, 'Apellido Materno'),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: _buildApellidoField(_apellidoPaternoController, 'Apellido Paterno')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildApellidoField(_apellidoMaternoController, 'Apellido Materno')),
                    ],
                  );
          },
        ),
        const SizedBox(height: 20),
        
        LayoutBuilder(
          builder: (context, constraints) {
            return constraints.maxWidth < 600
                ? Column(
                    children: [
                      _buildGradoInstruccion(),
                      const SizedBox(height: 24),
                      _buildEstadoCivil(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildGradoInstruccion()),
                      const SizedBox(width: 32),
                      Expanded(child: _buildEstadoCivil()),
                    ],
                  );
          },
        ),
      ],
    );
  }

  Widget _buildApellidoField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  Widget _buildGradoInstruccion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Grado de instrucción',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            _buildRadioOption('Primaria', _gradoInstruccion, (v) => setState(() => _gradoInstruccion = v)),
            _buildRadioOption('Secundaria', _gradoInstruccion, (v) => setState(() => _gradoInstruccion = v)),
            _buildRadioOption('Superior', _gradoInstruccion, (v) => setState(() => _gradoInstruccion = v)),
            _buildRadioOption('Posgrado', _gradoInstruccion, (v) => setState(() => _gradoInstruccion = v)),
          ],
        ),
      ],
    );
  }

  Widget _buildEstadoCivil() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estado civil',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            _buildRadioOption('Soltero', _estadoCivil, (v) => setState(() => _estadoCivil = v)),
            _buildRadioOption('Casado', _estadoCivil, (v) => setState(() => _estadoCivil = v)),
            _buildRadioOption('Viudo', _estadoCivil, (v) => setState(() => _estadoCivil = v)),
            _buildRadioOption('Divorciado', _estadoCivil, (v) => setState(() => _estadoCivil = v)),
            _buildRadioOption('Concubinato', _estadoCivil, (v) => setState(() => _estadoCivil = v)),
          ],
        ),
      ],
    );
  }

  Widget _seccionDatosFisicos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Datos Físicos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _edadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Edad',
                  border: const OutlineInputBorder(),
                  suffixText: 'años',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese la edad';
                  if (int.tryParse(value) == null) return 'Edad inválida';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sexo',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Masculino'),
                          value: 'Masculino',
                          groupValue: _genero,
                          onChanged: (value) {
                            setState(() {
                              _genero = value;
                            });
                          },
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Femenino'),
                          value: 'Femenino',
                          groupValue: _genero,
                          onChanged: (value) {
                            setState(() {
                              _genero = value;
                            });
                          },
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _seccionCriteriosDeInclusion() {
    final List<String> medicamentosBase = [
      'Rifampicina 10mg/kg',
      'Isoniazida 15mg/kg',
      'Pirazinamida 1-1.5g-2g',
      'Etambutol 800-1,200-1,600mg',
      'Levofloxacina 15mg-20mg/kg'
    ];

    List<String> medicamentos = List.from(medicamentosBase);
    final Map<String, Map<String, dynamic>> medicamentoData = {
      for (var med in medicamentosBase)
        med: {
          'dosis': 0, // Valor por defecto: 0 (en lugar de null)
          'cantidad': 0, // Valor por defecto: 0 (en lugar de null)
          'reaccionesAdversas':
              '', // Valor por defecto: cadena vacía (en lugar de null)
        },
    };

    bool tratamientoSi = false;
    bool tratamientoNo = false;

    // Variables para almacenar los resultados de diagnóstico
    String? _baciloscopia;
    String? _cultivo;
    String? _pruebaGeneXpert;

    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Criterios de inclusión',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),

          // Diagnóstico de Tuberculosis Pulmonar
          const Text(
            'Diagnóstico de Tuberculosis Pulmonar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Baciloscopia',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _baciloscopia = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Cultivo',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _cultivo = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Prueba GeneXpert',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _pruebaGeneXpert = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Tratamiento con terapia antituberculosa
          const Text(
            'Tratamiento con terapia antituberculosa',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Sí'),
                  value: tratamientoSi,
                  onChanged: (value) {
                    setState(() {
                      tratamientoSi = value!;
                      if (tratamientoSi) tratamientoNo = false;
                    });
                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('No'),
                  value: tratamientoNo,
                  onChanged: (value) {
                    setState(() {
                      tratamientoNo = value!;
                      if (tratamientoNo) tratamientoSi = false;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Fármacos
          const Text(
            'Fármacos:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Column(
            children: medicamentos.map((medicamento) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicamento,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Número de dosis',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  medicamentoData[medicamento]!['dosis'] =
                                      int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Cantidad',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  medicamentoData[medicamento]!['cantidad'] =
                                      int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Reacciones adversas',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            medicamentoData[medicamento]![
                                'reaccionesAdversas'] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final nuevoMedicamento =
                  await _mostrarDialogoNuevoFarmaco(context);
              if (nuevoMedicamento != null && nuevoMedicamento.isNotEmpty) {
                setState(() {
                  medicamentos.add(nuevoMedicamento);
                  medicamentoData[nuevoMedicamento] = {
                    'dosis': null,
                    'cantidad': null,
                    'reaccionesAdversas': null,
                  };
                });
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Añadir nuevo fármaco'),
          ),
        ],
      );
    });
  }

  Future<String?> _mostrarDialogoNuevoFarmaco(BuildContext context) async {
    TextEditingController controlador = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Añadir nuevo fármaco'),
          content: TextField(
            controller: controlador,
            decoration: const InputDecoration(
              labelText: 'Nombre del fármaco',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null); // Cancelar
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controlador.text); // Confirmar
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  Widget _seccionEstiloDeVida() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Estilo de vida',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 12),

      // Actividad Física
      const Text(
        'Actividad física',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Wrap(
        spacing: 10,
        runSpacing: 8,
        children: [
          _buildRadioOption('Diaria', _actividadFisica, (v) => setState(() => _actividadFisica = v)),
          _buildRadioOption('2-3 veces por semana', _actividadFisica, (v) => setState(() => _actividadFisica = v)),
          _buildRadioOption('1 vez por semana', _actividadFisica, (v) => setState(() => _actividadFisica = v)),
          _buildRadioOption('Al menos una vez al mes', _actividadFisica, (v) => setState(() => _actividadFisica = v)),
          _buildRadioOption('Nunca', _actividadFisica, (v) => setState(() => _actividadFisica = v)),
        ],
      ),
      const SizedBox(height: 16),

      // Consumo de Alcohol
      const Text(
        'Consumo de alcohol',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Wrap(
        spacing: 10,
        runSpacing: 8,
        children: [
          _buildRadioOption('Diaria', _consumoAlcohol, (v) => setState(() => _consumoAlcohol = v)),
          _buildRadioOption('>2 veces por semana', _consumoAlcohol, (v) => setState(() => _consumoAlcohol = v)),
          _buildRadioOption('Al menos 1 vez por semana', _consumoAlcohol, (v) => setState(() => _consumoAlcohol = v)),
          _buildRadioOption('>2 veces al mes', _consumoAlcohol, (v) => setState(() => _consumoAlcohol = v)),
          _buildRadioOption('<1 vez al mes', _consumoAlcohol, (v) => setState(() => _consumoAlcohol = v)),
          _buildRadioOption('Nunca', _consumoAlcohol, (v) => setState(() => _consumoAlcohol = v)),
        ],
      ),
      const SizedBox(height: 16),

      // Fuma
      const Text(
        'Fuma',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Wrap(
        spacing: 20,
        children: [
          _buildRadioOption('Sí', _fuma, (v) => setState(() => _fuma = v)),
          _buildRadioOption('No', _fuma, (v) => setState(() => _fuma = v)),
        ],
      ),
      const SizedBox(height: 16),

      // Consumo de Tabaco
      const Text(
        'Consumo de tabaco',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Wrap(
        spacing: 10,
        runSpacing: 8,
        children: [
          _buildRadioOption('Diaria', _consumoTabaco, (v) => setState(() => _consumoTabaco = v)),
          _buildRadioOption('>2 veces por semana', _consumoTabaco, (v) => setState(() => _consumoTabaco = v)),
          _buildRadioOption('Al menos 1 vez por semana', _consumoTabaco, (v) => setState(() => _consumoTabaco = v)),
          _buildRadioOption('>2 veces al mes', _consumoTabaco, (v) => setState(() => _consumoTabaco = v)),
          _buildRadioOption('<1 vez al mes', _consumoTabaco, (v) => setState(() => _consumoTabaco = v)),
          _buildRadioOption('Nunca', _consumoTabaco, (v) => setState(() => _consumoTabaco = v)),
        ],
      ),
      const SizedBox(height: 16),

      // Terapia Alternativa
      const Text(
        'Consumo de terapia alternativa (Hierbas medicinales)',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Wrap(
        spacing: 20,
        children: [
          _buildRadioOption('Sí', _terapiaAlternativa, (v) => setState(() => _terapiaAlternativa = v)),
          _buildRadioOption('No', _terapiaAlternativa, (v) => setState(() => _terapiaAlternativa = v)),
        ],
      ),
      const SizedBox(height: 8),

      if (_terapiaAlternativa == 'Sí')
        TextField(
          controller: _medicinaalternativa,
          decoration: const InputDecoration(
            labelText: 'Cuáles',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          onChanged: (value) => setState(() => _cualesTerapias = value),
        ),
      const SizedBox(height: 20),

      // Pruebas diagnósticas
      const Text(
        'Control de la efectividad terapéutica de tuberculosis pulmonar',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 600
              ? Column(
                  children: [
                    _buildCampoPrueba(_resultadobaciloscopia, 'Basiloscopia'),
                    const SizedBox(height: 12),
                    _buildCampoPrueba(_resultadocultivo, 'Cultivo'),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildCampoPrueba(_resultadobaciloscopia, 'Basiloscopia')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCampoPrueba(_resultadocultivo, 'Cultivo')),
                  ],
                );
        },
      ),
      const SizedBox(height: 16),
      _buildCampoPrueba(_resultadogenexpert, 'GeneXpert'),
    ],
  );
}

Widget _buildCampoPrueba(TextEditingController controller, String label) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: 'Resultado de prueba $label',
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  );
}

  // Método auxiliar para construir opciones de radio
  Widget _buildRadioOption(String label, String? groupValue, ValueChanged<String?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: label,
          groupValue: groupValue,
          onChanged: onChanged,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

void main() => runApp(MaterialApp(
      theme: ThemeData.light(),
      home: MedicationForm(),
    ));

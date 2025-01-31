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
  final TextEditingController _nroveces = TextEditingController();
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
      // Recopilar datos del formulario sociodemográfico
      Map<String, dynamic> formularioData = {
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
          'sexo': _pacienteExpuesto,
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

      // Guardar en Firestore
      DocumentReference docRef = await _firestore
          .collection('formularios_sociodemograficos')
          .add(formularioData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Formulario guardado con ID: ${docRef.id}'),
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
        // Fila para el título, radio buttons y los campos de Entrevista N° y Paciente N°
        Row(
          children: [
            const Text(
              'ANEXO 3 | Formulario sociodemográfico',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(), // Espacio flexible para empujar los campos a la derecha

            // Radio buttons para Paciente Expuesto/No Expuesto
            Row(
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: 'Expuesto',
                      groupValue: _pacienteExpuesto,
                      onChanged: (value) {
                        setState(() {
                          _pacienteExpuesto = value;
                        });
                      },
                    ),
                    const Text('Expuesto'),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'No Expuesto',
                      groupValue: _pacienteExpuesto,
                      onChanged: (value) {
                        setState(() {
                          _pacienteExpuesto = value;
                        });
                      },
                    ),
                    const Text('No Expuesto'),
                  ],
                ),
              ],
            ),
            const SizedBox(
                width: 16), // Espacio entre los radio buttons y los campos

            // Campo de Entrevista N°
            SizedBox(
              width: 150, // Ancho fijo para los cuadrados
              child: TextField(
                controller: _nroentrevista,
                decoration: InputDecoration(
                  labelText: 'Entrevista N°',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 8, horizontal: 8), // Ajustar el padding
                ),
                onChanged: (value) {
                  // Aquí puedes manejar el valor ingresado
                },
              ),
            ),
            const SizedBox(width: 16), // Espacio entre los campos

            // Campo de Paciente N°
            SizedBox(
              width: 150, // Ancho fijo para los cuadrados
              child: TextField(
                controller: _nropaciente,
                decoration: InputDecoration(
                  labelText: 'Paciente N°',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 8, horizontal: 8), // Ajustar el padding
                ),
                onChanged: (value) {
                  // Aquí puedes manejar el valor ingresado
                },
              ),
            ),
          ],
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
                        controller: _nroveces,
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
          decoration: InputDecoration(
            labelText: 'Nombre(s)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _apellidoPaternoController,
                decoration: InputDecoration(
                  labelText: 'Apellido Paterno',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: _apellidoMaternoController,
                decoration: InputDecoration(
                  labelText: 'Apellido Materno',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Grado de instrucción',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Primaria',
                            groupValue: _gradoInstruccion,
                            onChanged: (value) {
                              setState(() {
                                _gradoInstruccion = value;
                              });
                            },
                          ),
                          const Text('Primaria'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Secundaria',
                            groupValue: _gradoInstruccion,
                            onChanged: (value) {
                              setState(() {
                                _gradoInstruccion = value;
                              });
                            },
                          ),
                          const Text('Secundaria'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Superior',
                            groupValue: _gradoInstruccion,
                            onChanged: (value) {
                              setState(() {
                                _gradoInstruccion = value;
                              });
                            },
                          ),
                          const Text('Superior'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Posgrado',
                            groupValue: _gradoInstruccion,
                            onChanged: (value) {
                              setState(() {
                                _gradoInstruccion = value;
                              });
                            },
                          ),
                          const Text('Posgrado'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estado civil',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Soltero',
                            groupValue: _estadoCivil,
                            onChanged: (value) {
                              setState(() {
                                _estadoCivil = value;
                              });
                            },
                          ),
                          const Text('Soltero'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Casado',
                            groupValue: _estadoCivil,
                            onChanged: (value) {
                              setState(() {
                                _estadoCivil = value;
                              });
                            },
                          ),
                          const Text('Casado'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Viudo',
                            groupValue: _estadoCivil,
                            onChanged: (value) {
                              setState(() {
                                _estadoCivil = value;
                              });
                            },
                          ),
                          const Text('Viudo'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Divorciado',
                            groupValue: _estadoCivil,
                            onChanged: (value) {
                              setState(() {
                                _estadoCivil = value;
                              });
                            },
                          ),
                          const Text('Divorciado'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Concubinato',
                            groupValue: _estadoCivil,
                            onChanged: (value) {
                              setState(() {
                                _estadoCivil = value;
                              });
                            },
                          ),
                          const Text('Concubinato'),
                        ],
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
              child: TextField(
                controller: _edadController,
                decoration: InputDecoration(
                  labelText: 'Edad',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: _pesoController,
                decoration: InputDecoration(
                  labelText: 'Peso corporal',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: _tallaController,
                decoration: InputDecoration(
                  labelText: 'Talla',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: _imcController,
                decoration: InputDecoration(
                  labelText: 'IMC',
                  border: OutlineInputBorder(),
                ),
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),

        // Actividad Física
        const Text(
          'Actividad física',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            _buildRadioOption('Diaria', _actividadFisica, (value) {
              setState(() {
                _actividadFisica = value;
              });
            }),
            _buildRadioOption('2-3 veces por semana', _actividadFisica,
                (value) {
              setState(() {
                _actividadFisica = value;
              });
            }),
            _buildRadioOption('1 vez por semana', _actividadFisica, (value) {
              setState(() {
                _actividadFisica = value;
              });
            }),
            _buildRadioOption('Al menos una vez al mes', _actividadFisica,
                (value) {
              setState(() {
                _actividadFisica = value;
              });
            }),
            _buildRadioOption('Nunca', _actividadFisica, (value) {
              setState(() {
                _actividadFisica = value;
              });
            }),
          ],
        ),
        const SizedBox(height: 16.0),

        // Consumo de Alcohol
        const Text(
          'Consumo de alcohol',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            _buildRadioOption('Diaria', _consumoAlcohol, (value) {
              setState(() {
                _consumoAlcohol = value;
              });
            }),
            _buildRadioOption('>2 veces por semana', _consumoAlcohol, (value) {
              setState(() {
                _consumoAlcohol = value;
              });
            }),
            _buildRadioOption('Al menos 1 vez por semana', _consumoAlcohol,
                (value) {
              setState(() {
                _consumoAlcohol = value;
              });
            }),
            _buildRadioOption('>2 veces al mes', _consumoAlcohol, (value) {
              setState(() {
                _consumoAlcohol = value;
              });
            }),
            _buildRadioOption('<1 vez al mes', _consumoAlcohol, (value) {
              setState(() {
                _consumoAlcohol = value;
              });
            }),
            _buildRadioOption('Nunca', _consumoAlcohol, (value) {
              setState(() {
                _consumoAlcohol = value;
              });
            }),
          ],
        ),
        const SizedBox(height: 16.0),

        // Fuma
        const Text(
          'Fuma',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            _buildRadioOption('Sí', _fuma, (value) {
              setState(() {
                _fuma = value;
              });
            }),
            _buildRadioOption('No', _fuma, (value) {
              setState(() {
                _fuma = value;
              });
            }),
          ],
        ),
        const SizedBox(height: 16.0),

        // Consumo de Tabaco
        const Text(
          'Consumo de tabaco',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            _buildRadioOption('Diaria', _consumoTabaco, (value) {
              setState(() {
                _consumoTabaco = value;
              });
            }),
            _buildRadioOption('>2 veces por semana', _consumoTabaco, (value) {
              setState(() {
                _consumoTabaco = value;
              });
            }),
            _buildRadioOption('Al menos 1 vez por semana', _consumoTabaco,
                (value) {
              setState(() {
                _consumoTabaco = value;
              });
            }),
            _buildRadioOption('>2 veces al mes', _consumoTabaco, (value) {
              setState(() {
                _consumoTabaco = value;
              });
            }),
            _buildRadioOption('<1 vez al mes', _consumoTabaco, (value) {
              setState(() {
                _consumoTabaco = value;
              });
            }),
            _buildRadioOption('Nunca', _consumoTabaco, (value) {
              setState(() {
                _consumoTabaco = value;
              });
            }),
          ],
        ),
        const SizedBox(height: 16.0),

        // Consumo de Terapia Alternativa (Hierbas Medicinales)
        const Text(
          'Consumo de terapia alternativa (Hierbas medicinales)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            _buildRadioOption('Sí', _terapiaAlternativa, (value) {
              setState(() {
                _terapiaAlternativa = value;
              });
            }),
            _buildRadioOption('No', _terapiaAlternativa, (value) {
              setState(() {
                _terapiaAlternativa = value;
              });
            }),
          ],
        ),
        const SizedBox(height: 8.0),

        // Campo de texto para "Cuáles"
        if (_terapiaAlternativa == 'Sí')
          TextField(
            controller: _medicinaalternativa,
            decoration: InputDecoration(
              labelText: 'Cuáles',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _cualesTerapias = value;
              });
            },
          ),

        const SizedBox(height: 16.0),

        // Control de la efectividad terapéutica de tuberculosis pulmonar
        const Text(
          'Control de la efectividad terapéutica de tuberculosis pulmonar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _resultadobaciloscopia,
                decoration: InputDecoration(
                  labelText: 'Resultado de prueba Basiloscopia',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Aquí puedes manejar el valor ingresado
                },
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: TextField(
                controller: _resultadocultivo,
                decoration: InputDecoration(
                  labelText: 'Resultado de prueba de cultivo',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Aquí puedes manejar el valor ingresado
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),

        // Resultado de prueba GeneXpert
        const Text(
          'Resultado de prueba GeneXpert',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: _resultadogenexpert,
          decoration: InputDecoration(
            labelText: 'Resultado de prueba GeneXpert',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            // Aquí puedes manejar el valor ingresado
          },
        ),
      ],
    );
  }

  // Método auxiliar para construir opciones de radio
  Widget _buildRadioOption(
      String label, String? groupValue, Function(String?) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: label,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }
}

void main() => runApp(MaterialApp(
      theme: ThemeData.light(),
      home: MedicationForm(),
    ));

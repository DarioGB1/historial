import 'package:flutter/material.dart';

class MedicationForm extends StatefulWidget {
  const MedicationForm({Key? key}) : super(key: key);

  @override
  _MedicationFormState createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  String? _gradoInstruccion; 
  String? _estadoCivil; 
  final Map<int, bool?> responses = {};
  final Map<int, String?> times = {}; // Nuevo mapa para almacenar el número de veces
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario Médico Combinado'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormularioSociodemografico(),
              const SizedBox(height: 32),
              _buildMedicationForm(),
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
        const Text(
          'ANEXO 3 | Formulario sociodemográfico',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
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
                decoration: InputDecoration(
                  labelText: 'Centro de salud',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Red',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
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
                decoration: InputDecoration(
                  labelText: 'Apellido Paterno',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
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
                decoration: InputDecoration(
                  labelText: 'Edad',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Peso corporal',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Talla',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
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
      'Pirazinamida 1-1.5g',
      'Etambutol 800-1,600mg',
    ];

    List<String> medicamentos = List.from(medicamentosBase);
    final Map<String, Map<String, dynamic>> medicamentoData = {
      for (var med in medicamentosBase)
        med: {'dosis': null, 'cantidad': null},
    };

    bool tratamientoSi = false;
    bool tratamientoNo = false;

    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Criterios de inclusión',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
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
                                      int.tryParse(value);
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
                                      int.tryParse(value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final nuevoMedicamento = await _mostrarDialogoNuevoFarmaco(context);
              if (nuevoMedicamento != null && nuevoMedicamento.isNotEmpty) {
                setState(() {
                  medicamentos.add(nuevoMedicamento);
                  medicamentoData[nuevoMedicamento] = {
                    'dosis': null,
                    'cantidad': null,
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
        Wrap(
          children: [
            _checkboxOption('Actividad física diaria'),
            _checkboxOption('Consumo de alcohol'),
            _checkboxOption('Fuma'),
            _checkboxOption('Consumo de tabaco'),
            _checkboxOption('Consumo de terapias alternativas'),
          ],
        ),
      ],
    );
  }

  Widget _checkboxOption(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: false,
          onChanged: (value) {},
        ),
        Text(title),
      ],
    );
  }
}

void main() => runApp(MaterialApp(
      theme: ThemeData.light(),
      home: MedicationForm(),
    ));
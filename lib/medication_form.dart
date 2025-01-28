import 'package:flutter/material.dart';

class MedicationForm extends StatefulWidget {
  const MedicationForm({Key? key}) : super(key: key);

  @override
  _MedicationFormState createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  final Map<int, bool?> responses = {};
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
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Aquí puedes implementar la lógica para guardar las respuestas
            print(responses);
          },
          child: const Text('Guardar Respuestas'),
        ),
      ],
    );
  }

  // Modified methods from FormularioSociodemografico to use light theme
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
                  Wrap(
                    children: [
                      _checkboxOption('Primaria'),
                      _checkboxOption('Secundaria'),
                      _checkboxOption('Superior'),
                      _checkboxOption('Posgrado'),
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
                  Wrap(
                    children: [
                      _checkboxOption('Soltero'),
                      _checkboxOption('Casado'),
                      _checkboxOption('Viudo'),
                      _checkboxOption('Divorciado'),
                      _checkboxOption('Concubinato'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Criterios de inclusión',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Wrap(
          children: [
            _checkboxOption('Baciloscopía'),
            _checkboxOption('Cultivo'),
            _checkboxOption('Prueba GeneXpert'),
          ],
        ),
        const SizedBox(height: 8.0),
        const Text(
          'Tratamiento con terapia antituberculosa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Wrap(
          children: [
            _checkboxOption('Rifampicina 10mg/kg'),
            _checkboxOption('Isoniazida 15mg/kg'),
            _checkboxOption('Pirazinamida 1-1.5g'),
            _checkboxOption('Etambutol 800-1,600mg'),
          ],
        ),
      ],
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

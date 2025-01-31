import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = '';
  String filter = 'Todos';

  late FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
  }

  // Método para obtener pacientes desde Firebase
  Future<List<Map<String, dynamic>>> getFilteredPatients() async {
    Query query = _firestore.collection('formularios_sociodemograficos');

    if (searchTerm.isNotEmpty) {
      query = query.where('nro_paciente', isEqualTo: searchTerm);
    }

    if (filter != 'Todos') {
      query = query.where('paciente_expuesto', isEqualTo: filter);
    }

    var snapshot = await query.get();
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      
      return {
        'nro_paciente': data['nro_paciente'] ?? '',
        'nombre': data['datos_paciente']?['nombres'] ?? 'Sin nombre',
        'estado': data['paciente_expuesto'] ?? 'Desconocido',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Pacientes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar por Nro. Paciente',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filter = 'Expuesto';
                    });
                  },
                  child: const Text('Expuestos'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filter = 'No Expuesto';
                    });
                  },
                  child: const Text('No Expuestos'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filter = 'Todos';
                    });
                  },
                  child: const Text('Todos'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: getFilteredPatients(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error al cargar los datos'));
                  }

                  var patients = snapshot.data ?? [];

                  if (patients.isEmpty) {
                    return const Center(child: Text('No se encontraron pacientes'));
                  }

                  return ListView.builder(
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final patient = patients[index];
                      return Card(
                        child: ListTile(
                          title: Text('Paciente: ${patient['nombre']}'),
                          subtitle: Text('Estado: ${patient['estado']}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientDetailScreen(patient: patient),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientDetailScreen extends StatelessWidget {
  final Map<String, dynamic> patient;

  const PatientDetailScreen({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nro. Paciente: ${patient['nro_paciente']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Nombre: ${patient['nombre']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Estado: ${patient['estado']}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
//Les mostraremos ,Les mostraremos a todos 
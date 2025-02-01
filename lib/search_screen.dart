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

  // Método para obtener pacientes desde Firebase con filtro
  Future<List<Map<String, dynamic>>> getFilteredPatients() async {
    CollectionReference collectionRef = _firestore.collection('form_soc');

    if (searchTerm.isNotEmpty) {
      var docSnapshot = await collectionRef.doc(searchTerm).get();
      if (docSnapshot.exists) {
        var historialSnapshot = await collectionRef
            .doc(searchTerm)
            .collection('historial')
            .orderBy('fecha', descending: true)
            .limit(1)
            .get();

        var estado = 'Desconocido';
        if (historialSnapshot.docs.isNotEmpty) {
          estado = historialSnapshot.docs.first['paciente_expuesto'] ?? 'Desconocido';
        }

        if (filter == 'Todos' || estado == filter) {
          var data = docSnapshot.data() as Map<String, dynamic>;
          return [
            {
              'nro_paciente': docSnapshot.id,
              'nombre': data['datos_paciente']?['nombres'] ?? 'Sin nombre',
              'estado': estado,
            }
          ];
        }
      }
      return [];
    }

    var snapshot = await collectionRef.get();
    var pacientes = <Map<String, dynamic>>[];

    for (var doc in snapshot.docs) {
      var historialSnapshot = await doc.reference
          .collection('historial')
          .orderBy('fecha', descending: true)
          .limit(1)
          .get();

      var estado = 'Desconocido';
      if (historialSnapshot.docs.isNotEmpty) {
        estado = historialSnapshot.docs.first['paciente_expuesto'] ?? 'Desconocido';
      }

      if (filter == 'Todos' || estado == filter) {
        var data = doc.data() as Map<String, dynamic>;
        pacientes.add({
          'nro_paciente': doc.id,
          'nombre': data['datos_paciente']?['nombres'] ?? 'Sin nombre',
          'estado': estado,
        });
      }
    }

    return pacientes;
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
                                builder: (context) => PatientDetailScreen(patientId: patient['nro_paciente']),
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
  final String patientId;

  const PatientDetailScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Paciente')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('form_soc').doc(patientId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Error al cargar los datos del paciente'));
          }

          var patientData = snapshot.data!.data() as Map<String, dynamic>;
          var datosPaciente = patientData['datos_paciente'] as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nro. Paciente: $patientId', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Nombre: ${datosPaciente['nombres']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Apellido Paterno: ${datosPaciente['apellido_paterno']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Apellido Materno: ${datosPaciente['apellido_materno']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Edad: ${datosPaciente['edad']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Sexo: ${datosPaciente['sexo']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                const Text('Historial de Formularios:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('form_soc')
                      .doc(patientId)
                      .collection('historial')
                      .orderBy('fecha', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError || !snapshot.hasData) {
                      return const Center(child: Text('Error al cargar el historial'));
                    }

                    var historial = snapshot.data!.docs;

                    if (historial.isEmpty) {
                      return const Center(child: Text('No hay formularios en el historial'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: historial.length,
                      itemBuilder: (context, index) {
                        var formulario = historial[index].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text('Entrevista N°: ${formulario['nro_entrevista']}'),
                          subtitle: Text('Estado: ${formulario['paciente_expuesto']}'),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

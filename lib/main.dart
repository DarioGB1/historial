import 'package:flutter/material.dart';

class FormularioSociodemografico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario Sociodemográfico'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'PACIENTE N°',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Centro de Salud',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Red',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre(s)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Apellido Paterno',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Apellido Materno',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Grado de Instrucción',
                border: OutlineInputBorder(),
              ),
              items: ['Primaria', 'Secundaria', 'Superior', 'Posgrado']
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Estado Civil',
                border: OutlineInputBorder(),
              ),
              items: ['Soltero', 'Casado', 'Viudo', 'Divorciado', 'Concubinato']
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Edad',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Masculino'),
                    value: 'Masculino',
                    groupValue: null,
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Femenino'),
                    value: 'Femenino',
                    groupValue: null,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Peso Corporal (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Talla (cm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'IMC',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32.0),
            Text('Criterios de Inclusión',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: Text('Diagnóstico de Tuberculosis Pulmonar'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Baciloscopia'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Cultivo'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Prueba GeneXpert'),
              value: false,
              onChanged: (value) {},
            ),
            SizedBox(height: 16.0),
            Text('Tratamiento con Terapia Antituberculosis',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: Text('Rifampicina 10mg/kg'),
              value: false,
              onChanged: (value) {},
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Dosis (Cantidad Comprimido)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            CheckboxListTile(
              title: Text('Isoniazida 15mg/kg'),
              value: false,
              onChanged: (value) {},
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Dosis',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            CheckboxListTile(
              title: Text('Piracinamida 1-1.5,2 g'),
              value: false,
              onChanged: (value) {},
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Dosis',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            CheckboxListTile(
              title: Text('Etambutol 800.1.200,1.600mg'),
              value: false,
              onChanged: (value) {},
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Dosis',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Acción al enviar el formulario
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: FormularioSociodemografico(),
      debugShowCheckedModeBanner: false,
    ));

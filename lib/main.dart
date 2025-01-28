import 'package:flutter/material.dart';

class FormularioSociodemografico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ANEXO 3 | Formulario sociodemográfico'),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _seccionReferenciaInstitucion(),
              SizedBox(height: 16.0),
              _seccionDatosPaciente(),
              SizedBox(height: 16.0),
              _seccionDatosFisicos(),
              SizedBox(height: 16.0),
              _seccionCriteriosDeInclusion(),
              SizedBox(height: 16.0),
              _seccionEstiloDeVida(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seccionReferenciaInstitucion() {
    return Container(
      color: Colors.grey[800],
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Referencia de Institución de Salud',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Centro de salud',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[700],
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Red',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[700],
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[700],
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seccionDatosPaciente() {
    return Container(
      color: Colors.grey[800],
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos del paciente',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Nombre(s)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[700],
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Apellido Paterno',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[700],
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Apellido Materno',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[700],
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grado de instrucción',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
              SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado civil',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Widget _seccionDatosFisicos() {
    return Container(
      color: Colors.grey[800],
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos Físicos',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Edad',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[700],
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Peso corporal',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[700],
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Talla',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[700],
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'IMC',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[700],
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seccionCriteriosDeInclusion() {
    return Container(
      color: Colors.grey[800],
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Criterios de inclusión',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Wrap(
            children: [
              _checkboxOption('Baciloscopía'),
              _checkboxOption('Cultivo'),
              _checkboxOption('Prueba GeneXpert'),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            'Tratamiento con terapia antituberculosa',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Wrap(
            children: [
              _checkboxOption('Rifampicina 10mg/kg'),
              _checkboxOption('Isoniazida 15mg/kg'),
              _checkboxOption('Pirazinamida 1-1.5g'),
              _checkboxOption('Etambutol 800-1,600mg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seccionEstiloDeVida() {
    return Container(
      color: Colors.grey[800],
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estilo de vida',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
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
      ),
    );
  }

  Widget _checkboxOption(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: false,
          onChanged: (value) {},
          activeColor: Colors.white,
          checkColor: Colors.black,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

void main() => runApp(MaterialApp(
      theme: ThemeData.dark(),
      home: FormularioSociodemografico(),
    ));

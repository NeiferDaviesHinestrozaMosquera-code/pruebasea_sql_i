import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pruebasea/Screens/crud_scrren_edit.dart';
import 'package:pruebasea/database/helper.dart';
import 'package:pruebasea/model/crud_model.dart';

class NotasPage extends StatefulWidget {
  @override
  _NotasPageState createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final _databaseHelper = DatabaseHelper.instance;

  late List<Nota> _notas;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotas();
  }

  Future<void> _loadNotas() async {
    final notas = await _databaseHelper.queryAllRows();
    setState(() {
      _notas = notas;
      _isLoading = false;
    });
  }

  Future<void> _onNotaPressed(Nota nota) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
       builder: (context) => NotaEditPage(nota: nota),
      ),
    );
    if (result != null && result) {
      // Actualizar la lista de notas
      await _loadNotas();
    }
  }

  Future<void> _onAgregarNotaPressed() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NotaEditPage(),
      ),
    );
    if (result != null && result) {
      // Actualizar la lista de notas
      await _loadNotas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        
        title: Text("CRUD Fruits"),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _notas.isEmpty
              ? Center(child: Text('No hay notas'))
              : ListView.builder(
                  itemCount: _notas.length,
                  itemBuilder: (context, index) {
                    final nota = _notas[index];
               
                    return Padding(
  padding: const EdgeInsets.all(8.0),
  child: Card(
    color: const Color.fromARGB(255, 216, 146, 141),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListTile(
              title: Text(nota.titulo),
              subtitle: Text(nota.contenido),
              leading: nota.imagen != null
                  ? Image.file(File(nota.imagen!))
                  : null,
              onTap: () => _onNotaPressed(nota),
            ),
          ),
          IconButton(
            onPressed: (){
              _databaseHelper.delete(nota.id!);
              _loadNotas();
              print('Borrado');
            }, 
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    ),
  ),
);
                   
                  },
                  
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAgregarNotaPressed,
        child: Icon(Icons.add),
     ));
  }
}
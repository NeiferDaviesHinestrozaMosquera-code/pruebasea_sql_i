import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pruebasea/database/helper.dart';
import 'package:pruebasea/model/crud_model.dart';

class NotaEditPage extends StatefulWidget {
  final Nota? nota;

  const NotaEditPage({Key? key, this.nota}) : super(key: key);

  @override
  _NotaEditPageState createState() => _NotaEditPageState();
}

class _NotaEditPageState extends State<NotaEditPage> {
  final _formKey = GlobalKey<FormState>();

  late String _titulo;
  late String _contenido;
  String? _imagenPath;

  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();

  final _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    if (widget.nota != null) {
      _titulo = widget.nota!.titulo;
      _contenido = widget.nota!.contenido;
      _imagenPath = widget.nota!.imagen;
      _tituloController.text = _titulo;
      _contenidoController.text = _contenido;
    } else {
      _titulo = '';
      _contenido = '';
      _imagenPath = null;
    }
  }

  Future<void> _onGuardarPressed() async {
    if (_formKey.currentState!.validate()) {
      final nota = Nota(
        titulo: _titulo,
        contenido: _contenido,
        imagen: _imagenPath,
      );
      if (widget.nota != null) {
        nota.id = widget.nota!.id;
        await _databaseHelper.update(nota);
      } else {
        await _databaseHelper.insert(nota);
      }
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _onSeleccionarImagenPressed() async {
    final imagenPath = await _databaseHelper.pickImage();
    if (imagenPath != null) {
      setState(() {
        _imagenPath = imagenPath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.nota != null ? 'Editar crud' : 'Nueva crud'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            cursorColor: Colors.purple,
                            controller: _tituloController,
                            decoration: InputDecoration(
                                labelText: 'Título',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                        
                                      ),
                                    
                                  ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es requerido';
                              }
                              return null;
                            },
                            onChanged: (value) =>
                                setState(() => _titulo = value),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _contenidoController,
                            decoration: InputDecoration(
                                labelText: 'Contenido',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es requerido';
                              }
                              return null;
                            },
                            onChanged: (value) =>
                                setState(() => _contenido = value),
                          ),
                          SizedBox(height: 16),
                          _imagenPath != null
                              ? Image.file(File(_imagenPath!))
                              : SizedBox.shrink(),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _onSeleccionarImagenPressed,
                            child: Text('Seleccionar imagen'),
                          ),
                          SizedBox(height: 16),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('Cancelar'),
                                ),

                                SizedBox(width: 16),

                                ElevatedButton(
                                  onPressed: _onGuardarPressed,
                                  child: Text(widget.nota != null
                                      ? 'Guardar cambios'
                                      : 'Guardar'),
                                )
                              ]
                            )
                        ]
                      )
                    )
                  )
                )
              );
  }
}

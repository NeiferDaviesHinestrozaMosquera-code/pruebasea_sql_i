import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pruebasea/model/crud_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseHelper {
  static final _databaseName = "NotasDB.db";
  
  static final _databaseVersion = 1;

  static final table = 'notas';

  static final columnId = 'id';
  static final columnTitulo = 'titulo';
  static final columnContenido = 'contenido';
  static final columnImagen = 'imagen';



  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitulo TEXT NOT NULL,
            $columnContenido TEXT NOT NULL,
            $columnImagen TEXT
          )
          ''');
  }

// Imagen
  Future<String?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      return null;
    }
  }

  // Insertar nota
  Future<int> insert(Nota nota) async {
    print("nombre : ${_database}");
    Database db = await instance.database;
    return await db.insert(table, nota.toMap());
  }

// Obtener todas las notas
  Future<List<Nota>> queryAllRows() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) => Nota.fromMap(maps[i]));
  }

// Actualizar nota
  Future<int> update(Nota nota) async {
    Database db = await instance.database;
    return await db.update(table, nota.toMap(),
        where: '$columnId = ?', whereArgs: [nota.id]);
  }

// Eliminar nota
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}

class Nota {
  int? id;
  String titulo;
  String contenido;
  String? imagen;

  Nota({required this.titulo, required this.contenido, this.imagen, this.id});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'titulo': titulo,
      'contenido': contenido,
      'imagen': imagen,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Nota.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        titulo = map['titulo'],
        contenido = map['contenido'],
        imagen = map['imagen'];
}
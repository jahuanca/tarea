class BuscarLineaMesaEntity {
  BuscarLineaMesaEntity({
    this.fecha,
    this.grupo,
    this.linea,
    this.turno,
    this.sizeDetails,
    this.sizePersonalMesa,
    this.itempretareaesparragovarios,
  });

  DateTime fecha;
  String turno;
  int linea;
  int grupo;
  int itempretareaesparragovarios;
  int sizeDetails;
  int sizePersonalMesa;

  Map<String, dynamic> toJson() => {
        //"fecha": fecha == null ? null : '2022-12-26',
        "fecha": fecha == null
            ? null
            : "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "turno": turno == null ? null : turno,
        "linea": linea == null ? null : linea,
        "sizePersonalMesa": sizePersonalMesa == null ? null : sizePersonalMesa,
        "itempretareaesparragovarios": itempretareaesparragovarios == null
            ? null
            : itempretareaesparragovarios,
      };

  factory BuscarLineaMesaEntity.fromJson(Map<String, dynamic> json) =>
      BuscarLineaMesaEntity(
        fecha: json["fecha"] == null ? null : json["fecha"],
        turno: json["turno"] == null ? null : json["turno"],
        sizePersonalMesa:
            json["sizePersonalMesa"] == null ? null : json["sizePersonalMesa"],
        linea: json["linea"] == null ? null : json["linea"],
        itempretareaesparragovarios: json["itempretareaesparragovarios"] == null
            ? null
            : json["itempretareaesparragovarios"],
      );
}

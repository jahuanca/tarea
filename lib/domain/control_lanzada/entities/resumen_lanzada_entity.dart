import 'dart:convert';

class ResumenLanzadaEntity {
  ResumenLanzadaEntity({
    this.itempersonalpretareaesparrago,
    this.linea,
    this.mesa,
    this.sizeDetails,
  });

  int itempersonalpretareaesparrago;
  int linea;
  int mesa;
  int sizeDetails;

  factory ResumenLanzadaEntity.fromJson(Map<String, dynamic> json) =>
      ResumenLanzadaEntity(
          itempersonalpretareaesparrago: json["itempersonalpretareaesparrago"],
          linea: int.tryParse(json["linea"]),
          mesa: int.tryParse(json["mesa"]),
          sizeDetails: json["sizeDetails"]);

  Map<String, dynamic> toJson() => {
        "itempersonalpretareaesparrago": itempersonalpretareaesparrago,
        "linea": linea,
        "mesa": mesa,
        "sizeDetails": sizeDetails,
      };
}

List<ResumenLanzadaEntity> resumenLanzadaEntityFromJson(String str) =>
    List<ResumenLanzadaEntity>.from(
        json.decode(str).map((x) => ResumenLanzadaEntity.fromJson(x)));

String resumenLanzadaEntityToJson(List<ResumenLanzadaEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

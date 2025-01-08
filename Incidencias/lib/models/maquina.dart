import 'dart:convert';

import 'package:incidencias/utils/centro_trabajo.dart';

class Maquina {
  int? id;
  CentroTrabajo? centroTrabajo;
  String? tipo;
  String? fabricante;
  String? nombreMaquina;
  String? descripcion;
  String? matricula;
  String? centroCoste;
  bool? baja;

  Maquina({
    required this.id,
    required this.centroTrabajo,
    required this.tipo,
    required this.fabricante,
    required this.nombreMaquina,
    required this.descripcion,
    required this.matricula,
    required this.centroCoste,
    required this.baja,
  });

  Maquina.Vacia();

  factory Maquina.fromJson(Map<String, dynamic> json) => Maquina(
        id: json["Id"] ?? 0,
        centroTrabajo: CentroTrabajo.values.firstWhere(
          (ct) => ct.value == (json["CentroTrabajo"] ?? CentroTrabajo.Default),
        ),
        tipo: json["Tipo"] ?? '',
        fabricante: json["Fabricante"] ?? '',
        nombreMaquina: json["NombreMaquina"] ?? '',
        descripcion: json["Descripcion"] ?? '',
        matricula: json["Matricula"] ?? '',
        centroCoste: json["CentroCoste"] ?? '',
        baja: json["Baja"] == 0 ? false : true,
      );

  factory Maquina.fromRawJson(String s) => Maquina.fromJson(json.decode(s));

  @override
  String toString() {
    return 'Maquina{id: $id, centroTrabajo: $centroTrabajo, tipo: $tipo, fabricante: $fabricante, nombreMaquina: $nombreMaquina, descripcion: $descripcion, matricula: $matricula, centroCoste: $centroCoste, baja: $baja}';
  }
}

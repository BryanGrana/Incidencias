import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:incidencias/models/maquina.dart';
import '../utils/centro_trabajo.dart';

class MaquinaResponse {
  final List<Maquina> maquinas;

  MaquinaResponse({required this.maquinas});

  factory MaquinaResponse.fromJson(List<dynamic> json) {
    List<Maquina> e = [];

    for (var element in json) {
      Maquina m = Maquina(
        id: element["Id"] ?? 0,
        centroTrabajo: CentroTrabajo.values.firstWhere(
          (ct) =>
              ct.value == (element["CentroTrabajo"] ?? CentroTrabajo.Default),
        ),
        tipo: element["Tipo"] ?? '',
        fabricante: element["Fabricante"] ?? '',
        nombreMaquina: element["NombreMaquina"] ?? '',
        descripcion: element["Descripcion"] ?? '',
        matricula: element["Matricula"] ?? '',
        centroCoste: element["CentroCoste"] ?? '',
        baja: element["Baja"] ?? false,
      );

      e.add(m);
    }

    if(kDebugMode) {
    //  print("AAAAAAAAAAAAAAAAAAA: ${e[0].toString()}");
    }

    return MaquinaResponse(maquinas: e);
  }

  factory MaquinaResponse.fromRawJson(String str) =>
      MaquinaResponse.fromJson(json.decode(str));
}

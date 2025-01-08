import 'dart:convert';

import 'package:incidencias/models/incidencia_mantenimiento.dart';

class IncidenciaMantenimientoResponse {
  List<IncidenciaMantenimiento> incidencias;

  IncidenciaMantenimientoResponse({required this.incidencias});

  factory IncidenciaMantenimientoResponse.fromJson(List<dynamic> json) {
    List<IncidenciaMantenimiento> e = [];

    for (var element in json) {
      IncidenciaMantenimiento i = IncidenciaMantenimiento(
        id: element["Id"],
        idMaquina: element['IdMaquina'],
        dniRegistrador: element['DNIRegistrador'] ?? "",
        descripcion: element['Descripcion'] ?? "",
        importancia: element['Importancia'] ?? "",
        afectaSeguridad: element['AfectaSeguridad'],
        maquinaParada: element['MaquinaParada'],
        requiereRepuesto: element['RequiereRepuesto'],
        tipoAveria: element['TipoAveria'] ?? "",
        solucion: element['Solucion'] ?? "",
        estado: element['Estado'],
        fechaCreacion: DateTime.tryParse(element['FechaCreacion'] ?? ""),
        fechaProvisional: DateTime.tryParse(element['FechaProvisional'] ?? ""),
        fechaDefinitiva: DateTime.tryParse(element['FechaDefinitiva'] ?? ""),
        costeMateriales: element['CosteMateriales'],
        costeEstimadoPropio: element['CosteEstimadoPropio'],
        costeSubcontrata: element['CosteSubcontrata'],
        solucionada: element['Solucionada'],
        borrada: element['Borrada'],
      );
      e.add(i);
    }

    return IncidenciaMantenimientoResponse(incidencias: e);
  }

  factory IncidenciaMantenimientoResponse.fromRawJson(String str) =>
      IncidenciaMantenimientoResponse.fromJson(json.decode(str));
}

class IncidenciaMantenimiento {
  int? id;
  int? idMaquina;
  String? dniRegistrador;
  String? descripcion;
  String? importancia;
  bool? afectaSeguridad;
  bool? requiereRepuesto;
  bool? maquinaParada;
  String? tipoAveria;
  String? solucion;
  String? estado;
  DateTime? fechaCreacion;
  DateTime? fechaProvisional;
  DateTime? fechaDefinitiva;
  double? costeMateriales;
  double? costeEstimadoPropio;
  double? costeSubcontrata;
  bool? solucionada;
  bool? borrada;

  IncidenciaMantenimiento({
    required this.id,
    required this.idMaquina,
    required this.dniRegistrador,
    required this.descripcion,
    required this.importancia,
    required this.afectaSeguridad,
    required this.requiereRepuesto,
    required this.maquinaParada,
    required this.tipoAveria,
    required this.solucion,
    required this.estado,
    this.fechaCreacion,
    this.fechaProvisional,
    this.fechaDefinitiva,
    required this.costeMateriales,
    required this.costeEstimadoPropio,
    required this.costeSubcontrata,
    required this.solucionada,
    required this.borrada,
  });

  // Método para convertir de JSON a objeto
  factory IncidenciaMantenimiento.fromJson(Map<String, dynamic> json) {
    return IncidenciaMantenimiento(
      id: json["Id"],
      idMaquina: json['IdMaquina'],
      dniRegistrador: json['DNIRegistrador'].toString(),
      descripcion: json['Descripcion'],
      importancia: json['Importancia'],
      afectaSeguridad: json['AfectaSeguridad'],
      maquinaParada: json['MaquinaParada'],
      requiereRepuesto: json['RequiereRepuesto'],
      tipoAveria: json['TipoAveria'],
      solucion: json['Solucion'],
      estado: json['estado'],
      fechaCreacion: json['FechaCreacion'],
      fechaProvisional: json['FechaProvisional'],
      fechaDefinitiva: json['FechaDefinitiva'],
      costeMateriales: double.tryParse(json['CosteMateriales']),
      costeEstimadoPropio: double.tryParse(json['CosteEstimadoPropio']),
      costeSubcontrata: double.tryParse(json['CosteSubcontrata']),
      solucionada: json['solucionada'],
      borrada: json['borrada'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'IdMaquina': idMaquina,
      'DNIRegistrador': dniRegistrador,
      'Descripcion': descripcion,
      'Importancia': importancia,
      'AfectaSeguridad': afectaSeguridad,
      'RequiereRepuesto': requiereRepuesto,
      'MaquinaParada': maquinaParada,
      'TipoAveria': tipoAveria,
      'Solucion': solucion,
      'Estado': estado,
      'CosteMateriales': costeMateriales,
      'CosteEstimadoPropio': costeEstimadoPropio,
      'CosteSubcontrata': costeSubcontrata,
      'Solucionada': solucionada,
      'Borrada' : false,
    };
  }

  IncidenciaMantenimiento.vacio();

  @override
  String toString() {
    return 'IncidenciaMantenimiento{id: $id, idMaquina: $idMaquina, dniRegistrador: $dniRegistrador, descripcion: $descripcion, importancia: $importancia, afectaSeguridad: $afectaSeguridad, requiereRepuesto: $requiereRepuesto, tipoAveria: $tipoAveria, solucion: $solucion, estado: $estado, fechaCreacion: $fechaCreacion, fechaProvisional: $fechaProvisional, fechaDefinitiva: $fechaDefinitiva, costeMateriales: $costeMateriales, costeEstimadoPropio: $costeEstimadoPropio, costeSubcontrata: $costeSubcontrata, solucionada: $solucionada}';
  }
}

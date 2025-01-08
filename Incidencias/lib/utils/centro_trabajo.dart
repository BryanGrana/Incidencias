enum CentroTrabajo {
  Default(-1),
  LogisticaYDistribucion(1),
  DesarrolloSoftware(2),
  CalidadYSeguridad(3),
  RecursosHumanos(4),
  Marketing(5),
  Ventas(6),
  SoporteTecnico(7);

  final int value;

  const CentroTrabajo(this.value);
}

extension CentroTrabajoExtensions on CentroTrabajo {
  String nombre() {
    switch (this) {
      case CentroTrabajo.LogisticaYDistribucion:
        return "Logística y Distribución";
      case CentroTrabajo.DesarrolloSoftware:
        return "Desarrollo de Software";
      case CentroTrabajo.CalidadYSeguridad:
        return "Calidad y Seguridad";
      case CentroTrabajo.RecursosHumanos:
        return "Recursos Humanos";
      case CentroTrabajo.Marketing:
        return "Marketing";
      case CentroTrabajo.Ventas:
        return "Ventas";
      case CentroTrabajo.SoporteTecnico:
        return "Soporte Técnico";
      default:
        return '';
    }
  }

  String abreviatura() {
    switch (this) {
      case CentroTrabajo.LogisticaYDistribucion:
        return "LD";
      case CentroTrabajo.DesarrolloSoftware:
        return "DS";
      case CentroTrabajo.CalidadYSeguridad:
        return "CS";
      case CentroTrabajo.RecursosHumanos:
        return "RH";
      case CentroTrabajo.Marketing:
        return "MKT";
      case CentroTrabajo.Ventas:
        return "VTS";
      case CentroTrabajo.SoporteTecnico:
        return "ST";
      default:
        return '';
    }
  }

  Empresa empresaAsociada(Empresa empresaActual) {
    if (empresaActual != Empresa.Default || this == CentroTrabajo.Default) {
      return empresaActual;
    }

    switch (this) {
      case CentroTrabajo.LogisticaYDistribucion:
      case CentroTrabajo.DesarrolloSoftware:
      case CentroTrabajo.CalidadYSeguridad:
        return Empresa.LogisticaYDistribucion;
      case CentroTrabajo.RecursosHumanos:
      case CentroTrabajo.Marketing:
        return Empresa.RecursosHumanos;
      case CentroTrabajo.Ventas:
      case CentroTrabajo.SoporteTecnico:
        return Empresa.Ventas;
      default:
        return Empresa.Default;
    }
  }
}

class Empresa {
  static const Empresa Default = Empresa._('Default');
  static const Empresa LogisticaYDistribucion = Empresa._('Logística y Distribución');
  static const Empresa RecursosHumanos = Empresa._('Recursos Humanos');
  static const Empresa Ventas = Empresa._('Ventas');

  final String name;

  const Empresa._(this.name);
}

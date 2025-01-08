import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:incidencias/models/incidencia_mantenimiento.dart';
import 'package:incidencias/models/maquina.dart';
import 'package:incidencias/utils/centro_trabajo.dart';
import 'package:provider/provider.dart';

import '../providers/provider_incidencias_mantenimiento.dart';

class DetailIncidencia extends StatelessWidget {
  const DetailIncidencia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IncidenciaMantenimiento im =
        ModalRoute.of(context)!.settings.arguments as IncidenciaMantenimiento;
    ProviderIncidenciasMantenimiento provider =
        Provider.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          'Incidencia - ${im.id}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _listMaquinas(provider, im),
              _listImagenes(provider, im.id),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listMaquinas(
      ProviderIncidenciasMantenimiento provider, IncidenciaMantenimiento im) {
    return FutureBuilder(
      future: provider.getMaquina(im.idMaquina!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
              child: Text("Compruebe la conexión.",
                  style: TextStyle(color: Colors.red)));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final lista = snapshot.data as List<Maquina>;

        if (lista.isEmpty) {
          return const Center(
              child: Text("No hay máquinas disponibles.",
                  style: TextStyle(color: Colors.white)));
        }

        return Consumer<ProviderIncidenciasMantenimiento>(
          builder: (context, value, child) => Column(
            children: [
              for (var maquina in lista)
                elementoLista(maquina, context, provider, im),
            ],
          ),
        );
      },
    );
  }

  Widget elementoLista(Maquina m, BuildContext context,
      ProviderIncidenciasMantenimiento provider, IncidenciaMantenimiento im) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Máquina: ${m.nombreMaquina ?? "N/A"}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
                'Centro de Trabajo: ${m.centroTrabajo != null ? m.centroTrabajo!.nombre() : "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text('Tipo: ${m.tipo ?? "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text('Fabricante: ${m.fabricante ?? "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text('Descripción: ${m.descripcion ?? "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text('Matrícula: ${m.matricula ?? "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text('Centro de Coste: ${m.centroCoste ?? "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            const Divider(height: 20, color: Colors.grey),
            Text('Incidencia ID: ${im.id ?? "N/A"}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Descripción: ${im.descripcion ?? "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text('Importancia: ${im.importancia ?? "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text(
                'Afecta Seguridad: ${im.afectaSeguridad != null ? (im.afectaSeguridad! ? "Sí" : "No") : "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text(
                'Máquina Parada: ${im.maquinaParada != null ? (im.maquinaParada! ? "Sí" : "No") : "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text(
                'Requiere Repuesto: ${im.requiereRepuesto != null ? (im.requiereRepuesto! ? "Sí" : "No") : "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text('Tipo de Avería: ${im.tipoAveria ?? "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text('Solución: ${im.solucion ?? "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text('Estado: ${im.estado ?? "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text(
                'Fecha de Creación: ${im.fechaCreacion != null ? im.fechaCreacion!.toLocal().toString() : "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text(
                'Coste de Materiales: ${im.costeMateriales?.toString() ?? "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text(
                'Coste Estimado Propio: ${im.costeEstimadoPropio?.toString() ?? "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text(
                'Coste Subcontrata: ${im.costeSubcontrata?.toString() ?? "N/A"}',
                style: const TextStyle(color: Colors.grey)),
            Text(
                'Solucionada: ${im.solucionada != null ? (im.solucionada! ? "Sí" : "No") : "N/A"}',
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _listImagenes(ProviderIncidenciasMantenimiento provider, int? id) {
    return FutureBuilder(
      future: provider.getImages(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
              child: Text("Compruebe la conexión.",
                  style: TextStyle(color: Colors.red)));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Cambiar la lista para que contenga los bytes en lugar de rutas de URL
        final lista = snapshot.data as List<Uint8List>;

        if (lista.isEmpty) {
          return const Center(
              child: Text("No hay imágenes disponibles.",
                  style: TextStyle(color: Colors.white)));
        }

        return Column(
          children: [
            elementoImagen(lista, context),
          ],
        );
      },
    );
  }

  Widget elementoImagen(List<Uint8List> imagenes, BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: imagenes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _showImageDialog(context, imagenes[index]);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRect(
                      child: Image.memory(
                        imagenes[index],
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showImageDialog(BuildContext context, Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Image.memory(
                  imageBytes, // Mostrar la imagen desde bytes
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    child: const Text('   Atrás   '),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

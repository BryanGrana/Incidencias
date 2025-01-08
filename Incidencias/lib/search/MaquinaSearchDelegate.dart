import 'package:flutter/material.dart';
import 'package:incidencias/models/maquina.dart';
import 'package:incidencias/providers/provider_incidencias_mantenimiento.dart';
import 'package:provider/provider.dart';

class MaquinaSearchDelegate extends SearchDelegate {
  String? get searchProject => "Buscar Máquina";
  final int centroTrabajoValue;

  MaquinaSearchDelegate(this.centroTrabajoValue);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = "",
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        FocusScope.of(context).unfocus();

        Future.delayed(const Duration(seconds: 1), () {
          close(context, null);
        });
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(child: buildSuggestions(context));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return _noMaquina();
    ProviderIncidenciasMantenimiento provider =
        Provider.of(context, listen: false);
    return FutureBuilder(
      future: provider.getMaquinasByNameCT(query, centroTrabajoValue),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _maquinaList(snapshot.data!, context, provider);
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Ha ocurrido un error."));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _noMaquina() => Container(
        child: const Center(
          child: Icon(
            Icons.work,
            size: 100,
            color: Colors.black26,
          ),
        ),
      );

  Widget _maquinaList(List<Maquina> list, BuildContext context,
      ProviderIncidenciasMantenimiento provider) {
    if (list.isEmpty) {
      return Center(
          child: Container(
        child: const Text("No se encontraron proyectos."),
      ));
    }
    return ListView.separated(
        itemCount: list.length,
        separatorBuilder: (_, __) => const Divider(
              height: 2,
              thickness: 2,
            ),
        itemBuilder: (context, index) =>
            _elementoLista(list[index], context, provider, index));
  }

  Widget _elementoLista(Maquina m, BuildContext context,
          ProviderIncidenciasMantenimiento provider, int i) =>
      ListTile(
        onTap: () {
          FocusScope.of(context).unfocus();
          Future.delayed(
            const Duration(seconds: 1),
            () {
              Navigator.pushNamed(context, "Project", arguments: m);
            },
          );
        },
        tileColor: Colors.black,
        title: Text("ID ${m.id}"),
        subtitle: Text("Nombre máquina ${m.nombreMaquina ?? "Sin nombre"}"),
      );
}

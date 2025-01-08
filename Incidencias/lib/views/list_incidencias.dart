import 'package:flutter/material.dart';
import 'package:incidencias/models/incidencia_mantenimiento.dart';
import 'package:incidencias/models/maquina.dart';
import 'package:incidencias/providers/provider_incidencias_mantenimiento.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/navigation_widget.dart';

class ListIncidencias extends StatefulWidget {
  const ListIncidencias({super.key});

  @override
  State<ListIncidencias> createState() => _ListIncidenciasState();
}

class _ListIncidenciasState extends State<ListIncidencias> {
  String dni = "";
  final TextEditingController _dniController = TextEditingController();

  Future<void> _loadDni() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDni = prefs.getString('dni_key');
    if (savedDni != null) {
      setState(() {
        dni = savedDni;
        _dniController.text = dni;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDni();
  }

  Future<void> refreshIncidencias(
      ProviderIncidenciasMantenimiento provider) async {
    await provider.refreshIncidencias(dni);
  }

  @override
  Widget build(BuildContext context) {
    ProviderIncidenciasMantenimiento provider =
        Provider.of(context, listen: true);
    return Scaffold(
        drawer: const NavigationWidget(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: const Text(
            'Incidencias',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
            color: Colors.black,
            child: Column(
              children: [listIncidencias(provider)],
            )));
  }

  Widget listIncidencias(ProviderIncidenciasMantenimiento provider) {
    return FutureBuilder(
      future: provider.getIncidencias(dni),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Compruebe la conexión.");
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        //print(snapshot.data);

        final lista = snapshot.data as List<IncidenciaMantenimiento>;

        if (lista.isEmpty) {
          return Center(
            child: Text("Sin incidencias para el DNI: $dni",
                style: const TextStyle(
                  color: Colors.white,
                )),
          );
        }
        MediaQueryData mqd = MediaQuery.of(context);
        return Consumer<ProviderIncidenciasMantenimiento>(
          builder: (context, value, child) => SizedBox(
            height: mqd.size.height * 0.80,
            child: listaElementos(lista, value, context),
          ),
        );
      },
    );
  }

  Widget listaElementos(List<IncidenciaMantenimiento> lista,
      ProviderIncidenciasMantenimiento provider, BuildContext context) {
    ScrollController sc = ScrollController();
    return RefreshIndicator(
      onRefresh: () async {
        refreshIncidencias(provider);
      },
      child: ListView.separated(
        separatorBuilder: (context, index) =>
            const Divider(height: 3, color: Colors.black, thickness: 3),
        controller: sc,
        itemBuilder: (context, index) =>
            elementoLista(lista[index], context, provider, index),
        itemCount: lista.length,
        padding: const EdgeInsets.all(2),
      ),
    );
  }

  Widget elementoLista(IncidenciaMantenimiento im, BuildContext context,
          ProviderIncidenciasMantenimiento provider, int i) =>
      Dismissible(
        key: Key(im.id.toString()),
        direction: im.solucionada!
            ? DismissDirection.none
            : DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) async {
          if (im.solucionada! == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('No se puede eliminar una incidencia solucionada.'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }

          bool eliminado = await provider.deleteIncidencia(im.id);
          if (eliminado) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Incidencia ${im.id} eliminada.'),
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.popAndPushNamed(context, "NewIncidencia");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No se pudo eliminar la incidencia.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: _listTileIncidenciaMantenimiento(im),
      );

  Widget _listTileIncidenciaMantenimiento(IncidenciaMantenimiento im) {
    return Card(
      color: im.solucionada ?? false
          ? Colors.green.withOpacity(0.3)
          : Colors.red.withOpacity(0.3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: InkWell(
        onDoubleTap: () {
          if (im.solucionada == false) {
            Navigator.pushNamed(context, "EditIncidencia", arguments: im);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    "No se puede editar una incidencia que ya está solucionada."),
              ),
            );
          }
        },
        onLongPress: () {
          Navigator.pushNamed(context, "DetailsIncidencia", arguments: im);
        },
        child: ListTile(
          onTap: () {
            if (im.solucionada == false) {
              Navigator.pushNamed(context, "EditIncidencia", arguments: im);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      "No se puede editar una incidencia que ya está solucionada."),
                ),
              );
            }
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID Máquina: ${im.idMaquina}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Afecta Seguridad: ${im.afectaSeguridad ?? false ? "Sí" : "No"}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Tipo Avería: ${im.tipoAveria}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Estado: ${im.estado}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:incidencias/providers/provider_incidencias_mantenimiento.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/maquina.dart';
import '../utils/centro_trabajo.dart';
import '../widgets/navigation_widget.dart';
import '../widgets/qr_reader.dart';

class NewIncidencia extends StatefulWidget {
  const NewIncidencia({super.key});

  @override
  State<NewIncidencia> createState() => _NewIncidenciaState();
}

class _NewIncidenciaState extends State<NewIncidencia> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _maquinaIdController = TextEditingController();
  final TextEditingController _nombreMaquinaController =
      TextEditingController();
  String idMaquina = "";
  String nombreMaquina = "";
  String nombreMaquinaId = "";
  List<Maquina> resultadosBusqueda = [];
  CentroTrabajo _selectedCentro = CentroTrabajo.Default;

  @override
  void dispose() {
    _maquinaIdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadCentroTrabajo();
  }

  Future<void> _loadCentroTrabajo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedCentroValue = prefs.getInt('centro_trabajo_key');
    if (savedCentroValue != null) {
      setState(() {
        _selectedCentro = CentroTrabajo.values.firstWhere(
          (centro) => centro.value == savedCentroValue,
          orElse: () => CentroTrabajo.Default,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Alta incidencia',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildButtonQR(context),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      _maquinaID(),
                      const SizedBox(height: 5),
                      if (nombreMaquinaId.isNotEmpty)
                        Text(
                          'Nombre Máquina: $nombreMaquinaId',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      _nombreMaquinaField(),
                      if (resultadosBusqueda.isNotEmpty) _buildListBusqueda(),
                      const SizedBox(
                        height: 15,
                      ),
                      _buttonAceptar(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _maquinaID() {
    return TextFormField(
      controller: _maquinaIdController,
      keyboardType: TextInputType.number,
      maxLines: 1,
      maxLength: 9,
      onChanged: (value) async {
        setState(() {
          idMaquina = value;
        });

        if (value.isNotEmpty) {
          int? id = int.tryParse(value);
          if (id != null) {
            print(id);
            List<Maquina> maquinas =
                await Provider.of<ProviderIncidenciasMantenimiento>(context,
                        listen: false)
                    .getMaquinaCT(id, _selectedCentro.value);
            if (maquinas.isNotEmpty) {
              setState(() {
                nombreMaquinaId = maquinas[0].nombreMaquina ?? "Sin nombre";
              });
            } else {
              setState(() {
                nombreMaquinaId = "";
              });
            }
          }
        } else {
          setState(() {
            nombreMaquinaId = "";
          });
        }
      },
      validator: (value) {
        return null;
      },
      decoration: InputDecoration(
        hintText: "Ejemplo id: 564",
        labelText: "ID de la máquina a buscar",
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.build),
        filled: true,
        fillColor: Colors.grey[200],
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget _nombreMaquinaField() {
    return TextFormField(
      controller: _nombreMaquinaController,
      maxLines: 1,
      onChanged: (value) async {
        setState(() {
          nombreMaquina = value;
        });

        // Realiza la búsqueda solo si hay al menos 2 caracteres
        if (value.length >= 2) {
          resultadosBusqueda =
              await Provider.of<ProviderIncidenciasMantenimiento>(context,
                      listen: false)
                  .getMaquinasByNameCT(value, _selectedCentro.value);
          setState(() {});
        } else {
          resultadosBusqueda.clear();
        }
      },
      validator: (value) {
        return null;
      },
      decoration: InputDecoration(
        hintText: "Ejemplo nombre: cepi",
        labelText: "Nombre de la máquina",
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        prefixIcon: const Icon(Icons.build),
        filled: true,
        fillColor: Colors.grey[200],
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget _buttonAceptar() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          int? id = int.tryParse(idMaquina);

          if (id != null) {
            List<Maquina> maquinas =
                await Provider.of<ProviderIncidenciasMantenimiento>(context,
                        listen: false)
                    .getMaquinaCT(id, _selectedCentro.value);

            if (maquinas.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Máquina encontrada.'),
                  duration: Duration(seconds: 2),
                ),
              );

              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushNamed(context, "FormIncidencia",
                    arguments: maquinas[0]);
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('La máquina no existe.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Añada un ID o un Nombre.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
      ),
      child: const Text(
        "Alta Incidencia",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildButtonQR(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
      ),
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QrReader()),
        );

        if (result != null) {
          setState(() {
            idMaquina = result;
            _maquinaIdController.text = result;
          });

          int? id = int.tryParse(result);
          if (id != null) {
            List<Maquina> maquinas =
                await Provider.of<ProviderIncidenciasMantenimiento>(context,
                        listen: false)
                    .getMaquinaCT(id, _selectedCentro.value);
            if (maquinas.isNotEmpty) {
              setState(() {
                nombreMaquinaId = maquinas[0].nombreMaquina ?? "Sin nombre";
              });
            } else {
              setState(() {
                nombreMaquinaId = "";
              });
            }
          }
        }
      },
      child: const Text(
        "Escanear QR",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildListBusqueda() {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        constraints: const BoxConstraints(
          maxHeight: 150,
        ),
        child: Card(
          color: Colors.black,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 5,
            ),
            shrinkWrap: true,
            itemCount: resultadosBusqueda.length,
            itemBuilder: (context, index) {
              return ListTile(
                // tileColor: Colors.black,
                // Color de fondo del ListTile
                subtitle: Text(
                  "ID: ${resultadosBusqueda[index].id}",
                  style: const TextStyle(color: Colors.white),
                ),
                title: Text(
                  resultadosBusqueda[index].nombreMaquina ?? "Sin nombre",
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "FormIncidencia",
                      arguments: resultadosBusqueda[index]);
                },
              );
            },
          ),
        ));
  }
}

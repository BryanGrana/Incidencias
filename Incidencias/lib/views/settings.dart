import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importar SharedPreferences
import '../utils/centro_trabajo.dart';
import '../widgets/navigation_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  String dni = "";
  final TextEditingController _dniController = TextEditingController();
  CentroTrabajo _selectedCentro = CentroTrabajo.Default;

  @override
  void initState() {
    super.initState();
    _loadDni();
    _loadCentroTrabajo();
  }

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

  Future<void> _saveDni(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('dni_key', value);
  }

  Future<void> _saveCentroTrabajo(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('centro_trabajo_key', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Ajustes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              _dniConexion(),
              const SizedBox(height: 15),
              _centroTrabajoDropdown(),
              _buttonAceptar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dniConexion() {
    return TextFormField(
      controller: _dniController,
      keyboardType: TextInputType.text,
      maxLines: 1,
      maxLength: 9,
      onChanged: (value) {
        setState(() {
          dni = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El DNI no puede estar vacío.';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "123456789A",
        labelText: "DNI para buscar incidencia",
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.credit_card),
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

  Widget _centroTrabajoDropdown() {
    return DropdownButtonFormField<CentroTrabajo>(
      value: _selectedCentro,
      decoration: InputDecoration(
        labelText: 'Centro de Trabajo',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      items: CentroTrabajo.values.map((CentroTrabajo centro) {
        return DropdownMenuItem<CentroTrabajo>(
          value: centro,
          child: Text(centro == CentroTrabajo.Default
              ? 'Seleccione un centro'
              : centro.nombre()),
        );
      }).toList(),
      onChanged: (CentroTrabajo? newValue) {
        setState(() {
          _selectedCentro = newValue ?? CentroTrabajo.Default;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Debe seleccionar un centro de trabajo';
        }
        return null;
      },
    );
  }

  Widget _buttonAceptar() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _saveDni(dni);
          _saveCentroTrabajo(_selectedCentro.value);
          print(_selectedCentro.value);

          if (_selectedCentro == CentroTrabajo.Default) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Debe seleccionar un centro de trabajo.'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Conexión exitosa.'),
                duration: Duration(seconds: 2),
              ),
            );

            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pushReplacementNamed(context, "Incidencias");
            });
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
        "Conexión",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

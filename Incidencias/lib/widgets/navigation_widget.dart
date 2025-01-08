import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            drawerHeader(context),
            drawerItems(context),
            drawerFooter(context)
          ],
        ),
      ),
    );
  }

  Widget drawerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    );
  }

  Widget drawerItems(BuildContext context) {
    return Column(
      children: [
        drawerElement(Icons.home_outlined, "Inicio", context, "Inicio"),
        drawerElement(
            Icons.report_problem, "Nueva incidencia", context, "NewIncidencia"),
        drawerElement(
            Icons.priority_high, "Incidencias", context, "Incidencias"),
      ],
    );
  }

  bool _requiresDni(String route) {
    return dni.isEmpty && route != 'Inicio';
  }

  Widget drawerElement(
      IconData icon, String text, BuildContext context, String route) {
    return ListTile(
      leading: Icon(
        icon,
        color: _requiresDni(route) ? Colors.red : Colors.white,
      ),
      title: Text(
        text,
        style:
            TextStyle(color: _requiresDni(route) ? Colors.red : Colors.white),
      ),
      onTap: () {
        if ((dni.isEmpty) && route != 'Inicio') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inserte su DNI antes de continuar.')),
          );
          Navigator.pushReplacementNamed(context, "Settings");
        } else {
          Navigator.popAndPushNamed(context, route);
        }
      },
    );
  }

  Widget drawerFooter(BuildContext context) {
    MediaQueryData mqd = MediaQuery.of(context);

    return Column(
      children: [
        SizedBox(
          height: mqd.size.height * 0.5,
        ),
        const Divider(
          color: Colors.black,
          thickness: 1,
        ),
        drawerFooterElement(Icons.settings, "Ajustes", "Settings", context),
        drawerFooterElement(Icons.info_outline, "Ayuda", "Ayuda", context),
        ListTile(
          leading: const Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          title: const Text(
            "Salir",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onTap: () {
            SystemNavigator.pop();
          },
        ),
      ],
    );
  }

  Widget drawerFooterElement(
      IconData icon, String text, String ruta, BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      onTap: () {
        Navigator.popAndPushNamed(context, ruta);
      },
    );
  }
}

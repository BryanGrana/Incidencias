import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider_version.dart';
import '../widgets/navigation_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  String versionId = "Incidencias"; //Llama a una base de datos y comprueba cual es la última versión que hay en esta
  String currentVersion = "1.1.0"; //En caso de que esta versión no coincida con la última en la base de datos, mostrará una ventanita de advertencia.
  String? backendVersion;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkForUpdate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkForUpdate() async {
    ProviderVersion p = Provider.of<ProviderVersion>(context, listen: false);
    backendVersion = await p.fetchVersion(versionId);

    if(backendVersion!.isNotEmpty) {
      if (backendVersion != null && backendVersion != currentVersion) {
        _showUpdateDialog();
      }
    }

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkForUpdate();
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Actualización disponible'),
          content: Text('Hay una nueva versión disponible: $backendVersion'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const NavigationWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Inicio',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

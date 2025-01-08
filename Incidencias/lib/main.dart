import 'package:flutter/material.dart';
import 'package:incidencias/providers/provider_incidencias_mantenimiento.dart';
import 'package:incidencias/providers/provider_version.dart';
import 'package:incidencias/views/detail_incidencia.dart';
import 'package:incidencias/views/edit_incidencia.dart';
import 'package:incidencias/views/form_incidencia.dart';
import 'package:incidencias/views/help.dart';
import 'package:incidencias/views/home.dart';
import 'package:incidencias/views/list_incidencias.dart';
import 'package:incidencias/views/new_incidencia.dart';
import 'package:incidencias/widgets/qr_reader.dart';
import 'package:incidencias/views/settings.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MisProviders());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Incidencias Mantenimiento',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      routes: {
        "Inicio": (context) => const Home(),
        "NewIncidencia": (context) => const NewIncidencia(),
        "Incidencias": (context) => const ListIncidencias(),
        "Ayuda": (context) => const Help(),
        "FormIncidencia": (context) => const FormIncidencia(),
        "QR": (context) => QrReader(),
        "Settings": (context) => const Settings(),
        "DetailsIncidencia": (context) => const DetailIncidencia(),
        "EditIncidencia": (context) => const EditIncidencia(),
      },
      initialRoute: "Inicio",
      debugShowCheckedModeBanner: false,
    );
  }
}

class MisProviders extends StatelessWidget {
  const MisProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProviderIncidenciasMantenimiento(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProviderVersion(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

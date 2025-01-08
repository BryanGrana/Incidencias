import 'dart:io';
import 'package:flutter/material.dart';
import 'package:incidencias/models/incidencia_mantenimiento.dart';
import 'package:incidencias/models/maquina.dart';
import 'package:incidencias/providers/provider_incidencias_mantenimiento.dart';
import 'package:incidencias/utils/centro_trabajo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class FormIncidencia extends StatefulWidget {
  const FormIncidencia({super.key});

  @override
  State<FormIncidencia> createState() => _FormIncidenciaState();
}

class _FormIncidenciaState extends State<FormIncidencia> {
  String dni = "";
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  String _importancia = 'Leve';
  bool _afectaSeguridad = false;
  String _tipoAveria = 'Mecánica';
  String _estado = 'Pendiente';
  bool _solucionada = false;
  bool _maquinaParada = false;

  bool isButtonDisabled = false;

  final _formKey = GlobalKey<FormState>();

  List<String> _imagePaths = []; // Lista para rutas
  List<File> _imageFiles = []; // Lista para archivos de imagen

  @override
  void initState() {
    super.initState();
    _loadDni();
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

  Future<void> _pickImages() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Tomar Foto'),
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _imagePaths.add(image.path); // Añadir ruta
                      _imageFiles.add(File(image.path)); // Añadir archivo
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Seleccionar de Galería'),
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final List<XFile>? images = await _picker.pickMultiImage();
                  if (images != null) {
                    setState(() {
                      _imagePaths.addAll(
                          images.map((image) => image.path)); // Añadir rutas
                      _imageFiles.addAll(images
                          .map((image) => File(image.path))); // Añadir archivos
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Maquina m = ModalRoute.of(context)!.settings.arguments as Maquina;
    ProviderIncidenciasMantenimiento p =
        Provider.of<ProviderIncidenciasMantenimiento>(context);
    IncidenciaMantenimiento im = IncidenciaMantenimiento.vacio();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Crear Incidencia',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Datos máquina ID - ${m.id ?? 0}:',
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
                ), const SizedBox(height: 8),
                _buildDatosMaquina(m, context),
                const SizedBox(height: 16),
                const Text(
                  'Descripción',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                _buildDescripcionField(im, context),
                const SizedBox(height: 16),
                const Text(
                  'Importancia',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                _buildImportanciaDropdown(im),
                const SizedBox(height: 16),
                const Text(
                  'Afecta Seguridad',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                _buildAfectaSeguridadCheckbox(im),
                const SizedBox(height: 16),
                const Text(
                  'Máquina parada',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                _buildMaquinaParadaCheckbox(im),
                const SizedBox(height: 16),
                const Text(
                  'Tipo de Avería',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                _buildTipoAveriaDropdown(im),
                const SizedBox(height: 16),
                const Text(
                  'Estado Incidencia',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                _buildEstadoDropdown(im),
                const SizedBox(height: 16),
                Center(child: _buildImagePicker()),
                const SizedBox(height: 16),
                _buildImageList(),
                const SizedBox(height: 16),
                Center(child: _buildCrearIncidencia(p, m, im, context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatosMaquina(Maquina m, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Centro Trabajo: ${m.centroTrabajo?.nombre() ?? 'No disponible'}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Nombre: ${m.nombreMaquina ?? 'No disponible'}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Descripción: ${m.descripcion ?? 'No disponible'}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Matrícula: ${m.matricula ?? 'No disponible'}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDescripcionField(
      IncidenciaMantenimiento im, BuildContext context) {
    return TextFormField(
      controller: _descripcionController,
      maxLines: 10,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: Colors.black),
      ),
      style: const TextStyle(color: Colors.black),
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'La descripción es obligatoria';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _buildImportanciaDropdown(IncidenciaMantenimiento im) {
    return DropdownButtonFormField<String>(
      value: _importancia,
      onChanged: (String? newValue) {
        setState(() {
          _importancia = newValue!;
        });
      },
      items: <String>['Leve', 'Moderada', 'Importante']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      isExpanded: true,
      hint: const Text('Selecciona la importancia',
          style: TextStyle(color: Colors.black)),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null) {
          return 'Selecciona la importancia';
        }
        return null;
      },
    );
  }

  Widget _buildAfectaSeguridadCheckbox(IncidenciaMantenimiento im) {
    return Row(
      children: [
        Checkbox(
          value: _afectaSeguridad,
          onChanged: (bool? value) {
            setState(() {
              _afectaSeguridad = value!;
            });
          },
        ),
        const Text('Afecta Seguridad', style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget _buildMaquinaParadaCheckbox(IncidenciaMantenimiento im) {
    return Row(
      children: [
        Checkbox(
          value: _maquinaParada,
          onChanged: (bool? value) {
            setState(() {
              _maquinaParada = value!;
            });
          },
        ),
        const Text('Máquina parada', style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget _buildTipoAveriaDropdown(IncidenciaMantenimiento im) {
    return DropdownButtonFormField<String>(
      value: _tipoAveria,
      onChanged: (String? newValue) {
        setState(() {
          _tipoAveria = newValue!;
        });
      },
      items: <String>['Mecánica', 'Eléctrica']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      isExpanded: true,
      hint: const Text('Selecciona el tipo de avería',
          style: TextStyle(color: Colors.black)),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null) {
          return 'Selecciona el tipo de avería';
        }
        return null;
      },
    );
  }

  Widget _buildEstadoDropdown(IncidenciaMantenimiento im) {
    return DropdownButtonFormField<String>(
      value: _estado,
      onChanged: (String? newValue) {
        setState(() {
          _estado = newValue!;
          _solucionada = _estado == 'Solucionada';
        });
      },
      items: <String>[
        'Pendiente',
        'En curso',
        'Reparación provisional',
        'Solucionada'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      isExpanded: true,
      hint: const Text('Selecciona el estado',
          style: TextStyle(color: Colors.black)),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null) {
          return 'Selecciona el estado';
        }
        return null;
      },
    );
  }

  Widget _buildImagePicker() {
    return ElevatedButton(
      onPressed: _pickImages,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      child: const Text('Seleccionar Imágenes'),
    );
  }

  Widget _buildImageList() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: _imagePaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _showImageDialog(context, _imagePaths[index], index);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRect(
                child: Image.file(
                  File(_imagePaths[index]),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imagePath, int index) {
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
                child: Image.file(
                  File(imagePath),
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
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _imagePaths.removeAt(index);
                      });
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Eliminar'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCrearIncidencia(ProviderIncidenciasMantenimiento p, Maquina m,
      IncidenciaMantenimiento im, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      onPressed: isButtonDisabled
          ? () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Espere mientras se procesan las imágenes')),
              )
          : () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isButtonDisabled = true; // Desactiva el botón
                });

                im.dniRegistrador = dni;
                im.idMaquina = m.id;
                im.descripcion = _descripcionController.text;
                im.importancia = _importancia;
                im.afectaSeguridad = _afectaSeguridad;
                im.maquinaParada = _maquinaParada;
                im.tipoAveria = _tipoAveria;
                im.estado = _estado;
                im.solucionada = _solucionada;

                bool insertado =
                    await p.insertIncidenciaMantenimiento(im, _imageFiles);

                if (insertado) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Incidencia creada exitosamente.')),
                  );
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushReplacementNamed(context, "Incidencias");
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Error al crear la incidencia.')),
                  );
                  isButtonDisabled = false;
                }

                Future.delayed(const Duration(seconds: 25), () {
                  setState(() {
                    isButtonDisabled = false;
                  });
                });
              }
            },
      child: const Text('Añadir Incidencia'),
    );
  }
}

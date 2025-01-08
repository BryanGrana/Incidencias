import 'dart:io';
import 'dart:typed_data'; // Importación para manejar los bytes de imágenes
import 'package:flutter/material.dart';
import 'package:incidencias/models/image_data.dart';
import 'package:incidencias/utils/centro_trabajo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:incidencias/models/incidencia_mantenimiento.dart';
import 'package:incidencias/providers/provider_incidencias_mantenimiento.dart';

import '../models/maquina.dart';

class EditIncidencia extends StatefulWidget {
  const EditIncidencia({super.key});

  @override
  _EditIncidenciaState createState() => _EditIncidenciaState();
}

class _EditIncidenciaState extends State<EditIncidencia> {
  final TextEditingController _descripcionController = TextEditingController();
  String _importancia = 'Leve';
  bool _afectaSeguridad = false;
  String _tipoAveria = 'Mecánica';
  String _estado = 'Pendiente';
  bool _solucionada = false;
  bool _maquinaParada = false;

  final _formKey = GlobalKey<FormState>();
  List<File> _imageFiles = [];

  @override
  void initState() {
    super.initState();
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
                      _imageFiles.add(File(image.path));
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
                      _imageFiles
                          .addAll(images.map((image) => File(image.path)));
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
    ProviderIncidenciasMantenimiento provider =
        Provider.of<ProviderIncidenciasMantenimiento>(context, listen: true);
    IncidenciaMantenimiento im =
        ModalRoute.of(context)!.settings.arguments as IncidenciaMantenimiento;

    _descripcionController.text = im.descripcion!;
    _importancia = im.importancia!;
    _afectaSeguridad = im.afectaSeguridad!;
    _tipoAveria = im.tipoAveria!;
    _estado = im.estado!;
    _solucionada = im.solucionada!;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          'Editar Incidencia - ${im.id}',
          style: const TextStyle(
            color: Colors.white,
          ),
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
                  'Datos máquina ID - ${im.idMaquina ?? 0}:',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
                const SizedBox(height: 8),
                _buildDatosMaquina(im.idMaquina, context, provider),
                const SizedBox(height: 16),
                const Text(
                  'Descripción',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                _buildDescripcionField(im),
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
                  'Máquina Parada',
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
                _buildImageList(provider, im.id),
                const SizedBox(height: 16),
                Center(
                    child: _buildGuardarCambiosButton(provider, im, context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildDatosMaquina(int? idMaquina, BuildContext context,
      ProviderIncidenciasMantenimiento provider) {
    return FutureBuilder(
      future: provider.getMaquina(idMaquina ?? 0),
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
                elementoLista(maquina, context, provider),
            ],
          ),
        );
      },
    );
  }

  elementoLista(Maquina m, BuildContext context,
      ProviderIncidenciasMantenimiento provider) {
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
          'Nombre: ${m.nombreMaquina == null || m.nombreMaquina!.isEmpty ? 'No disponible' : m.nombreMaquina}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Descripción: ${m.descripcion == null || m.descripcion!.isEmpty ? 'No disponible' : m.descripcion}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Matrícula: ${m.matricula == null || m.matricula!.isEmpty ? 'No disponible' : m.matricula}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDescripcionField(IncidenciaMantenimiento im) {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          im.descripcion = value;
          _descripcionController.text = im.descripcion!;
        });
      },
      initialValue: im.descripcion,
      // controller: _descripcionController,
      maxLines: 10,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: Colors.black),
      ),
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'La descripción es obligatoria';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildImportanciaDropdown(IncidenciaMantenimiento im) {
    return DropdownButtonFormField<String>(
      value: im.importancia,
      onChanged: (String? newValue) {
        setState(() {
          im.importancia = newValue!;
          _importancia = im.importancia!;
        });
      },
      items: <String>['Leve', 'Moderada', 'Importante']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
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
          value: im.afectaSeguridad,
          onChanged: (bool? value) {
            setState(() {
              im.afectaSeguridad = !im.afectaSeguridad!;
              _afectaSeguridad = im.afectaSeguridad!;
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
          value: im.maquinaParada,
          onChanged: (bool? value) {
            setState(() {
              im.maquinaParada = !im.maquinaParada!;
              _maquinaParada = im.maquinaParada!;
            });
          },
        ),
        const Text('Máquina parada', style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget _buildTipoAveriaDropdown(IncidenciaMantenimiento im) {
    return DropdownButtonFormField<String>(
      value: im.tipoAveria,
      onChanged: (String? newValue) {
        setState(() {
          im.tipoAveria = newValue!;
          _tipoAveria = im.tipoAveria!;
        });
      },
      items: <String>['Mecánica', 'Eléctrica']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
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
      value: im.estado,
      onChanged: (String? newValue) {
        setState(() {
          im.estado = newValue!;
          im.solucionada = im.estado == 'Solucionada';
          _estado = im.estado!;
          _solucionada = im.solucionada!;
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

  Widget _buildImageList(ProviderIncidenciasMantenimiento provider, int? id) {
    return _listImagenes(provider, id);
  }

  Widget _listImagenes(ProviderIncidenciasMantenimiento provider, int? id) {
    return FutureBuilder(
      future: provider.getImagesId(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Compruebe la conexión.",
                style: TextStyle(color: Colors.red)),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final lista = snapshot.data as List<ImageData>;

        final combinedImages = <ImageData>[];

        combinedImages.addAll(lista);

        combinedImages.addAll(_imageFiles.map((file) {
          final bytes = file.readAsBytesSync();
          return ImageData(
              id: 0, imagen: Uint8List.fromList(bytes), path: file.path);
        }));

        if (combinedImages.isEmpty) {
          return const Center(
            child: Text("No hay imágenes disponibles.",
                style: TextStyle(color: Colors.white)),
          );
        }

        return Column(
          children: [
            elementoImagen(combinedImages, provider, id, context),
          ],
        );
      },
    );
  }

  Widget elementoImagen(
      List<ImageData> imagenes,
      ProviderIncidenciasMantenimiento provider,
      int? id,
      BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: imagenes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _showImageDialog(context, imagenes[index], provider,
                  imagenes[index].id, index);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRect(
                      child: Image.memory(
                        imagenes[index].imagen,
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

  void _showImageDialog(BuildContext context, ImageData image,
      ProviderIncidenciasMantenimiento provider, int? id, int index) {
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
                  image.imagen,
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
                    child: const Text('Atrás'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (image.id != 0) {
                        bool success = await provider.deleteImage(id);
                        if (success) {
                          Navigator.of(context).pop();
                          setState(() {});
                        }
                      } else {
                        setState(() {
                          _imageFiles
                              .removeWhere((file) => file.path == image.path);
                        });
                      }
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

  Widget _buildGuardarCambiosButton(ProviderIncidenciasMantenimiento provider,
      IncidenciaMantenimiento im, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          im.descripcion = _descripcionController.text;
          im.importancia = _importancia;
          im.afectaSeguridad = _afectaSeguridad;
          im.maquinaParada = _maquinaParada;
          im.tipoAveria = _tipoAveria;
          im.estado = _estado;
          im.solucionada = _solucionada;

          bool success = await provider.editarIncidencia(im, _imageFiles);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Incidencia actualizada exitosamente.')),
            );
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context);
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ha ocurrido un error inesperado.')),
            );
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context);
            });
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      child: const Text('Guardar Cambios'),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:incidencias/models/incidencia_mantenimiento.dart';
import 'package:incidencias/models/incidencia_mantenimiento_response.dart';
import 'package:incidencias/models/maquina_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/image_data.dart';
import '../models/maquina.dart';

class ProviderIncidenciasMantenimiento with ChangeNotifier {
  final String _Token =
      "toke";

  String get _Intranet2BackendUrl {
    return kDebugMode
        ? "ip_debug"
        : "ip_noDebug";
  }

  //Recoger la maquina con el id buscado
  List<Maquina> maquinas = [];

  Future<List<Maquina>> getMaquinaCT(int id, int ct) async {
    maquinas = [];
    try {
      var response;

      if (kDebugMode) {
        //Si está en debug va por http
        var client = http.Client();
        var url = Uri.http(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/Maquinas/$id/$ct",
        );
        print(url);
        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      } else {
        //
        var client = http.Client();
        var url = Uri.https(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/Maquinas/$id/$ct",
        );
        print("Estás en el https $url");
        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      }

      if (response.statusCode == 200) {
        final maquinaResponse = MaquinaResponse.fromRawJson(response.body);

        maquinas.addAll(maquinaResponse.maquinas);

        if (kDebugMode) {
          print("Datos: ${response.body}");
        }

        return maquinas;
      } else {
        if (kDebugMode) {
          print("Datos else: ${response.body}");
        }

        return maquinas;
      }
    } catch (e) {
      print(e);
    }
    return maquinas;
  }

  Future<List<Maquina>> getMaquina(int id) async {
    maquinas = [];
    try {
      var response;

      if (kDebugMode) {
        //Si está en debug va por http
        var client = http.Client();
        var url = Uri.http(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/Maquinas/$id",
        );
        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      } else {
        //
        var client = http.Client();
        var url = Uri.https(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/Maquinas/$id",
        );
        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      }

      if (response.statusCode == 200) {
        final maquinaResponse = MaquinaResponse.fromRawJson(response.body);

        maquinas.addAll(maquinaResponse.maquinas);

        if (kDebugMode) {
          print("Datos: ${response.body}");
        }

        return maquinas;
      } else {
        if (kDebugMode) {
          print("Datos else: ${response.body}");
        }

        return maquinas;
      }
    } catch (e) {
      print(e);
    }
    return maquinas;
  }

  Future<List<Maquina>> getMaquinasByNameCT(
      String nombreMaquina, int ct) async {
    List<Maquina> maquinas = [];
    try {
      var response;
      var client = http.Client();

      if (kDebugMode) {
        // Si está en modo debug, usar http
        var url = Uri.http(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/Maquinas/Nombre/$nombreMaquina/$ct",
        );
        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      } else {
        // En producción usar http
        var url = Uri.https(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/Maquinas/Nombre/$nombreMaquina/$ct",
        );
        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      }

      if (response.statusCode == 200) {
        final maquinaResponse = MaquinaResponse.fromRawJson(response.body);

        maquinas.addAll(maquinaResponse.maquinas);

        if (kDebugMode) {
          // Print opcional en modo debug
          // print("Datos: ${response.body}");
        }

        return maquinas;
      } else {
        print("Error: ${response.statusCode}");
        return maquinas;
      }
    } catch (e) {
      print("Error: $e");
    }
    return maquinas;
  }

  Future<List<Maquina>> getMaquinasByName(String nombreMaquina) async {
    List<Maquina> maquinas = [];
    try {
      var response;
      var client = http.Client();

      if (kDebugMode) {
        // Si está en modo debug, usar http
        var url = Uri.http(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/Maquinas/Nombre/$nombreMaquina",
        );
        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      } else {
        // En producción usar http
        var url = Uri.https(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/Maquinas/Nombre/$nombreMaquina",
        );
        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      }

      if (response.statusCode == 200) {
        final maquinaResponse = MaquinaResponse.fromRawJson(response.body);

        maquinas.addAll(maquinaResponse.maquinas);

        if (kDebugMode) {
          // Print opcional en modo debug
          // print("Datos: ${response.body}");
        }

        return maquinas;
      } else {
        print("Error: ${response.statusCode}");
        return maquinas;
      }
    } catch (e) {
      print("Error: $e");
    }
    return maquinas;
  }

  List<IncidenciaMantenimiento> incidencias = [];

  Future<List<IncidenciaMantenimiento>> getIncidencias(String dni) async {
    incidencias = [];
    try {
      var response;

      if (kDebugMode) {
        //Si está en debug va por http
        var client = http.Client();
        var url = Uri.http(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/IncidenciasMantenimiento/$dni",
        );

        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      } else {
        //

        var client = http.Client();
        var url = Uri.https(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/IncidenciasMantenimiento/$dni",
        );
        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      }

      if (response.statusCode == 200) {
        final incidenciaMantenimientoResponse =
            IncidenciaMantenimientoResponse.fromRawJson(response.body);

        for (IncidenciaMantenimiento inc
            in incidenciaMantenimientoResponse.incidencias) {
          if (!inc.borrada!) {
            incidencias.add(inc);
          }
        }

        if (kDebugMode) {
          //  print("Datos: ${response.body}");
        }
        return incidencias;
      } else {
        return incidencias;
      }
    } catch (e) {
      print("AAAAAAAAAAAAA $e");
    }
    return incidencias;
  }

  Future<List<IncidenciaMantenimiento>> refreshIncidencias(String dni) async {
    incidencias = [];
    try {
      var response;

      if (kDebugMode) {
        //Si está en debug va por http
        var client = http.Client();
        var url = Uri.http(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/IncidenciasMantenimiento/$dni",
        );

        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      } else {
        //
        var client = http.Client();
        var url = Uri.https(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/IncidenciasMantenimiento/$dni",
        );
        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      }

      if (response.statusCode == 200) {
        final incidenciaMantenimientoResponse =
            IncidenciaMantenimientoResponse.fromRawJson(response.body);

        incidencias.addAll(incidenciaMantenimientoResponse.incidencias);

        notifyListeners();

        if (kDebugMode) {
          //  print("Datos: ${response.body}");
        }
        return incidencias;
      } else {
        return incidencias;
      }
    } catch (e) {
      print(e);
    }
    return incidencias;
  }

  Future<bool> insertIncidenciaMantenimiento(
      IncidenciaMantenimiento im, List<File> imageFiles) async {
    try {
      // print(" ${jsonEncode(im.toJson())} AAAAAAAAAAAAAAAAAA");

      var body = jsonEncode(im.toJson());
      var response;
      if (kDebugMode) {
        //Si está en debug va por http
        var client = http.Client();
        var url = Uri.http(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento",
        );
        response = await client.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "X-API-KEY": _Token,
          },
          body: body,
        );
      } else {
        //
        var client = http.Client();
        var url = Uri.https(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento",
        );

        response = await client.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "X-API-KEY": _Token,
          },
          body: body,
        );
      }

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        int? id = jsonResponse;

        if (imageFiles.isEmpty) {
          return true;
        } else {
          return await _uploadAdjuntos(id!, imageFiles);
        }
      } else {
        //  print("Error en la inserción: ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print("Excepción al insertar incidencia: $e");
    }
    return false;
  }

  Future<bool> _uploadAdjuntos(int id, List<File> imageFiles) async {
    try {
      var response;
      if (kDebugMode) {
        var uri = Uri.https(
            _Intranet2BackendUrl, "/api/IncidenciasMantenimiento/$id/Adjuntos");
        var request = http.MultipartRequest('POST', uri);

        request.files.addAll(await Future.wait(imageFiles.map((file) async {
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();
          return http.MultipartFile('UploadFiles', stream, length,
              filename: file.path.split('/').last);
        })));
        request.headers["X-API-KEY"] = _Token;
        response = await request.send();
      } else {
        var uri = Uri.https(
            _Intranet2BackendUrl, "/api/IncidenciasMantenimiento/$id/Adjuntos");
        var request = http.MultipartRequest('POST', uri);

        request.files.addAll(await Future.wait(imageFiles.map((file) async {
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();
          return http.MultipartFile('UploadFiles', stream, length,
              filename: file.path.split('/').last);
        })));
        request.headers["X-API-KEY"] = _Token;
        response = await request.send();
      }

      if (response.statusCode == 200) {
        // print("Archivos subidos correctamente.");
        notifyListeners();
        return true;
      } else {
        //  print("Error al subir archivos: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Excepción al subir archivos: $e");
      return false;
    }
  }

  Future<bool> deleteIncidencia(int? id) async {
    try {
      var response;

      if (kDebugMode) {
        // Si está en modo debug, usamos http
        var client = http.Client();
        var url = Uri.http(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/$id",
        );

        response = await client.delete(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      } else {
        // En producción utilizamos http
        var client = http.Client();
        var url = Uri.https(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/$id",
        );

        response = await client.delete(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      }

      if (response.statusCode == 200) {
        removeIncidencia(id);
        return true;
      } else {
        if (kDebugMode) {
          // print(
          //     "Error al eliminar la incidencia. Código de estado: ${response.statusCode}");
        }
        return false;
      }
    } catch (e) {
      print("Excepción al eliminar la incidencia: $e");
      return false;
    }
  }

  void removeIncidencia(int? id) {
    incidencias.removeWhere((incidencia) => incidencia.id == id);
    notifyListeners();
  }

  //List<String> rutas = [];

  List<Uint8List> imageDataList = [];

  Future<List<Uint8List>> getImages(int? id) async {
    imageDataList = [];
    try {
      var response;
      if (kDebugMode) {
        // Si está en modo debug, usamos http
        var client = http.Client();
        var url = Uri.http(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/Adjuntos/$id",
        );
        // print(url);
        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      } else {
        // En producción utilizamos http
        var client = http.Client();
        var url = Uri.https(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/Adjuntos/$id",
        );

        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      }

      if (response.statusCode == 200) {
        List<dynamic> imagesJson = json.decode(response.body);

        imageDataList = imagesJson
            .map((imageBase64) => base64Decode(imageBase64 as String))
            .toList();

        return imageDataList;
      } else {
        // print(response.body);
        return [];
      }
    } catch (e) {
      debugPrint("$e AAAAAAAAAAAAAA");
      return throw "Error $e";
    }
  }

  List<ImageData> imageDataListId = [];

  Future<List<ImageData>> getImagesId(int? id) async {
    imageDataListId = [];
    try {
      var response;
      if (kDebugMode) {
        // Si está en modo debug, usamos http
        var client = http.Client();
        var url = Uri.http(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/AdjuntosId/$id",
        );
        //print(url);
        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      } else {
        // En producción utilizamos http
        var client = http.Client();
        var url = Uri.https(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/AdjuntosId/$id",
        );

        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      }

      if (response.statusCode == 200) {
        List<dynamic> imagesJson = json.decode(response.body);

        imageDataListId = imagesJson.map<ImageData>((imageData) {
          int id = imageData['id'];
          String imageBase64 = imageData['imagen'];

          return ImageData(
            id: id,
            imagen: base64Decode(imageBase64),
          );
        }).toList();
        //print(imageDataListId[0]);
        return imageDataListId;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("$e AAAAAAAAAAAAAA");
      throw "Error $e";
    }
  }

  void removeAdjunto(int? id) {
    imageDataListId.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  Future<bool> editarIncidencia(
      IncidenciaMantenimiento im, List<File> imageFiles) async {
    try {
      var body = jsonEncode(im.toJson());
      var response;
      if (kDebugMode) {
        var client = http.Client();
        var url = Uri.http(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/Actualizar",
        );
        response = await client.put(
          url,
          headers: {
            "Content-Type": "application/json",
            "X-API-KEY": _Token,
          },
          body: body,
        );
      } else {
        var client = http.Client();
        var url = Uri.https(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/Actualizar",
        );
        response = await client.put(
          url,
          headers: {
            "Content-Type": "application/json",
            "X-API-KEY": _Token,
          },
          body: body,
        );
      }

      if (response.statusCode == 200) {
        if (imageFiles.isEmpty) {
          return true;
        } else {
          return await _uploadAdjuntos(im.id!, imageFiles);
        }
      } else {
        return false;
      }
    } catch (e) {
      print("Excepción al actualizar incidencia: $e");
    }
    return false;
  }

  Future<bool> deleteImage(int? id) async {
    try {
      var response;
      if (kDebugMode) {
        // Si está en modo debug, usamos http
        var client = http.Client();
        var url = Uri.http(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/AdjuntoBorrado/$id",
        );
        //print(url);
        response = await client.put(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      } else {
        // En producción utilizamos http
        var client = http.Client();
        var url = Uri.https(
          _Intranet2BackendUrl,
          "/api/IncidenciasMantenimiento/AdjuntoBorrado/$id",
        );

        response = await client.put(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      }

      if (response.statusCode == 200) {
        removeAdjunto(id);
        return true;
      } else {
        // print(response.body);
        return false;
      }
    } catch (e) {
      //debugPrint("$e AAAAAAAAAAAAAA");
      throw "Error $e";
    }
  }
}

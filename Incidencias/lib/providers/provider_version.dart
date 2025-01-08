import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProviderVersion with ChangeNotifier {
  String _backendVersion = "";

  final String _Token =
      "token";

  String get _Intranet2BackendUrl {
    return kDebugMode ? "ip_debug" : "ip_NoDebug";
  }

  Future<String> fetchVersion(String appId) async {
    try {
      var response;

      if (kDebugMode) {
        var client = http.Client();
        var url = Uri.http(
          _Intranet2BackendUrl,
          "api/Version/Android",
          {'AppId': appId},
        );

        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      } else {
        var client = http.Client();
        var url = Uri.https(
          _Intranet2BackendUrl,
          "api/Version/Android",
          {'AppId': appId},
        );

        response = await client.get(
          url,
          headers: {
            "X-API-KEY": _Token,
          },
        );
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print(response.body);
        _backendVersion = data['Version'];
        // print(_backendVersion);
        return _backendVersion;
      } else {
        throw Exception(
            "Error al obtener la versión del backend: ${response.statusCode}");
        return _backendVersion;
      }
    } catch (error) {
      print("Error: $error");
      _backendVersion = "";
    }
    notifyListeners();
    return _backendVersion;
  }
}

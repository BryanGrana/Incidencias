import 'dart:typed_data';

class ImageData {
  final int id;
  final Uint8List imagen;
  final String? path;

  ImageData({
    required this.id,
    required this.imagen,
    this.path,
  });
}

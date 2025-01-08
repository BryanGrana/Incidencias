import 'package:flutter/material.dart';
import 'image_dialog.dart';

class HelpPage extends StatelessWidget {
  final String imagePath;
  final String description;

  const HelpPage({Key? key, required this.imagePath, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            flex: 7, // Ocupa el 70% del espacio
            child: GestureDetector(
              onTap: () {
                ImageDialog.show(context, imagePath);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[800]!, // Color gris oscuro
                    width: 2.0, // Ancho del borde
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Esquinas redondeadas
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), // Esquinas redondeadas para la imagen
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover, // Ajusta la imagen para cubrir el espacio
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            flex: 3, // Ocupa el 30% del espacio
            child: SingleChildScrollView(
              child: Text(
                description,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

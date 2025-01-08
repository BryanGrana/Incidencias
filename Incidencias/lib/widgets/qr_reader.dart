import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrReader extends StatelessWidget {
  QrReader({Key? key}) : super(key: key);

  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: (BarcodeCapture capture) async {
        final List<Barcode> barcodes = capture.barcodes;
        final barcode = barcodes.first;

        if (barcode.rawValue != null) {
          var code = barcode.rawValue;

          int? barCode = int.tryParse(code!);
          print("Code: $code AAAAAAAAAAAAAAAAAAAAAAAA");
          await controller
              .stop()
              .then((value) => Navigator.of(context).pop(code))
              .then((value) => controller.dispose());
        }
      },
    );
  }
}

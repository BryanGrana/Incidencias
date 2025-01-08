import 'package:flutter/material.dart';
import '../widgets/help_page.dart';
import '../widgets/navigation_widget.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Ayuda',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: PageView(
          children: const [
            HelpPage(
              imagePath: 'assets/images/inicio.jpg',
              description:
                  'Cuando la aplicación se inicie la verás así, tendrás que darle a la esquina superior izquierda para que se abra el menú.',
            ),
            HelpPage(
              imagePath: 'assets/images/no_dni.jpg',
              description:
                  'Verás las zonas de "Nueva incidencia" e "Incidencias" en rojo, ya que no has añadido un DNI. Al pulsar en alguna de ellas te llevará a los ajustes a que añadáis el DNI.',
            ),
            HelpPage(
              imagePath: 'assets/images/settings.jpg',
              description:
                  'Una vez aquí, tendrás que poner el DNI correspondiente para poder visualizar y añadir incidencias y seleccionar el Centro de Trabajo al que pertenezcas. Una vez ajustados los ajustes, podrás pulsar el botón que te llevará a la ventana del listado de incidencias, mostrándote las incidencias correspondientes en caso de haber dado de alta alguna. ',
            ),
            HelpPage(
              imagePath: 'assets/images/editar_finalizada.jpg',
              description:
                  'En el listado de incidencias, no se pueden ni borrar ni editar las que están solucionadas (en verde), pero sí que se podrán editar y eliminar las que no han sido solucionadas (en rojo) en caso de haber cometido algún error.',
            ),
            HelpPage(
              imagePath: 'assets/images/eliminar.jpg',
              description:
                  'Para eliminar una incidencia, deslizarás de derecha a izquierda sobre la misma incidencia, en donde te saldrá una especie de botón rojo, no te preocupes y desliza hasta el final. Si se ha borrado o no, mostrará un mensaje.',
            ),
            HelpPage(
              imagePath: 'assets/images/editar.jpg',
              description:
                  'Para editar una incidencia solo tienes que pulsar en la incidencia correspondiente o pulsarla dos veces y te llevará a la edición de la misma.',
            ),
            HelpPage(
              imagePath: 'assets/images/detalles.jpg',
              description:
                  'Si mantienes pulsada la incidencia, irás al detalle de la misma, donde verás todos sus datos. Si te fijas, abajo hay un círculo, eso son las imágenes que están cargando. Para ir para atrás solo tienes que darle a la flecha de la esquina superior izquierda (se comparte entre pantallas que tengan la flecha).',
            ),
            HelpPage(
              imagePath: 'assets/images/imagen.jpg',
              description:
                  'Si vas a abajo de todo, verás las imágenes, deslizando de derecha a izquierda irás cambiando entre las mismas (si hay más de una).',
            ),
            HelpPage(
              imagePath: 'assets/images/imagen_grande.jpg',
              description:
                  'Si pulsas en una imagen, se abrirá en una ventana más grande y así podrás verla con mejor detalle.',
            ),
            HelpPage(
              imagePath: 'assets/images/nombre_maquina.jpg',
              description:
                  'En la zona de "Nueva incidencia" en el menú desplegable podremos añadir nuevas incidencias. Podemos escanear un código QR que añadirá la máquina automáticamente (en caso de existir) o podemos buscarla por código o por nombre. Si la máquina existe, podrás ver el nombre de dicha máquina justo debajo de donde añades el código',
            ),
            HelpPage(
              imagePath: 'assets/images/nueva_busqueda.jpg',
              description:
                  'Si la buscas por nombre en la zona justo de debajo saldrá una lista deslizable (de arriba hacia abajo) con las coincidencias encontradas. (Hay que añadir un mínimo de 2 letras)',
            ),
            HelpPage(
              imagePath: 'assets/images/form.jpg',
              description:
                  'Una vez escaneado el qr, añadido el id o bien buscado por nombre, llegaremos al formulario, en el cual tendrás que rellenar los campos disponisbles y seleccionar lo que creas conveniente.',
            ),
            HelpPage(
              imagePath: 'assets/images/add_imagenes.jpg',
              description:
                  'Abajo de todo encontrarás un botón con el texto "Seleccionar imágenes" y al pulsar ahí te dejará elegir 2 sitios, hacer una foto o seleccionarla de la galería.',
            ),
            HelpPage(
              imagePath: 'assets/images/full_imagen.jpg',
              description:
                  'Una vez seleccionadas la o las fotos, podremos pulsar en una y veremos algo parecido a esto, la foto en grande para poder verla con mejor detalle. Si vemos que no nos sirve la foto, podemos pulsar el eliminar o bien podemos pulsar fuera de la foto o en el botón atrás para cerrar la vista en pantalla ampliada.',
            ),
          ],
        ),
      ),
    );
  }
}

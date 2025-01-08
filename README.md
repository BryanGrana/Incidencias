# Aplicación de Incidencias

## Descripción
Esta aplicación permite a los usuarios gestionar incidencias mediante la lectura de códigos QR, la búsqueda de máquinas en una base de datos externa a través de una API, y la visualización de incidencias activas asociadas al DNI del usuario. Además, incluye un menú de ayuda para facilitar el uso de la aplicación.

## Funcionalidades:
- **Escaneo de QR**: Escanea un código QR para obtener el código de una máquina.
- **Búsqueda de Máquinas**: Consulta la base de datos externa a través de una API para buscar la máquina asociada al código leído.
- **Creación de Incidencias**: Una vez encontrada la máquina, el usuario puede proceder a la creación de una nueva incidencia.
- **Visualización de Incidencias**: Permite ver las incidencias activas que están asociadas al DNI del usuario, consultando la API.
- **Menú de Ayuda**: Proporciona documentación y asistencia a los usuarios sobre cómo usar la aplicación.

## Estructura del Proyecto

  ```Markdown
  incidencias/
  ├── lib/
  │   ├── widgets/
  │   │   ├── **Widgets principales** (Aquí estarán todos los widgets utilizados en la aplicación)
  ├── pubspec.yaml
  ```
`pubspec.yaml`
Este archivo contiene las dependencias necesarias para el proyecto.
`lib/`
Aquí se encuentran los widgets y componentes principales de la aplicación, como formularios, listas de incidencias y menús.

## Requisitos previos:

- Tener Flutter instalado en tu máquina.
- Tener acceso a una API REST que provea los datos de las máquinas y las incidencias.
- Una cámara para el escaneo de QR.

## Instalación

- Clona este repositorio.
- Abre el proyecto con tu IDE preferido (Usado Android Studio).
- Ejecuta `flutter pub get` para instalar las dependencias.

## Uso

- `Escaneo QR`: Escanea el código QR utilizando la cámara del dispositivo para obtener el código de la máquina.
- `Buscar Máquina`: Consulta la API para buscar la máquina asociada al código leído.
- `Crear Incidencia`: Si la máquina existe, puedes proceder a la creación de una nueva incidencia utilizando los datos de la API.
- `Ver Incidencias Activas`: Accede a las incidencias activas asociadas a tu DNI, consultando la API.
- `Menú de Ayuda`: Accede al menú de ayuda desde el drawer para obtener soporte y documentación adicional.

##Notas Adicionales
- Esta aplicación utiliza la librería `http` para realizar las peticiones a la API externa.
- El sistema de navegación está basado en `Flutter`, facilitando una experiencia de usuario fluida e intuitiva.
- Utiliza `qr_code_scanner` para la funcionalidad de escaneo de QR.

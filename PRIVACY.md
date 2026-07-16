# Política de Privacidad de VeganCheck

**Última actualización:** 15 de julio de 2026

VeganCheck (paquete `com.ralvarezmar.veganchecker`) es una aplicación iOS que
escanea códigos de barras y consulta información pública de productos para
mostrar ingredientes, aditivos, alérgenos, información nutricional y un
análisis orientativo sobre su idoneidad para una alimentación vegana. El
desarrollador no opera ningún servidor backend para la aplicación.

## Resumen

VeganCheck no recopila datos personales para el desarrollador y no necesita una
cuenta, inicio de sesión ni credenciales. Actualmente no incorpora analítica,
informes de fallos, publicidad ni rastreadores de terceros.

## Datos almacenados en el dispositivo

La aplicación almacena exclusivamente en tu dispositivo:

- Historial local de escaneos: código de barras, nombre, marca, URL de imagen y
  fecha de consulta.
- Favoritos: código de barras, nombre, marca, URL de imagen y fecha en que se
  guardaron.
- Caché local de productos consultados, incluida la fuente y la fecha de caché,
  para facilitar consultas posteriores sin conexión. La caché está limitada y
  se gestiona automáticamente.
- Preferencias locales, como alérgenos seleccionados, modo estricto y el
  indicador de que se ha visto la introducción.
- Listas de vigilancia configuradas por el usuario, como códigos de aditivos y
  palabras clave de ingredientes.

Estos datos no se envían al desarrollador. Puedes borrar el historial,
eliminar favoritos y borrar la caché desde la aplicación. Al desinstalar la
aplicación, el sistema elimina sus datos locales.

## Cámara y códigos de barras

VeganCheck solicita permiso para usar la cámara para leer códigos de barras y,
opcionalmente, capturar una imagen de la lista de ingredientes para reconocer
su texto. El escaneo y el reconocimiento OCR se realizan localmente en el
dispositivo mediante AVFoundation y Vision. Las imágenes usadas para OCR se
procesan únicamente en memoria: no se suben ni se guardan de forma persistente,
y la imagen de OCR no se envía como parte de una contribución.

## Consultas a bases de datos de terceros

Al escanear o buscar un producto, la aplicación puede conectarse a estas bases
de datos públicas de la familia Open Food Facts:

- Open Food Facts
- Open Beauty Facts
- Open Product Facts
- Open Pet Food Facts

La aplicación envía el código de barras o los términos de búsqueda necesarios
para localizar el producto. Las imágenes de productos pueden cargarse desde
los servidores o CDN indicados por esas bases de datos. No se envían nombres,
correos electrónicos ni otros identificadores personales del usuario.

Estas consultas se rigen por los términos y la política de privacidad de los
servicios correspondientes. Consulta especialmente la política de privacidad
de Open Food Facts:
<https://world.openfoodfacts.org/privacy>

## Contribuciones anónimas

Cuando el usuario decide contribuir activamente, puede elegir una de las cuatro
bases de datos y enviar una contribución anónima. La contribución incluye el
código de barras y únicamente los campos de producto que haya rellenado, como
nombre, marca, cantidad, categorías, ingredientes y etiquetas. Si añade fotos
del producto, esas fotos también se envían a la base seleccionada para añadir o
sustituir imágenes del producto. No se envían `user_id`, contraseñas,
credenciales, nombres, correos electrónicos ni otros identificadores personales.

Las contribuciones solo se envían cuando el usuario las inicia explícitamente.
Pueden quedar disponibles públicamente según los términos, la política de
privacidad y la licencia de datos de la base seleccionada. No incluyas
información personal en los campos de texto ni en las fotografías que envíes.

## Analítica, fallos, publicidad y rastreo

La versión actual de VeganCheck no incluye:

- Analítica de uso.
- Informes de fallos o servicios de crash reporting.
- Publicidad ni SDK de redes publicitarias.
- Rastreadores de terceros.

## Conservación y seguridad

Los datos locales se conservan en el dispositivo hasta que los borres desde la
aplicación, elimines un favorito, se sustituya o elimine la caché, o
desinstales VeganCheck. Las contribuciones enviadas a una base pública pueden
conservarse allí según sus propias reglas y no pueden gestionarse desde
VeganCheck. Las consultas a las bases de datos quedan sujetas a sus propias
políticas y periodos de conservación.

El aislamiento de aplicaciones de iOS protege el almacenamiento local frente a
otras aplicaciones. VeganCheck no guarda credenciales ni transmite datos al
desarrollador. Ningún sistema de almacenamiento o transmisión puede garantizar
seguridad absoluta; mantén actualizado iOS y descarga la aplicación de fuentes
fiables.

## Menores

VeganCheck no está dirigida específicamente a menores y no recopila
conscientemente datos personales de menores. No se necesita una cuenta para
utilizarla.

## Derechos y cómo ejercerlos

Puedes controlar los datos locales borrando el historial, eliminando favoritos o
desinstalando VeganCheck. Para ejercer derechos sobre los datos tratados por
una base de datos de terceros, debes dirigirte a esa base conforme a su propia
política de privacidad. El desarrollador no opera un backend ni dispone de una
cuenta de usuario desde la que pueda identificar o administrar tus datos
locales.

## Cambios en esta política

Podemos actualizar esta política si cambian las funciones de VeganCheck o los
servicios que utiliza. Publicaremos la versión revisada en esta página y
actualizaremos la fecha indicada al principio.

## Contacto

Para cualquier duda sobre esta política, contacta con el desarrollador en:
**r.alvarezmar@gmail.com**.

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

Estos datos no se envían al desarrollador. Puedes borrar el historial y
eliminar favoritos desde la aplicación. La caché local se elimina al
desinstalar VeganCheck. Al desinstalar la aplicación, el sistema elimina sus
datos locales.

## Cámara y códigos de barras

VeganCheck solicita permiso para usar la cámara únicamente para leer códigos de
barras. El análisis se realiza localmente en el dispositivo mediante
AVFoundation. Los fotogramas de cámara se procesan en memoria: no se toman,
guardan ni envían fotografías o vídeos a ningún servidor.

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

## Analítica, fallos, publicidad y rastreo

La versión actual de VeganCheck no incluye:

- Analítica de uso.
- Informes de fallos o servicios de crash reporting.
- Publicidad ni SDK de redes publicitarias.
- Rastreadores de terceros.

## Conservación y seguridad

Los datos locales se conservan en el dispositivo hasta que los borres desde la
aplicación, elimines un favorito, se sustituya o elimine la caché, o
desinstales VeganCheck. Las consultas a las bases de datos quedan sujetas a
sus propias políticas y periodos de conservación.

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

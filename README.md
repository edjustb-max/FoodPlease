# FoodPlease

### Plataforma Web + Mobile para gestión y seguimiento de pedidos gastronómicos

**Django · Flutter · SQLite · API HTTP/JSON · ngrok · Android**

FoodPlease es un **Producto Mínimo Viable (MVP)** académico que integra una plataforma web de administración para locales gastronómicos con una aplicación móvil desarrollada en Flutter para Android.

El proyecto permite validar un flujo completo de compra y gestión de pedidos: el cliente consulta productos y genera un pedido desde la aplicación móvil; Django registra la información y actualiza el stock; el local administra el pedido desde la plataforma web; y Flutter consulta posteriormente el backend para reflejar los cambios de estado.

---

## Tabla de contenidos

- [Descripción](#descripción)
- [Arquitectura](#arquitectura)
- [Componentes del proyecto](#componentes-del-proyecto)
- [Funcionalidades principales](#funcionalidades-principales)
- [Reglas de negocio](#reglas-de-negocio)
- [Endpoints principales](#endpoints-principales)
- [Tecnologías utilizadas](#tecnologías-utilizadas)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Requisitos previos](#requisitos-previos)
- [Instalación del backend Django](#instalación-del-backend-django)
- [Ejecución de Flutter en Android](#ejecución-de-flutter-en-android)
- [Uso mediante ngrok](#uso-mediante-ngrok)
- [Generación del APK Android](#generación-del-apk-android)
- [Instalación y prueba en un dispositivo Android real](#instalación-y-prueba-en-un-dispositivo-android-real)
- [Pruebas realizadas](#pruebas-realizadas)
- [Base de datos](#base-de-datos)
- [Seguridad y configuración](#seguridad-y-configuración)
- [Solución de problemas](#solución-de-problemas)
- [Alcance del MVP](#alcance-del-mvp)
- [Proyección técnica](#proyección-técnica)
- [Repositorio](#repositorio)
- [Contexto académico](#contexto-académico)

---

## Descripción

FoodPlease fue desarrollado para apoyar el flujo básico de compra y gestión de pedidos en un contexto gastronómico.

El sistema está compuesto por dos aplicaciones integradas:

- **Backend Web en Django:** administra productos, stock, pedidos y estados.
- **Aplicación Mobile en Flutter:** permite al cliente consultar productos, gestionar un carrito, crear pedidos y revisar su seguimiento.

La comunicación entre ambas partes se realiza mediante una **API HTTP desarrollada en Django**, utilizando **SQLite** como base de datos central del MVP.

---

## Arquitectura

FoodPlease utiliza una arquitectura Web/Mobile integrada en la que Django concentra la lógica del sistema y el acceso a los datos.

```text
Cliente
   │
   ▼
Flutter Android
   │
   │ HTTP / JSON
   ▼
API Django
   │
   ├──────────────► Lógica de negocio
   │
   ▼
Django ORM
   │
   ▼
SQLite
   ▲
   │
Django Web
   ▲
   │
Local gastronómico
```

La aplicación móvil consulta productos y crea pedidos mediante la API. La plataforma web utiliza el mismo backend para gestionar productos, stock y pedidos.

Cuando el local modifica el estado de un pedido desde Django, Flutter consulta periódicamente el backend y refleja la actualización en la pantalla de seguimiento.

---

## Componentes del proyecto

| Componente | Tecnología | Función principal |
|---|---|---|
| Backend Web | Django | Administración de productos, stock y pedidos |
| API | Django | Comunicación entre backend y aplicación móvil |
| Aplicación Mobile | Flutter | Flujo de compra y seguimiento del pedido |
| Base de datos | SQLite | Persistencia central del MVP |
| Exposición pública | ngrok | Acceso HTTPS para demostración y pruebas externas |
| Control de versiones | Git / GitHub | Versionado y publicación del proyecto |
| Distribución Android | APK | Instalación y prueba en dispositivo Android real |

---

## Funcionalidades principales

### Backend Web

| Función | Descripción |
|---|---|
| Registrar productos | Permite ingresar código, nombre, descripción, categoría, precio y stock |
| Listar productos | Muestra los productos registrados |
| Editar productos | Permite modificar información comercial y stock |
| Proteger el código | El código del producto permanece bloqueado durante la edición |
| Eliminar productos | Solicita confirmación antes de eliminar |
| Validar códigos | Evita códigos duplicados |
| Validar precios | Exige un precio mínimo de $500 |
| Validar stock | No admite valores negativos |
| Controlar disponibilidad | Actualiza la disponibilidad según el stock |
| Gestionar pedidos | Permite revisar pedidos creados desde Flutter |
| Actualizar estado | Permite modificar el estado del pedido desde la web |

### Aplicación Mobile

| Función | Descripción |
|---|---|
| Pantalla de acceso | Punto de entrada al flujo móvil |
| Visualización de locales | Presenta los locales del prototipo |
| Consulta de productos | Obtiene el catálogo directamente desde Django |
| Detalle de producto | Muestra la información del producto seleccionado |
| Carrito de compras | Permite agregar productos y modificar cantidades |
| Pago y entrega | Registra dirección, método de pago y cupón |
| Creación de pedidos | Envía el pedido al backend mediante la API |
| Seguimiento | Consulta periódicamente el estado real del pedido |
| Detalle del pedido | Presenta productos, dirección, pago y totales |
| Navegación inferior | Permite acceder a Inicio, Pedidos y Carrito |

---

## Reglas de negocio

### Productos

- El código del producto debe ser único.
- El código no puede modificarse después del registro.
- El nombre debe contener al menos tres caracteres.
- El precio mínimo permitido es de **$500**.
- El stock debe ser igual o mayor que cero.
- Un producto con stock mayor que cero aparece como **Disponible**.
- Un producto con stock igual a cero aparece como **No disponible**.
- La eliminación requiere confirmación previa.

### Pedidos

- El backend valida los productos enviados desde Flutter.
- Los precios utilizados en el pedido se obtienen directamente desde Django.
- El stock se descuenta al confirmar correctamente el pedido.
- La creación del pedido protege la consistencia entre el registro del pedido y la actualización del stock.
- Los estados disponibles son:
  - Pedido confirmado
  - En preparación
  - En camino
  - Entregado
- El cupón `FOOD10` aplica un **10 % de descuento**.
- El costo de despacho definido para el MVP es de **$2.990**.

---

## Endpoints principales

### Obtener productos

```http
GET /api/productos/
```

Entrega el catálogo utilizado por la aplicación móvil.

### Crear pedido

```http
POST /api/pedidos/
```

Registra un pedido, calcula sus totales y actualiza el stock correspondiente.

### Consultar pedido

```http
GET /api/pedidos/<id>/
```

Retorna la información del pedido, incluyendo estado, dirección, método de pago, totales e ítems.

---

## Tecnologías utilizadas

| Tecnología | Uso |
|---|---|
| Python | Lenguaje del backend |
| Django 5.2 | Framework web y API |
| SQLite | Base de datos del MVP |
| HTML | Estructura de vistas web |
| Bootstrap | Interfaz web |
| Dart | Lenguaje de la aplicación móvil |
| Flutter | Desarrollo de la aplicación Android |
| HTTP / JSON | Comunicación entre Flutter y Django |
| Android Emulator | Pruebas durante el desarrollo |
| Android APK | Instalación y validación en dispositivo real |
| ngrok | Exposición HTTPS del backend para demostración |
| Git | Control de versiones |
| GitHub | Repositorio del proyecto |

---

## Estructura del repositorio

```text
FoodPlease/
│
├── foodplease-crud/
│   ├── config/
│   ├── menu/
│   │   ├── migrations/
│   │   ├── templates/
│   │   ├── templatetags/
│   │   ├── forms.py
│   │   ├── models.py
│   │   ├── urls.py
│   │   └── views.py
│   ├── manage.py
│   └── requirements.txt
│
├── foodplease_mobile/
│   ├── android/
│   ├── assets/
│   ├── lib/
│   │   ├── models/
│   │   ├── screens/
│   │   ├── services/
│   │   ├── widgets/
│   │   └── main.dart
│   └── pubspec.yaml
│
├── .gitignore
└── README.md
```

---

## Requisitos previos

### Backend

- Python 3.10 o superior.
- PowerShell, CMD o terminal equivalente.
- Conexión a Internet para instalar dependencias.

Comprobar Python:

```powershell
py --version
```

### Mobile Android

- Flutter SDK instalado.
- Android SDK configurado.
- Emulador Android o dispositivo Android real.
- Conexión a Internet para consumir el backend mediante ngrok.

Comprobar Flutter:

```powershell
flutter doctor
```

---

## Instalación del backend Django

### 1. Entrar al proyecto

```powershell
cd ruta\hasta\FoodPlease\foodplease-crud
```

### 2. Crear entorno virtual

```powershell
py -m venv .venv
```

### 3. Activar el entorno virtual

```powershell
.\.venv\Scripts\Activate.ps1
```

### 4. Instalar dependencias

```powershell
python -m pip install -r requirements.txt
```

### 5. Crear o actualizar la base de datos

```powershell
python manage.py migrate
```

### 6. Verificar la configuración

```powershell
python manage.py check
```

Resultado esperado:

```text
System check identified no issues (0 silenced).
```

### 7. Iniciar Django

```powershell
python manage.py runserver
```

Acceso local:

```text
http://127.0.0.1:8000/
```

API de productos:

```text
http://127.0.0.1:8000/api/productos/
```

---

## Ejecución de Flutter en Android

### 1. Entrar al proyecto móvil

```powershell
cd ruta\hasta\FoodPlease\foodplease_mobile
```

### 2. Instalar dependencias

```powershell
flutter pub get
```

### 3. Comprobar dispositivos

```powershell
flutter devices
```

### 4. Ejecutar en un emulador Android

```powershell
flutter run -d emulator-5554
```

Para desarrollo local con el emulador, la aplicación utiliza por defecto:

```text
http://10.0.2.2:8000
```

---

## Uso mediante ngrok

ngrok permite exponer el backend Django mediante una URL pública HTTPS y realizar pruebas desde dispositivos externos.

### 1. Mantener Django ejecutándose

```powershell
python manage.py runserver
```

### 2. Abrir otra terminal y ejecutar ngrok

```powershell
ngrok http 8000
```

ngrok entregará una dirección similar a:

```text
https://ejemplo.ngrok-free.dev
```

### 3. Verificar la API pública

Abrir:

```text
https://ejemplo.ngrok-free.dev/api/productos/
```

Si el catálogo se visualiza correctamente, el backend está accesible mediante Internet.

### 4. Ejecutar Flutter usando la URL pública

```powershell
flutter run -d emulator-5554 --dart-define=API_BASE_URL=https://ejemplo.ngrok-free.dev
```

La URL del backend no queda escrita directamente en el código fuente. `ApiService` permite establecerla mediante:

```text
API_BASE_URL
```

> La URL de ngrok debe mantenerse activa mientras se utilice la aplicación contra ese backend.

---

## Generación del APK Android

FoodPlease puede compilarse como una aplicación Android instalable.

El prototipo fue compilado correctamente en modo **release** y posteriormente instalado y probado en un dispositivo Android real.

### 1. Mantener disponible el backend

Si el APK se probará mediante Internet, Django y ngrok deben estar ejecutándose.

```powershell
python manage.py runserver
```

En otra terminal:

```powershell
ngrok http 8000
```

### 2. Obtener la URL HTTPS de ngrok

Ejemplo:

```text
https://ejemplo.ngrok-free.dev
```

### 3. Entrar al proyecto Flutter

```powershell
cd ruta\hasta\FoodPlease\foodplease_mobile
```

### 4. Obtener dependencias

```powershell
flutter pub get
```

### 5. Compilar el APK

```powershell
flutter build apk --release --dart-define=API_BASE_URL=https://ejemplo.ngrok-free.dev
```

Al finalizar, Flutter genera:

```text
build\app\outputs\flutter-apk\app-release.apk
```

El comando de compilación fue validado correctamente durante el cierre del MVP.

---

## Instalación y prueba en un dispositivo Android real

El archivo:

```text
app-release.apk
```

puede copiarse a un teléfono Android e instalarse manualmente.

Dependiendo de la versión de Android, puede ser necesario autorizar temporalmente la instalación de aplicaciones desde la fuente utilizada para abrir el APK.

### Flujo validado en dispositivo real

El APK fue instalado y probado correctamente en un teléfono Android real, verificando:

- apertura de la aplicación;
- consulta del catálogo desde Django;
- navegación por productos;
- carrito de compras;
- ingreso de dirección y método de pago;
- uso del cupón `FOOD10`;
- creación de pedidos;
- registro del pedido en Django;
- actualización del stock;
- gestión del estado desde la plataforma web;
- actualización del seguimiento en el dispositivo móvil.

La comunicación utilizada en esta prueba fue:

```text
Dispositivo Android real
        │
        │ Internet / HTTPS
        ▼
       ngrok
        │
        ▼
      Django
        │
        ▼
      SQLite
```

Esto valida que el prototipo móvil puede ejecutarse fuera del emulador y comunicarse con el backend mediante una dirección pública HTTPS.

---

## Pruebas realizadas

### Backend

- Registro de productos válidos.
- Edición de nombre, precio y stock.
- Bloqueo del código durante la edición.
- Rechazo de códigos duplicados.
- Rechazo de precios inferiores a $500.
- Rechazo de stock negativo.
- Cambio automático de disponibilidad según stock.
- Eliminación con confirmación.
- Visualización de pedidos creados desde Flutter.
- Cambio del estado de un pedido desde la plataforma web.

### Integración Web/Mobile

- Consulta de productos desde Flutter.
- Creación de pedidos desde la aplicación móvil.
- Registro del pedido en Django.
- Descuento de stock.
- Consulta del pedido por ID.
- Visualización del estado actual en Flutter.
- Cambio de estado desde la administración web.
- Actualización posterior del estado en la pantalla móvil.
- Funcionamiento mediante URL pública HTTPS de ngrok.

### Android

- Ejecución en emulador Android.
- Compilación del proyecto en APK release.
- Instalación del APK en dispositivo Android real.
- Ejecución del flujo Web/Mobile desde dispositivo físico.

### Análisis Flutter

```powershell
flutter analyze
```

El análisis final no presentó errores. Los mensajes restantes correspondieron únicamente a avisos informativos asociados a métodos de Flutter marcados como `deprecated`, sin afectar la compilación ni el funcionamiento del prototipo.

---

## Base de datos

El proyecto utiliza **SQLite** como base de datos del MVP.

El archivo:

```text
db.sqlite3
```

está excluido del repositorio mediante `.gitignore`.

Después de clonar el proyecto, ejecutar:

```powershell
python manage.py migrate
```

Si no se cargan datos iniciales, la base comenzará vacía y los productos podrán registrarse desde la plataforma web.

---

## Seguridad y configuración

El repositorio excluye mediante `.gitignore` elementos que no deben versionarse, entre ellos:

- entornos virtuales;
- archivos `.env`;
- base de datos SQLite;
- archivos de compilación de Flutter;
- `.dart_tool`;
- archivos comprimidos;
- configuraciones locales;
- archivos generados automáticamente por herramientas del IDE.

La URL utilizada por Flutter para comunicarse con el backend puede definirse mediante:

```text
API_BASE_URL
```

Ejemplo durante la ejecución:

```powershell
flutter run -d emulator-5554 --dart-define=API_BASE_URL=https://ejemplo.ngrok-free.dev
```

Ejemplo al generar el APK:

```powershell
flutter build apk --release --dart-define=API_BASE_URL=https://ejemplo.ngrok-free.dev
```

Esto permite cambiar el backend utilizado sin modificar el código fuente de la aplicación.

---

## Solución de problemas

### Django no inicia

```powershell
python manage.py check
python manage.py migrate
python manage.py runserver
```

### Faltan dependencias de Django

```powershell
python -m pip install -r requirements.txt
```

### Flutter no reconoce paquetes

```powershell
flutter pub get
```

### No aparece el emulador

```powershell
flutter devices
```

Para listar los AVD disponibles en Windows:

```powershell
& "$env:LOCALAPPDATA\Android\Sdk\emulator\emulator.exe" -list-avds
```

Ejemplo para iniciar un AVD llamado `Pixel_7`:

```powershell
Start-Process "$env:LOCALAPPDATA\Android\Sdk\emulator\emulator.exe" -ArgumentList "-avd Pixel_7"
```

### Flutter no obtiene productos mediante ngrok

1. Confirmar que Django esté ejecutándose.
2. Confirmar que ngrok esté apuntando al puerto `8000`.
3. Abrir en el navegador:

```text
https://TU_URL_NGROK/api/productos/
```

4. Ejecutar Flutter utilizando exactamente la misma URL:

```powershell
flutter run -d emulator-5554 --dart-define=API_BASE_URL=https://TU_URL_NGROK
```

### El APK abre pero no obtiene datos

Comprobar que:

- Django siga ejecutándose.
- ngrok siga activo.
- la URL usada al compilar el APK siga siendo válida.
- el dispositivo tenga conexión a Internet.

Si cambia la URL pública de ngrok, debe generarse un nuevo APK utilizando la nueva dirección.

---

## Alcance del MVP

El MVP implementado incluye:

- gestión web de productos;
- gestión de stock;
- API de productos;
- API de pedidos;
- aplicación Flutter para Android;
- carrito de compras;
- dirección de entrega;
- selección de método de pago;
- cupón de descuento;
- creación de pedidos;
- gestión web de estados;
- seguimiento desde Flutter;
- consulta del detalle del pedido;
- acceso público mediante ngrok para pruebas;
- compilación en formato APK;
- validación en un dispositivo Android real.

---

## Proyección técnica

La arquitectura actual permite ampliar progresivamente el producto con nuevas funcionalidades, entre ellas:

- personalización de productos por local;
- autenticación y roles;
- historial persistente de pedidos;
- funcionalidades adicionales para repartidores;
- notificaciones;
- geolocalización;
- pruebas automatizadas;
- infraestructura para escenarios de mayor escala.

Estas mejoras pueden incorporarse de manera incremental sobre la base Web/Mobile ya validada.

---

## Repositorio

Repositorio público del proyecto:

**https://github.com/edjustb-max/FoodPlease**

### APK

Para mantener el repositorio liviano, se recomienda **no versionar el APK dentro del código fuente**.

La distribución del archivo compilado puede realizarse mediante **GitHub Releases**, adjuntando por ejemplo:

```text
FoodPlease-Android-v1.0.apk
```

De esta forma:

- el repositorio mantiene el código fuente;
- Git conserva un historial limpio;
- el APK queda disponible como artefacto separado del código;
- cada versión puede asociarse a una etiqueta, por ejemplo `v1.0.0`.

---

## Contexto académico

Proyecto desarrollado para la asignatura **Taller de Desarrollo Web y Móvil**.

FoodPlease corresponde a un **Producto Mínimo Viable (MVP)** orientado a demostrar la integración entre un sistema web de administración y una aplicación móvil desarrollada en Flutter para Android.

---

## Estado final del MVP

La versión actual fue validada mediante:

- backend Django funcional;
- API HTTP/JSON operativa;
- aplicación Flutter ejecutada en Android;
- acceso público mediante ngrok;
- creación y gestión de pedidos;
- sincronización de estados Web/Mobile;
- compilación exitosa en APK release;
- instalación y funcionamiento en un dispositivo Android real;
- publicación del código fuente en GitHub.

**FoodPlease cuenta con un flujo Web/Mobile integrado, ejecutable y verificable.**

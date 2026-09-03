<div align="center">

# FoodPlease

### Plataforma Web + Mobile para gestión y seguimiento de pedidos gastronómicos

**Django · Flutter · SQLite · API HTTP · ngrok**

FoodPlease es un MVP académico que integra una aplicación web de administración para locales gastronómicos con una aplicación móvil orientada al cliente.

</div>

---

## Descripción

FoodPlease es una solución tecnológica Web/Mobile desarrollada para apoyar el flujo básico de compra y gestión de pedidos en un contexto gastronómico.

El proyecto está compuesto por dos aplicaciones integradas:

- **Backend Web en Django:** administra productos, stock y pedidos.
- **Aplicación Mobile en Flutter:** permite explorar productos, crear pedidos y consultar su estado.

La comunicación entre ambas partes se realiza mediante una **API HTTP desarrollada en Django**, utilizando SQLite como base de datos del prototipo.

---

## Componentes del proyecto

| Componente | Tecnología | Función principal |
|---|---|---|
| Backend Web | Django | Administración de productos, stock y pedidos |
| API | Django | Comunicación entre backend y aplicación móvil |
| Aplicación Mobile | Flutter | Flujo de compra y seguimiento del pedido |
| Base de datos | SQLite | Persistencia local del MVP |
| Exposición pública | ngrok | Túnel HTTPS para demostración y pruebas externas |

---

## Funcionalidades principales

### Backend Web

| Función | Descripción |
|---|---|
| Registrar productos | Permite ingresar código, nombre, descripción, categoría, precio y stock. |
| Listar productos | Muestra los productos registrados en el sistema. |
| Editar productos | Permite modificar información comercial y stock. |
| Proteger el código | El código del producto permanece bloqueado durante la edición. |
| Eliminar productos | Solicita confirmación antes de eliminar un registro. |
| Validar códigos | Evita códigos duplicados. |
| Validar precios | Exige un precio mínimo de $500. |
| Validar stock | No admite valores negativos. |
| Controlar disponibilidad | Actualiza automáticamente la disponibilidad según el stock. |
| Gestionar pedidos | Permite revisar los pedidos generados desde Flutter. |
| Actualizar estado | Permite cambiar el estado del pedido desde la aplicación web. |

### Aplicación Mobile

| Función | Descripción |
|---|---|
| Inicio de sesión prototipo | Pantalla inicial de acceso al flujo móvil. |
| Visualización de locales | Presenta locales gastronómicos disponibles en el prototipo. |
| Consulta de productos | Obtiene el catálogo directamente desde la API de Django. |
| Detalle de producto | Muestra información del producto seleccionado. |
| Carrito de compras | Permite agregar productos y administrar cantidades. |
| Pago y entrega | Registra dirección, método de pago y cupón. |
| Creación de pedidos | Envía el pedido al backend mediante la API. |
| Seguimiento | Consulta periódicamente el estado real del pedido. |
| Detalle del pedido | Presenta productos, dirección, pago y totales asociados. |
| Navegación inferior | Permite acceder a Inicio, Pedidos y Carrito. |

---

## Reglas de negocio principales

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

- El backend valida los productos enviados por la aplicación móvil.
- El precio utilizado para calcular el pedido corresponde al valor registrado en Django.
- El stock se descuenta al confirmar correctamente el pedido.
- La creación del pedido se realiza dentro de una operación atómica.
- El sistema contempla los estados:
  - Pedido confirmado
  - En preparación
  - En camino
  - Entregado
- El cupón `FOOD10` aplica un **10 % de descuento**.
- El costo de despacho utilizado en el MVP es de **$2.990**.

---

## Tecnologías utilizadas

| Tecnología | Uso |
|---|---|
| Python | Lenguaje del backend |
| Django 5.2 | Framework web y API |
| SQLite | Base de datos del prototipo |
| HTML | Estructura de vistas web |
| Bootstrap | Diseño de la interfaz web |
| Dart | Lenguaje de la aplicación móvil |
| Flutter | Framework híbrido Android/iOS |
| HTTP | Comunicación entre Flutter y Django |
| Android Emulator | Pruebas de la aplicación móvil |
| ngrok | Exposición HTTPS temporal del backend |
| Git | Control de versiones |
| GitHub | Repositorio del proyecto |

---

## Estructura general

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

## Arquitectura

FoodPlease utiliza una arquitectura integrada Web/Mobile.

```text
Flutter
   ↓ HTTP / JSON
API Django
   ↓
SQLite
   ↓
Administración Web
   ↓
Actualización del estado
   ↓
Flutter
```

La aplicación móvil crea pedidos y consulta información a través de la API.

Cuando el estado de un pedido se modifica desde la administración web, Flutter vuelve a consultar periódicamente el backend y refleja el nuevo estado en la pantalla de seguimiento.

---

## Endpoints principales

### Obtener productos

```http
GET /api/productos/
```

### Crear pedido

```http
POST /api/pedidos/
```

### Consultar pedido

```http
GET /api/pedidos/<id>/
```

---

## Requisitos previos

### Backend

- Python 3.10 o superior.
- PowerShell, CMD o terminal equivalente.
- Conexión a internet para instalar dependencias.

```powershell
py --version
```

### Mobile

- Flutter SDK instalado.
- Android Studio o un emulador Android configurado.
- Dispositivo o emulador disponible.

```powershell
flutter doctor
```

---

## Instalación del backend en Windows

### 1. Entrar al proyecto

```powershell
cd ruta\hasta\FoodPlease\foodplease-crud
```

### 2. Crear entorno virtual

```powershell
py -m venv .venv
```

### 3. Instalar dependencias

```powershell
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

### 4. Crear o actualizar la base de datos

```powershell
.\.venv\Scripts\python.exe manage.py migrate
```

### 5. Verificar configuración

```powershell
.\.venv\Scripts\python.exe manage.py check
```

Resultado esperado:

```text
System check identified no issues (0 silenced).
```

### 6. Iniciar Django

```powershell
.\.venv\Scripts\python.exe manage.py runserver
```

Abrir:

```text
http://127.0.0.1:8000/
```

---

## Ejecución de Flutter

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

### 4. Ejecutar la aplicación

```powershell
flutter run -d emulator-5554
```

Por defecto, la aplicación utiliza:

```text
http://10.0.2.2:8000
```

---

## Uso con ngrok

### 1. Mantener Django ejecutándose

```powershell
.\.venv\Scripts\python.exe manage.py runserver
```

### 2. Abrir otra terminal

```powershell
ngrok http 8000
```

ngrok entregará una dirección similar a:

```text
https://ejemplo.ngrok-free.dev
```

### 3. Ejecutar Flutter con esa URL

```powershell
flutter run -d emulator-5554 --dart-define=API_BASE_URL=https://ejemplo.ngrok-free.dev
```

La URL no queda escrita directamente en el código fuente, ya que `ApiService` permite definirla mediante `API_BASE_URL`.

> ngrok se utiliza en este proyecto como mecanismo de exposición pública temporal para pruebas y demostración. No corresponde a un despliegue permanente de producción.

---

## Base de datos

El proyecto utiliza SQLite.

El archivo `db.sqlite3` está excluido del repositorio mediante `.gitignore`.

Después de clonar el proyecto:

```powershell
.\.venv\Scripts\python.exe manage.py migrate
```

Si no se cargan datos iniciales, la base comienza vacía y los productos pueden registrarse desde la interfaz web.

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
- Cambio manual del estado de un pedido.

### Integración Web/Mobile

- Consulta de productos desde Flutter.
- Creación de pedidos desde la aplicación móvil.
- Registro del pedido en Django.
- Descuento de stock.
- Consulta del pedido por ID.
- Visualización del estado actual en Flutter.
- Cambio de estado desde la administración web.
- Actualización posterior del estado en la pantalla móvil.
- Funcionamiento del flujo mediante una URL pública de ngrok.

### Análisis Flutter

```powershell
flutter analyze
```

El proyecto no presenta errores de análisis. Permanecen únicamente avisos informativos relacionados con APIs de Flutter marcadas como `deprecated`, sin impedir la compilación ni el funcionamiento actual del MVP.

---

## Flujo principal del MVP

```text
Inicio
  ↓
Locales
  ↓
Menú
  ↓
Detalle del producto
  ↓
Carrito
  ↓
Pago y entrega
  ↓
Creación del pedido
  ↓
Seguimiento
  ↓
Detalle del pedido
```

---

## Alcance actual

El MVP incluye:

- Gestión web de productos.
- Gestión de stock.
- API de productos.
- API de pedidos.
- Carrito móvil.
- Dirección de entrega.
- Selección de método de pago.
- Creación de pedidos.
- Gestión web del estado.
- Seguimiento desde Flutter.
- Consulta del detalle del pedido.
- Exposición temporal mediante ngrok.

---

## Limitaciones actuales

- Los locales mostrados en Flutter forman parte de la representación visual del prototipo.
- El catálogo todavía no está separado por local.
- No existe autenticación persistente de clientes.
- El último pedido se conserva únicamente durante la sesión de la aplicación.
- El perfil de usuario todavía no está implementado funcionalmente.
- No existe asignación automática de repartidores.
- No utiliza geolocalización en tiempo real.
- El seguimiento se realiza mediante consultas periódicas al backend.
- SQLite se utiliza únicamente como base de datos del MVP.
- ngrok proporciona exposición temporal y no alojamiento permanente.

---

## Mejoras futuras

- Incorporar una entidad **Local** en Django.
- Asociar cada producto al local correspondiente.
- Implementar autenticación y registro de clientes.
- Implementar historial persistente de pedidos.
- Incorporar perfiles de repartidores.
- Agregar notificaciones push.
- Incorporar geolocalización y mapa de seguimiento.
- Migrar desde SQLite a una base de datos de producción.
- Implementar pruebas automatizadas.
- Realizar un despliegue Cloud permanente del backend.

---

## Solución de problemas

### Django rechaza la conexión

```powershell
.\.venv\Scripts\python.exe manage.py runserver
```

### Faltan dependencias de Django

```powershell
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

### Existen migraciones pendientes

```powershell
.\.venv\Scripts\python.exe manage.py migrate
```

### Flutter no reconoce paquetes

```powershell
flutter pub get
```

### No aparece el emulador

```powershell
flutter devices
```

---

## Seguridad y configuración

El repositorio excluye mediante `.gitignore`:

- Entornos virtuales.
- Archivos `.env`.
- Base de datos SQLite.
- Archivos de compilación de Flutter.
- `.dart_tool`.
- Archivos comprimidos.
- Configuración local de Android.
- Archivos generados automáticamente por herramientas del IDE.

La URL del backend móvil puede definirse en tiempo de ejecución mediante:

```text
API_BASE_URL
```

Esto evita mantener una URL temporal de ngrok fija dentro del código fuente.

---

## Contexto académico

Proyecto desarrollado para la asignatura **Taller de Desarrollo Web y Móvil**.

FoodPlease corresponde a un **Producto Mínimo Viable (MVP)** orientado a demostrar la integración entre un sistema web de administración y una aplicación móvil híbrida.

---

## Autoría

Proyecto académico desarrollado como parte del proceso formativo de la asignatura **Taller de Desarrollo Web y Móvil**.

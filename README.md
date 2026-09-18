# 🏥 SaludApp - Aplicación Móvil

Aplicación móvil para la **gestión de citas médicas**, desarrollada con **Flutter** y **Dart**.

La aplicación consume el backend de **SaludApp**, desarrollado con **Dart, Shelf y PostgreSQL**, permitiendo gestionar usuarios, autenticación y citas médicas desde una interfaz móvil y multiplataforma.

---

## 📋 Descripción

**SaludApp** permite a los usuarios gestionar sus citas médicas de manera sencilla desde una aplicación móvil.

Entre sus principales funcionalidades se encuentran:

* 👤 Registro de nuevos usuarios.
* 🔐 Inicio de sesión mediante autenticación **JWT**.
* 📅 Agendamiento de citas médicas.
* 📋 Consulta del historial de citas.
* 👤 Gestión del perfil personal.
* 📷 Selección y actualización de fotografía de perfil.
* 🔔 Notificaciones locales para recordar citas.
* 🏥 Consulta de especialidades médicas.

Los datos de la aplicación son gestionados mediante una API REST conectada a una base de datos **PostgreSQL**.

---

## 🛠️ Tecnologías utilizadas

### Frontend

* **Flutter**
* **Dart**
* Material Design
* HTTP / API REST
* JWT

### Backend

* **Dart**
* **Shelf**
* API REST
* **PostgreSQL**
* JSON Web Token (JWT)

### Plugins principales

* `flutter_local_notifications: ^17.0.0`
* `image_picker: ^1.0.7`

---

## 📌 Requisitos

Antes de ejecutar el proyecto, asegúrate de tener instalado:

* [Flutter](https://flutter.dev/)
* [Dart](https://dart.dev/)
* Android Studio, si deseas ejecutar la aplicación en Android.
* Un emulador Android o dispositivo físico.
* PostgreSQL.
* Backend de **SaludApp** configurado y funcionando.

Puedes comprobar la instalación de Flutter ejecutando:

```bash
flutter doctor
```

---

# 🚀 Instalación y ejecución

Se recomienda tener los proyectos **backend** y **frontend** como carpetas hermanas.

Ejemplo:

```text
proyectos/
├── SaludApp/
└── saludapp-mobile/
```

---

## 🔹 1. Ejecutar el Backend

Primero ingresa al directorio del backend:

```bash
cd ../SaludApp
```

Instala las dependencias:

```bash
dart pub get
```

Ejecuta el servidor:

```bash
dart run lib/main.dart
```

El backend estará disponible en:

```text
http://localhost:8080
```

---

# 📱 2. Ejecutar el Frontend

Ingresa al proyecto móvil:

```bash
cd ../saludapp-mobile
```

Instala las dependencias:

```bash
flutter pub get
```

---

## 🌐 Ejecutar en navegador

Para ejecutar la aplicación en Google Chrome:

```bash
flutter run -d chrome
```

---

## 🤖 Ejecutar en Android

Primero puedes consultar los emuladores disponibles:

```bash
flutter emulators
```

Luego inicia el emulador:

```bash
flutter emulators --launch Pixel_4
```

Para permitir que el dispositivo Android acceda al backend local:

```bash
adb reverse tcp:8080 tcp:8080
```

Finalmente ejecuta:

```bash
flutter run
```

> **Nota:** El comando `adb reverse` permite que el dispositivo o emulador Android pueda acceder al servidor que está ejecutándose en el puerto `8080` de la computadora.

---

## 🪟 Ejecutar en Windows

Si tienes configurado el soporte de escritorio para Windows:

```bash
flutter run -d windows
```

---

# 📁 Estructura del proyecto

```text
saludapp-mobile/
│
├── lib/
│   ├── main.dart
│   │
│   ├── models/
│   │   ├── user.dart
│   │   └── appointment.dart
│   │
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── notification_service.dart
│   │   └── image_service.dart
│   │
│   ├── screens/
│   │   ├── login/
│   │   ├── registro/
│   │   ├── citas/
│   │   ├── crear/
│   │   ├── perfil/
│   │   └── detalle/
│   │
│   ├── routes/
│   │   └── app_routes.dart
│   │
│   └── utils/
│       └── constants.dart
│
├── android/
│   └── AndroidManifest.xml
│
├── ios/
│   └── Info.plist
│
├── pubspec.yaml
└── README.md
```

---

# 📱 Pantallas principales

| Pantalla         | Descripción                                     |
| ---------------- | ----------------------------------------------- |
| 🔐 **Login**     | Inicio de sesión de los usuarios                |
| 📝 **Registro**  | Creación de una nueva cuenta                    |
| 📅 **Citas**     | Lista de citas médicas agendadas                |
| ➕ **Crear cita** | Permite agendar una nueva cita                  |
| 👤 **Perfil**    | Visualización y gestión de los datos personales |
| 📋 **Detalle**   | Información detallada de una cita médica        |

---

# 🔌 Endpoints consumidos

La aplicación se comunica con el backend mediante una API REST.

| Método | Endpoint              | Descripción                        |
| ------ | --------------------- | ---------------------------------- |
| `POST` | `/auth/register`      | Registrar un nuevo usuario         |
| `POST` | `/auth/login`         | Iniciar sesión                     |
| `GET`  | `/api/appointments`   | Obtener las citas del usuario      |
| `POST` | `/api/appointments`   | Crear una nueva cita               |
| `GET`  | `/api/especialidades` | Obtener las especialidades médicas |

---

# 🔐 Autenticación

La aplicación utiliza **JSON Web Token (JWT)** para gestionar la autenticación.

El flujo general es:

```text
Usuario
   │
   ▼
┌──────────────┐
│    Login     │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│    Backend   │
└──────┬───────┘
       │
       ▼
   JWT Token
       │
       ▼
┌──────────────┐
│ Aplicación   │
│    Flutter   │
└──────┬───────┘
       │
       ▼
Solicitudes autenticadas
       │
       ▼
┌──────────────┐
│  API REST    │
└──────────────┘
```

El token permite identificar y autorizar al usuario para realizar operaciones protegidas en la API.

---

# 🔔 Capacidades nativas

La aplicación utiliza diferentes funcionalidades nativas mediante plugins de Flutter.

| Capacidad                 | Plugin                                 | Uso                               |
| ------------------------- | -------------------------------------- | --------------------------------- |
| 🔔 Notificaciones locales | `flutter_local_notifications: ^17.0.0` | Recordatorios de citas médicas    |
| 📷 Selector de imágenes   | `image_picker: ^1.0.7`                 | Selección de fotografía de perfil |

---

# 🗄️ Arquitectura general

La solución está dividida en dos componentes principales:

```text
┌───────────────────────────────┐
│       Aplicación Flutter      │
│                               │
│  UI → Services → API REST     │
└───────────────┬───────────────┘
                │
                │ HTTP / JSON
                │ JWT
                ▼
┌───────────────────────────────┐
│          Backend              │
│                               │
│      Dart + Shelf             │
└───────────────┬───────────────┘
                │
                │ SQL
                ▼
┌───────────────────────────────┐
│        PostgreSQL             │
│                               │
│ Usuarios / Citas /            │
│ Especialidades / etc.         │
└───────────────────────────────┘
```

---

# ⚙️ Dependencias

Las dependencias del proyecto se encuentran definidas en:

```text
pubspec.yaml
```

Para instalarlas:

```bash
flutter pub get
```

Para actualizar las dependencias:

```bash
flutter pub upgrade
```

---

# 🧪 Verificación del proyecto

Puedes comprobar que el proyecto no presenta problemas de análisis ejecutando:

```bash
flutter analyze
```

También puedes ejecutar las pruebas, si están configuradas:

```bash
flutter test
```

---

# 📦 Compilación

Para generar una versión de Android:

```bash
flutter build apk
```

El APK generado normalmente estará disponible en:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Para generar una versión de Windows:

```bash
flutter build windows
```

---

# 👨‍💻 Autor

Alumno: Luis Samaniego
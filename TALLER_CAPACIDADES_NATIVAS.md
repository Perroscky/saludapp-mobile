# Taller de Capacidades Nativas - SaludApp

**Proyecto:** SaludApp - Gestión de citas médicas
**Framework:** Flutter 3.22.0
**Backend:** Dart + Shelf + PostgreSQL
**Fecha:** Septiembre 2026
**Autor:** Luis Samaniego

---

## 1. Justificación de las capacidades elegidas

Para el proyecto **SaludApp**, se seleccionaron **dos capacidades nativas** que aportan valor directo al usuario:

### 1.1 Notificaciones locales (ESENCIAL)

| Aspecto | Detalle |
|---------|---------|
| **Capacidad** | Notificaciones locales |
| **Tipo** | **Esencial** (la app pierde valor sin ella) |
| **Justificación** | Permite enviar recordatorios de citas médicas al usuario. Sin esto, el paciente puede olvidar su cita, generando ausencias y pérdida de tiempo tanto para el paciente como para el doctor. |
| **Impacto** | Reduce las ausencias a citas médicas, mejora la experiencia del usuario y optimiza la agenda del doctor. |

### 1.2 Selector de imágenes (OPCIONAL)

| Aspecto | Detalle |
|---------|---------|
| **Capacidad** | Selector de imágenes (cámara/galería) |
| **Tipo** | **Opcional** (la app funciona sin ella) |
| **Justificación** | Permite al usuario personalizar su perfil con una foto. Aporta valor de identificación visual y mejora la experiencia de usuario. |
| **Impacto** | Mejora la personalización, facilita la identificación del usuario y humaniza la interfaz. |

---

## 2. Verificación de los plugins adoptados

### 2.1 Criterios de verificación aplicados

| Criterio | Descripción |
|----------|-------------|
| **Publicador verificado** | El plugin debe ser mantenido por una organización reconocida |
| **Pub Points** | Puntuación de calidad en pub.dev (mínimo 120/140) |
| **Popularidad** | Número de likes y descargas |
| **Última actualización** | Actualizado en los últimos 12 meses |
| **Soporte Android 16** | Compatible con API 36 |
| **Null Safety** | Soporte completo de null safety |
| **Licencia** | Licencia de código abierto (BSD, MIT, Apache) |
| **Documentación** | Documentación completa y ejemplos |

### 2.2 Verificación de plugins

| Plugin | Versión | Publicador | Pub Points | Likes | Última actualización | Licencia |
|--------|---------|------------|------------|-------|----------------------|----------|
| `flutter_local_notifications` | ^17.0.0 | dexterous.com | 140/140 | 7.5k+ | 2024 | BSD-3-Clause |
| `image_picker` | ^1.0.7 | flutter.dev | 140/140 | 12k+ | 2024 | BSD-3-Clause |
| `permission_handler` | ^11.3.0 | baseflow.com | 140/140 | 5k+ | 2024 | MIT |
| `timezone` | ^0.9.4 | flutter.dev | 130/140 | 2k+ | 2024 | BSD-3-Clause |
| `path_provider` | ^2.1.0 | flutter.dev | 140/140 | 10k+ | 2024 | BSD-3-Clause |

**✅ Todos los plugins cumplen con los criterios establecidos.**

---

## 3. Tabla de permisos declarados

### 3.1 Permisos en Android (`AndroidManifest.xml`)

| Permiso | Propósito | Capacidad | ¿Amplio? |
|---------|-----------|-----------|----------|
| `POST_NOTIFICATIONS` | Enviar notificaciones al usuario | Notificaciones | ❌ No |
| `SCHEDULE_EXACT_ALARM` | Programar alarmas exactas | Notificaciones | ❌ No |
| `USE_EXACT_ALARM` | Usar alarmas exactas | Notificaciones | ❌ No |
| `CAMERA` | Tomar foto de perfil | Selector de imágenes | ❌ No |

**⚠️ NO se declaran permisos de acceso amplio:**
- ❌ `READ_MEDIA_IMAGES` (se usa el selector del sistema)
- ❌ `READ_EXTERNAL_STORAGE` (no necesario)
- ❌ `ACCESS_FINE_LOCATION` (no pertinente)
- ❌ `READ_CONTACTS` (no pertinente)

### 3.2 Cadenas de propósito en iOS (`Info.plist`)

| Clave | Cadena de propósito | Capacidad |
|-------|---------------------|-----------|
| `NSCameraUsageDescription` | "SaludApp necesita acceso a la cámara para tomar una foto de perfil y facilitar tu identificación en las citas médicas." | Selector de imágenes |
| `NSPhotoLibraryUsageDescription` | "SaludApp necesita acceso a tus fotos para que puedas seleccionar una imagen de perfil desde tu galería." | Selector de imágenes |
| `NSPhotoLibraryAddUsageDescription` | "SaludApp necesita permiso para guardar imágenes en tu galería." | Selector de imágenes |

---

## 4. Matriz de degradación

| Capacidad | Situación | Comportamiento de la app |
|-----------|-----------|--------------------------|
| **Notificaciones** | Permiso concedido | ✅ Programa recordatorio de la cita |
| **Notificaciones** | Permiso denegado | ⚠️ Muestra SnackBar informativo. La cita se crea igual, solo sin recordatorio |
| **Notificaciones** | Denegación permanente | ⚠️ Muestra diálogo con botón "Abrir ajustes" que lleva a la configuración del sistema |
| **Notificaciones** | No disponible (hardware) | ⚠️ La cita se crea igual, sin recordatorio |
| **Selector imágenes** | Permiso concedido | ✅ Abre cámara o galería |
| **Selector imágenes** | Permiso denegado | ⚠️ Muestra SnackBar informativo |
| **Selector imágenes** | Denegación permanente | ⚠️ Muestra diálogo con acceso a ajustes |
| **Selector imágenes** | Sin cámara | ⚠️ Solo permite galería |

---

## 5. Solicitud en el momento de uso

Los permisos se solicitan **en el momento de uso**, no al iniciar la aplicación:

| Capacidad | ¿Cuándo se solicita? | Flujo |
|-----------|----------------------|-------|
| **Notificaciones** | Al hacer clic en "Activar recordatorios de citas" (Perfil) | 1. Diálogo de explicación → 2. Solicitud del sistema |
| **Cámara** | Al tocar la foto de perfil → "Tomar foto" | 1. Diálogo de explicación → 2. Solicitud del sistema |
| **Galería** | Al tocar la foto de perfil → "Seleccionar de galería" | 1. Diálogo de explicación → 2. Selector del sistema (sin permiso en Android 13+) |

---

## 6. Integración con persistencia local y backend

### 6.1 Persistencia local

| Dato | Almacenamiento | Uso |
|------|----------------|-----|
| **Token JWT** | `SharedPreferences` | Autenticación en cada solicitud |
| **Datos del usuario** | `SharedPreferences` | Mostrar perfil sin consultar backend |
| **Foto de perfil** | `path_provider` (almacenamiento local) | Guardar imagen seleccionada |

### 6.2 Integración con backend

| Capacidad | Integración |
|-----------|-------------|
| **Notificaciones** | Se programa un recordatorio cuando se crea una cita (`POST /api/appointments`) |
| **Selector de imágenes** | La foto se guarda localmente. El usuario puede actualizar su perfil (futuro: `PUT /api/users/me`) |

---

## 7. Nivel de API objetivo del proyecto

| Aspecto | Estado actual | Requisito Google Play |
|---------|---------------|----------------------|
| **compileSdk** | 34 | 36 (Android 16) |
| **targetSdk** | 34 | 36 (Android 16) |
| **minSdk** | 21 | - |

**⚠️ IMPORTANTE:** A partir del 31 de agosto de 2026, Google Play exige que las aplicaciones nuevas y sus actualizaciones apunten a **Android 16 (API 36)**. Actualmente el proyecto apunta a API 34. Se recomienda actualizar antes de publicar.

---

## 8. Pruebas ejecutadas (5 casos)

| # | Caso | Resultado | Evidencia |
|---|------|-----------|-----------|
| 1 | Notificación con permiso concedido | ✅ | Notificación programada al crear cita |
| 2 | Notificación con permiso denegado | ✅ | Cita creada sin recordatorio |
| 3 | Selector imágenes con permiso concedido | ✅ | Imagen mostrada en perfil |
| 4 | Selector imágenes con permiso denegado | ✅ | SnackBar informativo |
| 5 | Denegación permanente (acceso a ajustes) | ✅ | Diálogo con botón "Abrir ajustes" |

---

## 9. Enlace al repositorio

**Frontend (Flutter):** https://github.com/Perroscky/saludapp-mobile
**Backend (Dart):** https://github.com/Perroscky/saludapp-backend

---

## 10. Conclusiones

La incorporación de capacidades nativas a **SaludApp** permite:

1. **Mejorar la experiencia del usuario:** Recordatorios automáticos y personalización del perfil.
2. **Reducir ausencias:** Los recordatorios ayudan al paciente a no olvidar su cita.
3. **Cumplir con buenas prácticas:** Uso del selector del sistema, sin permisos de acceso amplio innecesarios.
4. **Manejo responsable de permisos:** Se solicitan en el momento de uso, con explicación previa y gestión de los 4 estados.

---

**Autor:** Luis Samaniego
**GitHub:** https://github.com/Perroscky
**Fecha:** Septiembre 2026
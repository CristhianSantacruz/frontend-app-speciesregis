# Species Regis

Aplicación para el registro y gestión de especies, desarrollada con Django (backend) y Flutter (frontend).

## 🌐 Backend Desplegado

El backend está disponible en: https://backend-app-speciesregis-2.onrender.com/

## 📋 Requisitos Previos

### Backend (Django)
- Python 3.8+
- Django 4.x
- Configuración de Firebase (para almacenamiento de datos)

### Frontend (Flutter)
- Flutter SDK 3.0+
- Dart 2.17+
- Android Studio / VS Code
- Dispositivo Android (recomendado para subida de imágenes)

## 🚀 Configuración del Proyecto

### Backend Setup



Clonar el repositorio
```bash
git clone [url-del-repositorio]
cd backend-app-speciesregis-main
```
Instalar dependencias
```bash
pip install -r requirements.txt
```
Ejecutar migraciones
```bash
python manage.py migrate
```
Iniciar servidor
```bash
python manage.py runserver
```


## 📚 API Endpoints

### 🐾 Especies (Species)

| Endpoint | Método | Descripción |
|----------|---------|-------------|
| \`/species/\` | GET | Obtener todas las especies |
| \`/species/create/\` | POST | Crear nueva especie |
| \`/species/{species_id}/\` | GET | Obtener especie por ID |
| \`/species/{species_id}/update/\` | PUT | Actualizar especie |
| \`/species/{species_id}/delete/\` | DELETE | Eliminar especie |

### 🏞️ Hábitats

| Endpoint | Método | Descripción |
|----------|---------|-------------|
| \`/habitats/\` | GET | Obtener todos los hábitats disponibles |

### 🔐 Autenticación

| Endpoint | Método | Descripción |
|----------|---------|-------------|
| \`/auth/register/\` | POST | Registrar nuevo usuario |
| \`/auth/login/\` | POST | Iniciar sesión |
| \`/auth/verify/\` | POST | Verificar token de autenticación |
| \`/auth/profile/\` | GET | Obtener perfil del usuario |


### Frontend Setup (Flutter)

Navegar al directorio frontend
```bash
cd frontend-app-speciesregis-main
```
Limpiar dependencias
```bash
flutter clean
```
Obtener dependencias
```bash
flutter pub get
```
Ejecutar en dispositivo
```bash
flutter run
```

**Recomendación:** Usar dispositivo Android físico 

## 📱 Uso de la Aplicación

### Registro de Especies
1. Crear cuenta o iniciar sesión
2. Navegar a "Registrar Especie"
3. Completar formulario con datos de la especie
5. Tomar foto o seleccionar de galería
6. Guardar especie


### Gestión de Especies
- Ver listado completo de especies
- Buscar especies específicas y filtros


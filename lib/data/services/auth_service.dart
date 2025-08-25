import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'https://backend-app-speciesregis-2.onrender.com/api';
  late Dio _dio;

  AuthService() {
    _dio = Dio();
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Interceptor para logs solo en debug mode (sin datos sensibles)
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: false, // No mostrar request body (contiene contraseñas)
          responseBody: false, // No mostrar response body (contiene tokens)
          requestHeader: false, // No mostrar headers (contienen Authorization)
          logPrint: (obj) => print(obj),
        ),
      );
    }
  }

  /// Registro de usuario
  Future<AuthResponse> registerUser({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final fullName = '$firstName $lastName'.trim();

      final response = await _dio.post(
        '/auth/register/',
        data: {
          'full_name': fullName,
          'email': email.trim().toLowerCase(),
          'phone': phone.trim(),
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;

        // Guardar token automáticamente
        await _saveToken(data['data']['token']);

        return AuthResponse.success(
          message: data['message'],
          userData: UserData.fromJson(data['data']),
        );
      } else {
        return AuthResponse.error(
          message: response.data['message'] ?? 'Error desconocido',
          errors: response.data['password_errors'] ?? [],
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return AuthResponse.error(message: 'Error inesperado: $e');
    }
  }

  /// Login de usuario
  Future<AuthResponse> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login/',
        data: {'email': email.trim().toLowerCase(), 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Guardar token automáticamente
        await _saveToken(data['data']['token']);

        return AuthResponse.success(
          message: data['message'],
          userData: UserData.fromJson(data['data']),
        );
      } else {
        return AuthResponse.error(
          message: response.data['message'] ?? 'Credenciales incorrectas',
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return AuthResponse.error(message: 'Error inesperado: $e');
    }
  }

  /// Verificar si el token es válido
  Future<AuthResponse> verifyToken() async {
    try {
      final token = await getToken();
      if (token == null) {
        return AuthResponse.error(message: 'No hay token guardado');
      }

      final response = await _dio.post(
        '/auth/verify/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return AuthResponse.success(
          message: data['message'],
          userData: UserData.fromJson(data['data']),
        );
      } else {
        return AuthResponse.error(
          message: response.data['message'] ?? 'Token inválido',
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return AuthResponse.error(message: 'Error inesperado: $e');
    }
  }

  /// Obtener perfil del usuario autenticado
  Future<AuthResponse> getUserProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        return AuthResponse.error(message: 'No hay token guardado');
      }

      final response = await _dio.get(
        '/auth/profile/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return AuthResponse.success(
          message: 'Perfil obtenido exitosamente',
          userData: UserData.fromJson(data['data']),
        );
      } else {
        return AuthResponse.error(
          message: response.data['message'] ?? 'Error obteniendo perfil',
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return AuthResponse.error(message: 'Error inesperado: $e');
    }
  }

  /// Guardar token en almacenamiento local
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Obtener token del almacenamiento local
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Cerrar sesión (eliminar token)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    if (token == null) return false;

    final response = await verifyToken();
    return response.isSuccess;
  }

  /// Manejo de errores de Dio
  AuthResponse _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AuthResponse.error(
          message: 'Error de conexión. Verifica tu internet.',
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        if (statusCode == 400) {
          // Error de validación - extraer todos los errores posibles
          List<String> allErrors = [];
          String mainMessage = data['message'] ?? 'Datos inválidos';

          // Agregar errores específicos de contraseña si existen
          if (data['password_errors'] != null &&
              data['password_errors'].isNotEmpty) {
            allErrors.addAll(List<String>.from(data['password_errors']));
          }

          // Mensaje principal más específico basado en el contenido
          if (mainMessage.contains('correo electrónico no es válido')) {
            mainMessage =
                '📧 Formato de email inválido\nEjemplo: usuario@gmail.com';
          } else if (mainMessage.contains('teléfono no es válido')) {
            mainMessage =
                '📞 Formato de teléfono inválido\nEjemplo: +593987654321';
          } else if (mainMessage.contains('nombre completo')) {
            mainMessage = '👤 El nombre debe contener solo letras y espacios';
          } else if (mainMessage.contains('campos son obligatorios')) {
            mainMessage = '⚠️ Todos los campos son obligatorios';
          }

          return AuthResponse.error(message: mainMessage, errors: allErrors);
        } else if (statusCode == 401) {
          return AuthResponse.error(
            message:
                '🔐 ${data['message'] ?? 'Email o contraseña incorrectos'}',
          );
        } else if (statusCode == 409) {
          return AuthResponse.error(
            message: '⚠️ ${data['message'] ?? 'Este email ya está registrado'}',
          );
        } else {
          return AuthResponse.error(
            message: '❌ ${data['message'] ?? 'Error del servidor'}',
          );
        }

      default:
        return AuthResponse.error(message: 'Error de red: ${e.message}');
    }
  }
}

/// Clase para la respuesta de autenticación
class AuthResponse {
  final bool isSuccess;
  final String message;
  final UserData? userData;
  final List<String> errors;

  AuthResponse._({
    required this.isSuccess,
    required this.message,
    this.userData,
    this.errors = const [],
  });

  factory AuthResponse.success({required String message, UserData? userData}) {
    return AuthResponse._(
      isSuccess: true,
      message: message,
      userData: userData,
    );
  }

  factory AuthResponse.error({
    required String message,
    List<String> errors = const [],
  }) {
    return AuthResponse._(isSuccess: false, message: message, errors: errors);
  }
}

/// Clase para los datos del usuario
class UserData {
  final String userId;
  final String fullName;
  final String email;
  final String phone;
  final String? token;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  UserData({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    this.token,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['user_id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      token: json['token'],
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'token': token,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_active': isActive,
    };
  }
}

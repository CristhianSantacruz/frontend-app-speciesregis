import 'package:dio/dio.dart';
import 'package:frontend_spaceregis/data/api/api_routes.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    // Puedes agregar interceptors aquí si lo necesitas
    // dio.interceptors.add(LogInterceptor(responseBody: true));
  }
}
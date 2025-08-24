import 'package:dio/dio.dart';
import 'package:frontend_spaceregis/data/api/api_routes.dart';
import 'package:frontend_spaceregis/data/api/client_dio.dart';
import 'package:frontend_spaceregis/data/model/species_model.dart';

class SpeciesServices {
   final _dio = DioClient().dio;

  Future<List<String>> fetchHabitats() async {
    final response = await _dio.get(getHabitats); // Ajusta la ruta según tu API
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      List<dynamic> data = response.data['data'];
      return data.map((e) => e.toString()).toList();
    }
    throw Exception('Error al obtener hábitats');
  }
  Future<bool> registerSpecies({
    required String name,
    required String scientificName,
    required String description,
    required String characteristic,
    required String habitat,
    required String imagePath,
  }) async {
    FormData formData = FormData.fromMap({
      'name': name,
      'scientific_name': scientificName,
      'description': description,
      'characteristic': characteristic,
      'habitat': habitat,
      'image': await MultipartFile.fromFile(imagePath),
    });
    try {
      final response = await _dio.post(creteSpecie, data: formData);
      if (response.statusCode == 201 || response.data['status'] == 'success') {
          return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error al crear especie');
    }
  }

  

}
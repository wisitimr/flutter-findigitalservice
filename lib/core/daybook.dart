import 'package:dio/dio.dart';
import 'package:saved/app_provider.dart';

class DayBookService {
  static BaseOptions options = BaseOptions(
    baseUrl: "http://localhost:8080/api/daybook",
  );
  final Dio _dio = Dio(options);

  Future<dynamic> count(
      AppProvider provider, Map<String, dynamic> param) async {
    try {
      String url = '/count';
      if (param.isNotEmpty) {
        url += '?${Uri(queryParameters: param).query}';
      }
      Response response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer ${provider.accessToken}'},
        ),
      );
      //returns the successful user data json object
      return response.data;
    } on DioException catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> findAll(
      AppProvider provider, Map<String, dynamic> param) async {
    try {
      String url = '';
      if (param.isNotEmpty) {
        url = '?${Uri(queryParameters: param).query}';
      }
      Response response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer ${provider.accessToken}'},
        ),
      );
      //returns the successful user data json object
      return response.data;
    } on DioException catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> findById(AppProvider provider, String id) async {
    try {
      Response response = await _dio.get(
        '/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${provider.accessToken}'},
        ),
      );
      //returns the successful user data json object
      return response.data;
    } on DioException catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<dynamic> save(AppProvider provider, Map<String, dynamic>? data) async {
    try {
      Response response;
      final options = Options(
        headers: {'Authorization': 'Bearer ${provider.accessToken}'},
      );
      if (data?['id'] != "" && data?['id'] != null) {
        final id = data?['id'];
        response = await _dio.put('/$id', //ENDPONT URL
            data: data, //REQUEST BODY
            options: options);
      } else {
        data?['id'] = null;
        data?['daybookDetails'] = [];
        response = await _dio.post('', //ENDPONT URL
            data: data, //REQUEST BODY
            options: options);
      }
      return response.data;
    } on DioException catch (e) {
      //returns the error object if there is
      return e.response!.data;
    }
  }
}

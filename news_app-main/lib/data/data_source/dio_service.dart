import 'package:dio/dio.dart';
import 'network_constants.dart';
import '../models/news_model.dart';

class DioService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: NetworkConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<NewsModel>> getNews({int page = 1, required String query}) async {
    try {
     
      String endpoint = "/everything";
      
      Map<String, dynamic> params = {
        'apiKey': NetworkConstants.apiKey,
        'page': page,
        'pageSize': 10,
        'q': query, 
        'sortBy': 'publishedAt', 
      };

      final response = await _dio.get(endpoint, queryParameters: params);

      if (response.statusCode == 200) {
        final List articles = response.data['articles'];
        return articles.map((json) => NewsModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load news");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/data_source/dio_service.dart';
import '../data/models/news_model.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final DioService _dioService = DioService();

 
  List<NewsModel> _newsList = [];
  int _page = 1;
  String _currentQuery = "Egypt"; 
  bool _isFetching = false; 

  NewsCubit() : super(NewsInitial());

 
  Future<void> loadNews({String? query, bool isRefresh = false}) async {
   
    if (_isFetching) return;
    _isFetching = true;

    try {
      if (isRefresh) {
        _page = 1;
        _newsList.clear();
        if (query != null) {
          _currentQuery = query.trim().isEmpty ? "Egypt" : query.trim();
        }
        emit(NewsLoading());
      } else {
        if (state is NewsLoaded) {
          emit(NewsLoaded(news: _newsList, isLoadingMore: true));
        }
      }

      final newItems = await _dioService.getNews(
        page: _page,
        query: _currentQuery,
      );

      _newsList.addAll(newItems);
      _page++;

      emit(NewsLoaded(news: _newsList, isLoadingMore: false));
    } catch (e) {
      if (_newsList.isEmpty) {
        emit(NewsError(e.toString()));
      } else {
        emit(NewsLoaded(news: _newsList, isLoadingMore: false));
      }
    } finally {
      _isFetching = false;
    }
  }
}
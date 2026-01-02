import '../data/models/news_model.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsModel> news;
  final bool isLoadingMore; 

  NewsLoaded({required this.news, this.isLoadingMore = false});
}

class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}
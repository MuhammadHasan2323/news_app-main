import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/data_source/dio_service.dart';
import '../../data/models/news_model.dart';
import '../widgets/news_card.dart';
import 'news_detail_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  
  String currentSearchQuery = "Egypt"; 
  
  List<NewsModel> newsList = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  String? errorMessage;
  
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  final DioService _dioService = DioService();

  @override
  void initState() {
    super.initState();
    _fetchNews(isRefresh: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!isLoading && !isLoadingMore) {
          _fetchNews(isRefresh: false);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  void _updateSearchQuery(String newQuery) {

    currentSearchQuery = newQuery.trim();
    _fetchNews(isRefresh: true);
  }

  Future<void> _fetchNews({bool isRefresh = false}) async {
    if (isRefresh) {
      if (mounted) {
        setState(() {
          isLoading = true;
          errorMessage = null;
          currentPage = 1;
          newsList.clear();
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoadingMore = true;
        });
      }
    }

    try {

      final newItems = await _dioService.getNews(
        page: currentPage, 
        query: currentSearchQuery.isEmpty ? "Egypt" : currentSearchQuery,
      );

      if (mounted) {
        setState(() {
          newsList.addAll(newItems);
          currentPage++;
          isLoading = false;
          isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (newsList.isEmpty) errorMessage = e.toString();
          isLoading = false;
          isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Newsly"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          
          SearchBarWidget(
            onSearch: _updateSearchQuery,
            initialValue: currentSearchQuery, 
          ),
          
          Expanded(
            child: Builder(
              builder: (context) {
                if (isLoading && newsList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (errorMessage != null && newsList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(errorMessage!, textAlign: TextAlign.center),
                        ),
                        ElevatedButton(
                          onPressed: () => _fetchNews(isRefresh: true),
                          child: const Text("Retry"),
                        )
                      ],
                    ),
                  );
                }
                
                if (newsList.isEmpty) {
                   return const Center(child: Text("No news found!"));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: newsList.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == newsList.length) {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final newsItem = newsList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailScreen(news: newsItem),
                          ),
                        );
                      },
                      child: NewsCard(news: newsItem),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  final String initialValue;

  const SearchBarWidget({
    super.key, 
    required this.onSearch,
    required this.initialValue,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      widget.onSearch(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        keyboardType: TextInputType.text, 
        textInputAction: TextInputAction.search,
        enableSuggestions: true,
        
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: "Search news...",
          fillColor: Colors.white,
          filled: true,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          
        
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
          
              _controller.clear();
              
              widget.onSearch("");
            },
          ),
          
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
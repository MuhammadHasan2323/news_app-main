import 'package:flutter/material.dart';
import '../../data/models/news_model.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;
  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: news.urlToImage != null
                ? Image.network(
                    news.urlToImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(height: 200, color: Colors.grey, child: const Icon(Icons.broken_image)),
                  )
                : Container(height: 200, color: Colors.grey, child: const Icon(Icons.image_not_supported)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title ?? "No Title",
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  news.publishedAt ?? "",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
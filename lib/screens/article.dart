import 'package:flutter/material.dart';
import 'package:health_app/models/article_model.dart';

import '../utils/app_route.dart';

class Article extends StatefulWidget {
  final ArticleModel article;

  const Article({
    super.key,
    required this.article,
  });

  @override
  State<StatefulWidget> createState() {
    return ArticleState();
  }
}

class ArticleState extends State<Article> {
  String _formatDate(DateTime date) {
    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  String? _getDisplayImage() {
    // Use imageURL if available, otherwise use video thumbnail if video exists
    return widget.article.imageURL ?? widget.article.videoURL;
  }

  @override
  Widget build(BuildContext context) {
    final displayImage = _getDisplayImage();
    final formattedDate = _formatDate(widget.article.date);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.showArticle,
          arguments: widget.article,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 7,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Stack(
              children: [
                if (displayImage != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      displayImage,
                      height: 230,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 230,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.article,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    height: 230,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.article,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(20),
                  height: 230,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    widget.article.title,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                ),
                // Optional: Add a video indicator if it's a video article
                if (widget.article.videoURL != null)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1ECEC),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.create,
                          color: Color(0xFF599B99),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'الدكتور :',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF599B99),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.article.writer,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF495057),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1ECEC),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.date_range_outlined,
                          color: Color(0xFF599B99),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF495057),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Optional: Show category if needed
            if (widget.article.category.isNotEmpty)
              Container(
                padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1ECEC),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.category,
                        color: Color(0xFF599B99),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.article.category,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF495057),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

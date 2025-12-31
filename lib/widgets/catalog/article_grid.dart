
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import '../../dto/ArticleDTO.dart';

class ArticleGrid extends StatelessWidget {
  final List<ArticleDTO> articles;
  final ValueChanged<ArticleDTO> onSelectArticle;

  const ArticleGrid({
    super.key,
    required this.articles,
    required this.onSelectArticle,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Platform.isAndroid ? 2 : 3,
      ),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final item = articles[index];

        return GestureDetector(
          onTap: () => onSelectArticle(item),
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Image.asset(
                      item.icon!,
                      fit: BoxFit.cover,
                      height: Platform.isAndroid
                          ? MediaQuery.of(context).size.height * 0.075
                          : MediaQuery.of(context).size.height * 0.1,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        item.title ?? "",
                        softWrap: true,
                        style: const TextStyle(
                          height: 0,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

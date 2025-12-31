import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import '../../dto/ArticleDTO.dart';
import '../../dto/CategoryDTO.dart';
import 'article_extras_view.dart';
import 'category_list.dart';
import 'article_grid.dart';


class CatalogView extends StatelessWidget {
  final List<CategoryDTO> categories;
  final int selectedCategoryIndex;

  final List<ArticleDTO> articlesForCategory;

  final bool showArticleExtras;
  final ArticleDTO? selectedArticle;

  final ValueChanged<int> onSelectCategory;
  final ValueChanged<ArticleDTO> onSelectArticle;

  final VoidCallback onBackFromExtras;
  final VoidCallback onAddSelectedToCart;
  final VoidCallback onExtrasChanged;

  const CatalogView({
    super.key,
    required this.categories,
    required this.selectedCategoryIndex,
    required this.articlesForCategory,
    required this.showArticleExtras,
    required this.selectedArticle,
    required this.onSelectCategory,
    required this.onSelectArticle,
    required this.onBackFromExtras,
    required this.onAddSelectedToCart,
    required this.onExtrasChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          flex: 1,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(right: 8),
            child: CategoryList(
              categories: categories,
              selectedIndex: selectedCategoryIndex,
              onSelect: onSelectCategory,
            ),
          ),
        ),

        const VerticalDivider(
          color: Colors.grey,
          thickness: 3,
          width: 0,
        ),

        Expanded(
          flex: Platform.isAndroid ? 3 : 4,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 8, top: Platform.isAndroid ? 8 : 30),
            child: showArticleExtras && selectedArticle != null
                ? ExtrasView(
              selected: selectedArticle!,
              onBack: onBackFromExtras,
              onAddToCart: onAddSelectedToCart,
              onChanged: onExtrasChanged,
            )
                : ArticleGrid(
              articles: articlesForCategory,
              onSelectArticle: onSelectArticle,
            ),
          ),
        ),

      ],
    );
  }
}

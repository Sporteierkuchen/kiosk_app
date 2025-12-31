
import 'dart:math';
import '../dto/ArticleDTO.dart';
import '../dto/ArticleExtraDTO.dart';
import '../dto/CategoryDTO.dart';

class DemoCatalogLoader {

  Future<DemoCatalogData> load() async {

    final categories = <CategoryDTO>[
      CategoryDTO(name: "Frühstück", icon: 'lib/images/categories/Frühstück.jpg'),
      CategoryDTO(name: "Kaffee", icon: 'lib/images/categories/Kaffee.jpg'),
      CategoryDTO(name: "Kuchen", icon: 'lib/images/categories/Kuchen.jpg'),
    ];

    final articles = <ArticleDTO>[];

    List<ArticleExtraDTO> getExtras() {
      final extras = <ArticleExtraDTO>[];
      final anzahl = Random().nextInt(11);
      for (int i = 1; i < anzahl + 1; i++) {
        extras.add(
          ArticleExtraDTO(
            amount: 0,
            name: "Zutat $i",
            description: i % 3 == 0 ? "Das ist ein Test!" : "",
            price: anzahl / i * 1.78 + 3.45,
          ),
        );
      }
      return extras;
    }

    // Frühstück
    final breakfastAssets = [
      "lib/images/articles/Arme Ritter.png",
      "lib/images/articles/Avocado Brot.png",
      "lib/images/articles/English Breakfast.png",
      "lib/images/articles/Granola Bowl.png",
      "lib/images/articles/Obstplatte.png",
      "lib/images/articles/Omelette.png",
      "lib/images/articles/Pancakes.png",
      "lib/images/articles/Pochierte Eier.png",
    ];

    for (final p in breakfastAssets) {
      final title = p.split("/").last.replaceAll(".png", "");
      final img = p;
      articles.add(
        ArticleDTO(
          title: title,
          group: categories[0],
          priceGross: (1 + Random().nextDouble() * 10) + (Random().nextDouble() * 100) / 100,
          extraslist: getExtras(),
          icon: img,
        ),
      );
    }

    // Kaffee
    final coffeeAssets = [
      "lib/images/articles/Espresso.png",
      "lib/images/articles/Heiße Schokolade.png",
      "lib/images/articles/Ice Chai Tee Latte.png",
      "lib/images/articles/Ice Latte Macchiato.png",
      "lib/images/articles/Ice Matcha Latte.png",
      "lib/images/articles/Kaffee.png",
      "lib/images/articles/Latte Macchiato.png",
    ];

    for (final p in coffeeAssets) {
      final title = p.split("/").last.replaceAll(".png", "");
      final img = p;
      articles.add(
        ArticleDTO(
          title: title,
          group: categories[1],
          priceGross: (1 + Random().nextDouble() * 10) + (Random().nextDouble() * 100) / 100,
          extraslist: getExtras(),
          icon: img,
        ),
      );
    }

    // Kuchen
    final cakeAssets = [
      "lib/images/articles/Erdbeertorte.png",
      "lib/images/articles/Himbeertorte.png",
      "lib/images/articles/Mohnkuchen.png",
      "lib/images/articles/Schokoladentorte.png",
      "lib/images/articles/Zitronenkuchen.png",
    ];

    for (final p in cakeAssets) {
      final title = p.split("/").last.replaceAll(".png", "");
      final img = p;
      articles.add(
        ArticleDTO(
          title: title,
          group: categories[2],
          priceGross: (1 + Random().nextDouble() * 10) + (Random().nextDouble() * 100) / 100,
          extraslist: getExtras(),
          icon: img,
        ),
      );
    }

    return DemoCatalogData(categories: categories, articles: articles);
  }
}

class DemoCatalogData {
  final List<CategoryDTO> categories;
  final List<ArticleDTO> articles;

  DemoCatalogData({required this.categories, required this.articles});
}

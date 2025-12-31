import '../dto/ArticleDTO.dart';
import '../dto/ArticleExtraDTO.dart';

class CartUtils {
  static int itemCount(List<ArticleDTO> cart) => cart.length;

  static double totalPrice(List<ArticleDTO> cart) {
    double price = 0;
    for (final a in cart) {
      price += (a.priceGross ?? 0);
      for (final extra in (a.extraslist ?? const <ArticleExtraDTO>[])) {
        price += (extra.price ?? 0) * extra.amount;
      }
    }
    return price;
  }

  static double articlePrice(ArticleDTO article) {
    double price = (article.priceGross ?? 0);
    for (final e in (article.extraslist ?? const <ArticleExtraDTO>[])) {
      price += (e.price ?? 0) * e.amount;
    }
    return price;
  }

  static double selectedPrice(ArticleDTO selected) => articlePrice(selected);
}

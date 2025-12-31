import '../dto/ArticleDTO.dart';
import '../dto/ArticleExtraDTO.dart';
import '../dto/CategoryDTO.dart';

class ArticleClone {
  static ArticleDTO cloneForSelection(ArticleDTO source) {
    final extrasCopy = <ArticleExtraDTO>[];
    for (final e in (source.extraslist ?? const <ArticleExtraDTO>[])) {
      extrasCopy.add(ArticleExtraDTO(
        name: e.name,
        amount: e.amount,
        price: e.price,
        description: e.description,
      ));
    }

    final g = source.group;
    final groupCopy = g == null
        ? null
        : CategoryDTO(
      uid: g.uid,
      name: g.name,
      number: g.number,
      icon: g.icon,
    );

    return ArticleDTO(
      title: source.title,
      description: source.description,
      ingredients: source.ingredients,
      allergens: source.allergens,
      guid: source.guid,
      articleNumber: source.articleNumber,
      group: groupCopy,
      priceNet: source.priceNet,
      priceGross: source.priceGross,
      vat: source.vat,
      deleted: source.deleted,
      ean: source.ean,
      quantityUnit: source.quantityUnit,
      icon: source.icon,
      extraslist: extrasCopy,
    );
  }

  static ArticleDTO cloneForCartFromSelected(ArticleDTO selected) {
    final extrasOnlySelected = <ArticleExtraDTO>[];
    for (final e in (selected.extraslist ?? const <ArticleExtraDTO>[])) {
      if (e.amount > 0) {
        extrasOnlySelected.add(ArticleExtraDTO(
          name: e.name,
          amount: e.amount,
          price: e.price,
          description: e.description,
        ));
      }
    }

    final g = selected.group;
    final groupCopy = g == null
        ? null
        : CategoryDTO(
      uid: g.uid,
      name: g.name,
      number: g.number,
      icon: g.icon,
    );

    return ArticleDTO(
      title: selected.title,
      description: selected.description,
      ingredients: selected.ingredients,
      allergens: selected.allergens,
      guid: selected.guid,
      articleNumber: selected.articleNumber,
      group: groupCopy,
      priceNet: selected.priceNet,
      priceGross: selected.priceGross,
      vat: selected.vat,
      deleted: selected.deleted,
      ean: selected.ean,
      quantityUnit: selected.quantityUnit,
      icon: selected.icon,
      extraslist: extrasOnlySelected,
    );
  }
}

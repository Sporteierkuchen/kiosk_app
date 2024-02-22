
import 'package:json_annotation/json_annotation.dart';

import 'ArticleExtraDTO.dart';
import 'CategoryDTO.dart';
part 'ArticleDTO.g.dart';

@JsonSerializable()
class ArticleDTO {

  String? title;
  String? description;
  String? ingredients;
  String? allergens;
  String? guid;
  String? articleNumber;
  CategoryDTO? group;
  String? priceNet;
  double? priceGross;
  double? vat;
  String? deleted;

  String? ean;
  String? quantityUnit;
  String? icon;

  List<ArticleExtraDTO>? extraslist;

  ArticleDTO({
    this.title,
    this.description,
    this.ingredients,
    this.allergens,
    this.guid,
    this.articleNumber,
    this.group,
    this.priceNet,
    this.priceGross,
    this.vat,
    this.deleted,
    this.ean,
    this.quantityUnit,
    this.icon,
    this.extraslist
  });

  factory ArticleDTO.fromJson(Map<String, dynamic> json) =>
      _$ArticleDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleDTOToJson(this);

}
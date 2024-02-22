
import 'package:json_annotation/json_annotation.dart';

part 'Article.g.dart';

@JsonSerializable()
class Article {


  String? articleNumber;
  int? quantity;
  String? type;

  Article({
    this.articleNumber,
    this.quantity,
    this.type
  });

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

}
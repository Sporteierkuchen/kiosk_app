import 'package:json_annotation/json_annotation.dart';
part 'ArticleExtraDTO.g.dart';

@JsonSerializable()
class ArticleExtraDTO {

  String? name;
  String? description;
  int amount;
  double? price;

  ArticleExtraDTO({
    this.name,
    this.description,
    required this.amount,
    this.price,
  });

  factory ArticleExtraDTO.fromJson(Map<String, dynamic> json) =>
      _$ArticleExtraDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleExtraDTOToJson(this);



  void increase() {
    amount++;
  }

  void decrease() {
    amount--;
  }
}
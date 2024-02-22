
import 'package:json_annotation/json_annotation.dart';

import 'Article.dart';

part 'ReceiptDTO.g.dart';

@JsonSerializable()
class ReceiptDTO {

  String? currency;
  String? time;
  String? status;
  String? type;
  String? referenceCode;
  String? paymentMethod;
  List<Article>? articles;

  ReceiptDTO({
    this.currency,
    this.time,
    this.status,
    this.type,
    this.referenceCode,
    this.paymentMethod,
    this.articles
  });

  factory ReceiptDTO.fromJson(Map<String, dynamic> json) =>
      _$ReceiptDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptDTOToJson(this);

}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ArticleExtraDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleExtraDTO _$ArticleExtraDTOFromJson(Map<String, dynamic> json) =>
    ArticleExtraDTO(
      name: json['name'] as String?,
      description: json['description'] as String?,
      amount: json['amount'] as int,
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ArticleExtraDTOToJson(ArticleExtraDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'amount': instance.amount,
      'price': instance.price,
    };

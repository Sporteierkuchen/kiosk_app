// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      articleNumber: json['articleNumber'] as String?,
      quantity: json['quantity'] as int?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'articleNumber': instance.articleNumber,
      'quantity': instance.quantity,
      'type': instance.type,
    };

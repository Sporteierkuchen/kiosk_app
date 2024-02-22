// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ArticleDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleDTO _$ArticleDTOFromJson(Map<String, dynamic> json) => ArticleDTO(
      title: json['title'] as String?,
      description: json['description'] as String?,
      ingredients: json['ingredients'] as String?,
      allergens: json['allergens'] as String?,
      guid: json['guid'] as String?,
      articleNumber: json['articleNumber'] as String?,
      group: json['group'] == null
          ? null
          : CategoryDTO.fromJson(json['group'] as Map<String, dynamic>),
      priceNet: json['priceNet'] as String?,
      priceGross: (json['priceGross'] as num?)?.toDouble(),
      vat: (json['vat'] as num?)?.toDouble(),
      deleted: json['deleted'] as String?,
      ean: json['ean'] as String?,
      quantityUnit: json['quantityUnit'] as String?,
      icon: json['icon'] as String?,
      extraslist: (json['extraslist'] as List<dynamic>?)
          ?.map((e) => ArticleExtraDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArticleDTOToJson(ArticleDTO instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'ingredients': instance.ingredients,
      'allergens': instance.allergens,
      'guid': instance.guid,
      'articleNumber': instance.articleNumber,
      'group': instance.group,
      'priceNet': instance.priceNet,
      'priceGross': instance.priceGross,
      'vat': instance.vat,
      'deleted': instance.deleted,
      'ean': instance.ean,
      'quantityUnit': instance.quantityUnit,
      'icon': instance.icon,
      'extraslist': instance.extraslist,
    };

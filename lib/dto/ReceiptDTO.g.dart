// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReceiptDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptDTO _$ReceiptDTOFromJson(Map<String, dynamic> json) => ReceiptDTO(
      currency: json['currency'] as String?,
      time: json['time'] as String?,
      status: json['status'] as String?,
      type: json['type'] as String?,
      referenceCode: json['referenceCode'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      articles: (json['articles'] as List<dynamic>?)
          ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReceiptDTOToJson(ReceiptDTO instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'time': instance.time,
      'status': instance.status,
      'type': instance.type,
      'referenceCode': instance.referenceCode,
      'paymentMethod': instance.paymentMethod,
      'articles': instance.articles,
    };

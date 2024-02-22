import 'package:json_annotation/json_annotation.dart';
part 'CategoryDTO.g.dart';

@JsonSerializable()
class CategoryDTO {
  String? uid;
  String? name;
  String? number;

  String? icon;

  CategoryDTO({
     this.uid,
    this.name,
    this.number,
    this.icon,
  });

  factory CategoryDTO.fromJson(Map<String, dynamic> json) =>
      _$CategoryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDTOToJson(this);


}
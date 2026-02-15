// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karma_tier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KarmaTier _$KarmaTierFromJson(Map<String, dynamic> json) => _KarmaTier(
  id: json['id'] as String,
  name: json['name'] as String,
  minPoints: (json['min_points'] as num).toInt(),
  benefits: (json['benefits'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  badgeIcon: json['badge_icon'] as String?,
);

Map<String, dynamic> _$KarmaTierToJson(_KarmaTier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'min_points': instance.minPoints,
      'benefits': instance.benefits,
      'badge_icon': instance.badgeIcon,
    };

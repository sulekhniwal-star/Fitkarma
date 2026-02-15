// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dosha_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DoshaQuestion _$DoshaQuestionFromJson(Map<String, dynamic> json) =>
    _DoshaQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: Map<String, String>.from(json['options'] as Map),
      category: json['category'] as String,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$DoshaQuestionToJson(_DoshaQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'options': instance.options,
      'category': instance.category,
      'order': instance.order,
    };

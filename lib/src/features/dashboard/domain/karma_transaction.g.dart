// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karma_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KarmaTransaction _$KarmaTransactionFromJson(Map<String, dynamic> json) =>
    _KarmaTransaction(
      id: json['id'] as String,
      user: json['user'] as String,
      amount: (json['amount'] as num).toDouble(),
      actionType: json['action_type'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$KarmaTransactionToJson(_KarmaTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'amount': instance.amount,
      'action_type': instance.actionType,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
    };

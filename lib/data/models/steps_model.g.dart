// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steps_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StepsModelAdapter extends TypeAdapter<StepsModel> {
  @override
  final int typeId = 1;

  @override
  StepsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepsModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      count: fields[2] as int,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StepsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.count)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepsModel _$StepsModelFromJson(Map<String, dynamic> json) => StepsModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      count: (json['count'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$StepsModelToJson(StepsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'count': instance.count,
      'date': instance.date.toIso8601String(),
    };

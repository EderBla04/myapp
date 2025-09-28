// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sow_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SowAdapter extends TypeAdapter<Sow> {
  @override
  final int typeId = 0;

  @override
  Sow read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sow(
      id: fields[0] as int,
      name: fields[1] as String,
      isPregnant: fields[2] as bool,
      estimatedBirthDate: fields[3] as DateTime?,
      visualState: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Sow obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isPregnant)
      ..writeByte(3)
      ..write(obj.estimatedBirthDate)
      ..writeByte(4)
      ..write(obj.visualState);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SowAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

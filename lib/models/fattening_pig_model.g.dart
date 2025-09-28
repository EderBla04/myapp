// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fattening_pig_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FatteningPigAdapter extends TypeAdapter<FatteningPig> {
  @override
  final int typeId = 2;

  @override
  FatteningPig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FatteningPig(
      id: fields[0] as int,
      name: fields[1] as String,
      pesoActual: fields[2] as double,
      origen: fields[3] as String,
      fechaIngreso: fields[4] as DateTime,
      estadoVisual: fields[5] as String,
      weightHistory: (fields[6] as HiveList?)?.castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, FatteningPig obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.pesoActual)
      ..writeByte(3)
      ..write(obj.origen)
      ..writeByte(4)
      ..write(obj.fechaIngreso)
      ..writeByte(5)
      ..write(obj.estadoVisual)
      ..writeByte(6)
      ..write(obj.weightHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FatteningPigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

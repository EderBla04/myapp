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
      fechaPrenada: fields[2] as DateTime?,
      fechaPartoEstimado: fields[3] as DateTime?,
      cerditosNacidos: fields[4] as int,
      cerditosNoSobrevivieron: fields[5] as int,
      cerditosImportados: fields[6] as int,
      estadoVisual: fields[7] as String,
      hasDado: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Sow obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.fechaPrenada)
      ..writeByte(3)
      ..write(obj.fechaPartoEstimado)
      ..writeByte(4)
      ..write(obj.cerditosNacidos)
      ..writeByte(5)
      ..write(obj.cerditosNoSobrevivieron)
      ..writeByte(6)
      ..write(obj.cerditosImportados)
      ..writeByte(7)
      ..write(obj.estadoVisual)
      ..writeByte(8)
      ..write(obj.hasDado);
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

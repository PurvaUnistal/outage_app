// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PipelineModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PipelineDataAdapter extends TypeAdapter<PipelineData> {
  @override
  final int typeId = 0;

  @override
  PipelineData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PipelineData(
      gid: fields[0] as String?,
      nominaldia: fields[1] as String?,
      geomencode: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PipelineData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.gid)
      ..writeByte(1)
      ..write(obj.nominaldia)
      ..writeByte(2)
      ..write(obj.geomencode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PipelineDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

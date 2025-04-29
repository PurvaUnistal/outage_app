// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RegulatorGISModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RegulatorGISDataAdapter extends TypeAdapter<RegulatorGISData> {
  @override
  final int typeId = 3;

  @override
  RegulatorGISData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegulatorGISData(
      id: fields[0] as String?,
      latitude: fields[1] as String?,
      longitude: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RegulatorGISData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegulatorGISDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

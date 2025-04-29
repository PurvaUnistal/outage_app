// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ValveGISModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ValveGISDataAdapter extends TypeAdapter<ValveGISData> {
  @override
  final int typeId = 2;

  @override
  ValveGISData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ValveGISData(
      id: fields[0] as String?,
      longitude: fields[1] as String?,
      latitude: fields[2] as String?,
      valveId: fields[3] as String?,
      gridId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ValveGISData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.valveId)
      ..writeByte(4)
      ..write(obj.gridId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValveGISDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TFGISModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TFGISDataAdapter extends TypeAdapter<TFGISData> {
  @override
  final int typeId = 1;

  @override
  TFGISData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TFGISData(
      id: fields[0] as String?,
      latitude: fields[1] as String?,
      longitude: fields[2] as String?,
      tfNumber: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TFGISData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.tfNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TFGISDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

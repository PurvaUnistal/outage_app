// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ConsumerGISModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConsumerGISDataAdapter extends TypeAdapter<ConsumerGISData> {
  @override
  final int typeId = 4;

  @override
  ConsumerGISData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConsumerGISData(
      id: fields[0] as String?,
      bpName: fields[1] as String?,
      bpNumber: fields[2] as String?,
      legacyNo: fields[3] as String?,
      latitude: fields[4] as String?,
      longitude: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ConsumerGISData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bpName)
      ..writeByte(2)
      ..write(obj.bpNumber)
      ..writeByte(3)
      ..write(obj.legacyNo)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsumerGISDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

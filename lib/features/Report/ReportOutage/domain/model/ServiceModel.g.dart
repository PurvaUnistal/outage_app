// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ServiceModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceDataAdapter extends TypeAdapter<ServiceData> {
  @override
  final int typeId = 7;

  @override
  ServiceData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceData(
      id: fields[0] as String?,
      servicePointId: fields[1] as String?,
      latitude: fields[2] as String?,
      longitude: fields[3] as String?,
      location: fields[4] as String?,
      district: fields[5] as String?,
      nominaldia: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.servicePointId)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.district)
      ..writeByte(6)
      ..write(obj.nominaldia);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

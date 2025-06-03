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
      nominaldia: fields[3] as String?,
      contractor: fields[4] as String?,
      name: fields[5] as String?,
      location: fields[6] as String?,
      district: fields[7] as String?,
      imagePath: fields[9] as String?,
      housePhoto: fields[10] as String?,
      attachFile: fields[11] as String?,
      bpName: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RegulatorGISData obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.nominaldia)
      ..writeByte(4)
      ..write(obj.contractor)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.district)
      ..writeByte(9)
      ..write(obj.imagePath)
      ..writeByte(10)
      ..write(obj.housePhoto)
      ..writeByte(11)
      ..write(obj.attachFile)
      ..writeByte(12)
      ..write(obj.bpName);
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

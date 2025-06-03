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
      nominaldia: fields[5] as String?,
      contractor: fields[6] as String?,
      name: fields[7] as String?,
      location: fields[8] as String?,
      district: fields[9] as String?,
      imagePath: fields[10] as String?,
      housePhoto: fields[11] as String?,
      attachFile: fields[12] as String?,
      bpName: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ValveGISData obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.valveId)
      ..writeByte(4)
      ..write(obj.gridId)
      ..writeByte(5)
      ..write(obj.nominaldia)
      ..writeByte(6)
      ..write(obj.contractor)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.district)
      ..writeByte(10)
      ..write(obj.imagePath)
      ..writeByte(11)
      ..write(obj.housePhoto)
      ..writeByte(12)
      ..write(obj.attachFile)
      ..writeByte(13)
      ..write(obj.bpName);
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

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
      nominaldia: fields[4] as String?,
      contractor: fields[5] as String?,
      name: fields[6] as String?,
      location: fields[7] as String?,
      district: fields[8] as String?,
      imagePath: fields[9] as String?,
      housePhoto: fields[10] as String?,
      attachFile: fields[11] as String?,
      bpName: fields[12] as String?,
      assetid: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TFGISData obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.tfNumber)
      ..writeByte(4)
      ..write(obj.nominaldia)
      ..writeByte(5)
      ..write(obj.contractor)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.district)
      ..writeByte(9)
      ..write(obj.imagePath)
      ..writeByte(10)
      ..write(obj.housePhoto)
      ..writeByte(11)
      ..write(obj.attachFile)
      ..writeByte(12)
      ..write(obj.bpName)
      ..writeByte(13)
      ..write(obj.assetid);
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommercialModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommercialDataAdapter extends TypeAdapter<CommercialData> {
  @override
  final int typeId = 4;

  @override
  CommercialData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommercialData(
      imagePath: fields[0] as String?,
      housePhoto: fields[2] as String?,
      attachFile: fields[1] as String?,
      id: fields[3] as String?,
      bpName: fields[4] as String?,
      bpNumber: fields[5] as String?,
      legacyNo: fields[6] as String?,
      latitude: fields[7] as String?,
      longitude: fields[8] as String?,
      nominaldia: fields[9] as String?,
      contractor: fields[10] as String?,
      name: fields[11] as String?,
      location: fields[12] as String?,
      district: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CommercialData obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.imagePath)
      ..writeByte(1)
      ..write(obj.attachFile)
      ..writeByte(2)
      ..write(obj.housePhoto)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.bpName)
      ..writeByte(5)
      ..write(obj.bpNumber)
      ..writeByte(6)
      ..write(obj.legacyNo)
      ..writeByte(7)
      ..write(obj.latitude)
      ..writeByte(8)
      ..write(obj.longitude)
      ..writeByte(9)
      ..write(obj.nominaldia)
      ..writeByte(10)
      ..write(obj.contractor)
      ..writeByte(11)
      ..write(obj.name)
      ..writeByte(12)
      ..write(obj.location)
      ..writeByte(13)
      ..write(obj.district);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommercialDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

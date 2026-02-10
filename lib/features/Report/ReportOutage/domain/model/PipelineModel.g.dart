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
      geomencode: fields[0] as String?,
      gid: fields[1] as String?,
      districtI: fields[2] as String?,
      nominaldia: fields[3] as String?,
      contractor: fields[4] as String?,
      name: fields[5] as String?,
      location: fields[6] as String?,
      district: fields[7] as String?,
      imagePath: fields[8] as String?,
      housePhoto: fields[9] as String?,
      attachFile: fields[10] as String?,
      bpName: fields[11] as String?,
      latitude: fields[12] as String?,
      longitude: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PipelineData obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.geomencode)
      ..writeByte(1)
      ..write(obj.gid)
      ..writeByte(2)
      ..write(obj.districtI)
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
      ..writeByte(8)
      ..write(obj.imagePath)
      ..writeByte(9)
      ..write(obj.housePhoto)
      ..writeByte(10)
      ..write(obj.attachFile)
      ..writeByte(11)
      ..write(obj.bpName)
      ..writeByte(12)
      ..write(obj.latitude)
      ..writeByte(13)
      ..write(obj.longitude);
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

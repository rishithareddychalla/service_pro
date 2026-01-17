// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceRequestAdapter extends TypeAdapter<ServiceRequest> {
  @override
  final int typeId = 0;

  @override
  ServiceRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceRequest(
      id: fields[0] as String,
      category: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      date: fields[4] as DateTime,
      status: fields[5] as String,
      imagePath: fields[6] as String?,
      address: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceRequest obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

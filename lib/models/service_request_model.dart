import 'package:hive/hive.dart';

part 'service_request_model.g.dart';

@HiveType(typeId: 0)
class ServiceRequest extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final String? imagePath;

  @HiveField(7)
  final String? address;

  ServiceRequest({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    this.imagePath,
    this.address,
  });
}

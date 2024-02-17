import 'package:hive/hive.dart';

part 'theme_model.g.dart'; // Bu dosya build_runner tarafından otomatik olarak oluşturulacak

@HiveType(typeId: 1) // typeId her model için benzersiz olmalıdır
class ThemeModel {
  @HiveField(0)
  final bool isDarkMode;

  ThemeModel({required this.isDarkMode});
}

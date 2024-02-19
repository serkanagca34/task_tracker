import 'package:hive/hive.dart';

part 'theme_model.g.dart';

@HiveType(typeId: 1)
class ThemeModel {
  @HiveField(0)
  final bool isDarkMode;

  ThemeModel({required this.isDarkMode});
}

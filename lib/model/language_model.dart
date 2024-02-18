import 'package:hive/hive.dart';

part 'language_model.g.dart';

@HiveType(typeId: 2)
class LanguageModel {
  @HiveField(0)
  final String languageCode;

  LanguageModel({required this.languageCode});
}

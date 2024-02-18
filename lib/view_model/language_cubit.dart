import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit()
      : super(
          Locale(
            Hive.box<String>('settings')
                    .get('languageCode', defaultValue: 'en') ??
                'en',
            Hive.box<String>('settings')
                    .get('countryCode', defaultValue: 'US') ??
                'US',
          ),
        );

  void toggleLanguage() {
    final box = Hive.box<String>('settings');
    final currentLocale = state;

    final newLanguageCode = currentLocale.languageCode == 'en' ? 'tr' : 'en';
    final newCountryCode = currentLocale.countryCode == 'US' ? 'TR' : 'US';

    box.put('languageCode', newLanguageCode);
    box.put('countryCode', newCountryCode);

    emit(Locale(newLanguageCode, newCountryCode));
  }
}

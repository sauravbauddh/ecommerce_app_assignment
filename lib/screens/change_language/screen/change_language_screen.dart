import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

class LanguageSwitcherView extends StatelessWidget {
  const LanguageSwitcherView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('change_language')),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('select_language'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildLanguageCard(
              context: context,
              title: 'English',
              nativeTitle: 'English',
              locale: const Locale('en'),
              isSelected: currentLocale == 'en',
              flagEmoji: '🇬🇧',
            ),
            const SizedBox(height: 12),
            _buildLanguageCard(
              context: context,
              title: 'Hindi',
              nativeTitle: 'हिंदी',
              locale: const Locale('hi'),
              isSelected: currentLocale == 'hi',
              flagEmoji: '🇮🇳',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required BuildContext context,
    required String title,
    required String nativeTitle,
    required Locale locale,
    required bool isSelected,
    required String flagEmoji,
  }) {
    return Card(
      elevation: isSelected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          context.setLocale(locale);
          Get.updateLocale(locale);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      flagEmoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          nativeTitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Selected Indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
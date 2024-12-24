import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskorganizer/app/modules/settings_page/settings_controller.dart';
import 'package:taskorganizer/app/routes/app_pages.dart';
import 'package:taskorganizer/app/theme/app_colors.dart';
import 'package:taskorganizer/generated/locales.g.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  Widget _buildRadioOption(ThemeMode value, String label) {
    return GestureDetector(
      onTap: () {
        controller.onThemeModeChanged(value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<ThemeMode>(
            value: value,
            groupValue: controller.currentMode.value,
            onChanged: (value) {
              if (value != null) controller.onThemeModeChanged(value);
            },
          ),
          Text(
            label,
            style: Get.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String languageCode, String label) {
    return GestureDetector(
      onTap: () {
        controller.onLanguageChanged(languageCode);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: languageCode,
            groupValue: controller.languageCode.value,
            onChanged: (value) {
              if (value != null) controller.onLanguageChanged(value);
            },
          ),
          Text(
            label,
            style: Get.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.offAndToNamed(Routes.HOME),
          icon: Icon(Icons.arrow_back_sharp),
        ),
        title: Text(
          LocaleKeys.settings.tr,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Obx(
        () => ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: [
            const SizedBox(height: 20),
            Wrap(
              spacing: 100,
              runSpacing: 10,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.theme.tr,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    _buildRadioOption(
                        ThemeMode.light, LocaleKeys.lightTheme.tr),
                    _buildRadioOption(ThemeMode.dark, LocaleKeys.darkTheme.tr),
                    _buildRadioOption(
                        ThemeMode.system, LocaleKeys.systemTheme.tr),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.language.tr,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    _buildLanguageOption('en', LocaleKeys.english.tr),
                    _buildLanguageOption('ru', LocaleKeys.russian.tr),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.email.tr,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      controller.authServices.getCurrentAuthUser()!.email!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => controller.logout(),
                          child: Text(
                            LocaleKeys.logout.tr,
                            style: TextStyle(color: AppColors.iconDark),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => controller.deleteAccount(),
                          child: Text(
                            LocaleKeys.deleteAccount.tr,
                            style: TextStyle(color: AppColors.iconDark),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

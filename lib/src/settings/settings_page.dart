import 'package:flutter/material.dart';
import 'package:last_breath/src/settings/settings_controller.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settingsProvider, _) {
        return ListView(
          children: [
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: settingsProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  settingsProvider.updateThemeMode(
                      value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),
            ListTile(
              title: const Text('About Last Breath'),
              onTap: () {
                // Add your logic to handle the account settings here
              },
            ),
            ListTile(
              title: const Text('Allow notifications'),
              trailing: Switch(
                value: settingsProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  settingsProvider.updateThemeMode(
                      value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),
            ListTile(
              title: const Text('Do Not Disturb'),
              onTap: () {
                // Add your logic to handle the privacy settings here
              },
            ),
            // Add more ListTile widgets for additional settings
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<Widget> getOpenAppSettingsActions() {
    return [
      ListTile(
        title: const Text("Location"),
        onTap: () => AppSettings.openAppSettings(type: AppSettingsType.location),
      ),
      ListTile(
        title: const Text("Security"),
        onTap: () => AppSettings.openAppSettings(type: AppSettingsType.security),
      ),

      ListTile(
        title: const Text("App Settings"),
        onTap: () => AppSettings.openAppSettings(type: AppSettingsType.settings),
      ),
      ListTile(
        title: const Text("Display"),
        onTap: () => AppSettings.openAppSettings(type: AppSettingsType.display),
      ),
      ListTile(
        title: const Text("Notification"),
        onTap: () => AppSettings.openAppSettings(type: AppSettingsType.notification),
      ),
      ListTile(
        title: const Text("Internal Storage"),
        onTap: () => AppSettings.openAppSettings(type: AppSettingsType.internalStorage),
      ),
      ListTile(
        title: const Text("Battery optimization"),
        onTap: () => AppSettings.openAppSettings(type: AppSettingsType.batteryOptimization),
      ),
      ListTile(
        title: const Text("Device Settings"),
        onTap: () => AppSettings.openAppSettings(type: AppSettingsType.device, asAnotherTask: true),
      ),
      ListTile(
        title: const Text("Accessibility"),
        onTap: () => AppSettings.openAppSettings(type: AppSettingsType.accessibility, asAnotherTask: true),
      ),
    ];
  }
  List<Widget> getOpenAppSettingsPanelActions() {
    return [
      ListTile(
        title: const Text('Wifi'),
        minVerticalPadding: 5.0,
        onTap: () => AppSettings.openAppSettingsPanel(AppSettingsPanelType.wifi),
      ),
      ListTile(
        title: const Text('Internet connectivity'),
        onTap: () => AppSettings.openAppSettingsPanel(AppSettingsPanelType.internetConnectivity),
      ),
      ListTile(
        title: const Text('Volume'),
        onTap: () => AppSettings.openAppSettingsPanel(AppSettingsPanelType.volume),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appSettingsActions = getOpenAppSettingsActions();
    final appSettingsPanelActions = getOpenAppSettingsPanelActions();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading:  BackButton(
            onPressed: () =>  Navigator.pop(context)
          ),
          title: const Text('Settings '),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: CustomScrollView(
          slivers: [

            SliverList(
              delegate: SliverChildListDelegate.fixed(appSettingsActions),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(appSettingsPanelActions),
            ),
          ],
        ),
      ),
    );
  }
}
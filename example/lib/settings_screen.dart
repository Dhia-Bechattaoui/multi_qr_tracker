import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _scanMode = 'auto';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Scanner Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Show scan notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: const Text('Sound'),
            subtitle: const Text('Play sound on scan'),
            value: _soundEnabled,
            onChanged: (bool value) {
              setState(() {
                _soundEnabled = value;
              });
            },
            secondary: const Icon(Icons.volume_up),
          ),
          SwitchListTile(
            title: const Text('Vibration'),
            subtitle: const Text('Vibrate on scan'),
            value: _vibrationEnabled,
            onChanged: (bool value) {
              setState(() {
                _vibrationEnabled = value;
              });
            },
            secondary: const Icon(Icons.vibration),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Scan Mode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(
                  value: 'auto',
                  label: Text('Automatic'),
                  tooltip: 'Scan automatically after 2 seconds',
                ),
                ButtonSegment<String>(
                  value: 'manual',
                  label: Text('Manual'),
                  tooltip: 'Press button to scan',
                ),
              ],
              selected: {_scanMode},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _scanMode = newSelection.first;
                });
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Automatic: Scan automatically after 2 seconds\n'
              'Manual: Press button to scan',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'About',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Version'),
            subtitle: const Text('0.5.0'),
            leading: const Icon(Icons.info),
          ),
          ListTile(
            title: const Text('Camera Status'),
            subtitle: const Text('Camera is paused when this screen is open'),
            leading: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Scanner'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

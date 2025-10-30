import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _dailyReminder = true;
  String _reminderTime = '08:00 AM';
  double _audioVolume = 0.8;
  double _playbackSpeed = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Notifications'),
            const SizedBox(height: 12),
            _buildToggleSetting(
              'Enable Notifications',
              _notificationsEnabled,
              (value) {
                setState(() => _notificationsEnabled = value);
              },
            ),
            if (_notificationsEnabled) ...[
              const SizedBox(height: 12),
              _buildToggleSetting(
                'Daily Reminder',
                _dailyReminder,
                (value) {
                  setState(() => _dailyReminder = value);
                },
              ),
              if (_dailyReminder) ...[
                const SizedBox(height: 12),
                _buildTimeSetting(),
              ],
            ],
            const SizedBox(height: 24),
            _buildSectionHeader('Audio Settings'),
            const SizedBox(height: 12),
            _buildAudioVolumeSetting(),
            const SizedBox(height: 16),
            _buildPlaybackSpeedSetting(),
            const SizedBox(height: 24),
            _buildSectionHeader('Content'),
            const SizedBox(height: 12),
            _buildContentButton(),
            const SizedBox(height: 24),
            _buildSectionHeader('Languages'),
            const SizedBox(height: 12),
            _buildLanguagesButton(),
            const SizedBox(height: 24),
            _buildSectionHeader('About'),
            const SizedBox(height: 12),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildToggleSetting(String title, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSetting() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Reminder Time'),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Time picker coming soon!')),
              );
            },
            child: Text(
              _reminderTime,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioVolumeSetting() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Volume'),
              Text(
                '${(_audioVolume * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: _audioVolume,
            onChanged: (value) {
              setState(() => _audioVolume = value);
            },
            min: 0,
            max: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaybackSpeedSetting() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Playback Speed'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (double speed in [0.75, 1.0, 1.25, 1.5])
                GestureDetector(
                  onTap: () {
                    setState(() => _playbackSpeed = speed);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _playbackSpeed == speed
                          ? Colors.blue
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${speed}x',
                      style: TextStyle(
                        color: _playbackSpeed == speed
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentButton() {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Checking for content updates...'),
          ),
        );
      },
      icon: const Icon(Icons.download),
      label: const Text('Check for Content Updates'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
      ),
    );
  }

  Widget _buildLanguagesButton() {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Language selection coming soon!')),
        );
      },
      icon: const Icon(Icons.language),
      label: const Text('Change Learning Languages'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Indian Language Learning App',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Version 1.0.0',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          const Text(
            'A gamified platform to learn Hindi and Telugu with interactive lessons, exercises, and progress tracking.',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy Policy')),
                  );
                },
                child: const Text('Privacy'),
              ),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Terms of Service')),
                  );
                },
                child: const Text('Terms'),
              ),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contact us')),
                  );
                },
                child: const Text('Contact'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

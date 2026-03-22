import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_xtream/core/theme/app_theme.dart';
import 'package:stream_xtream/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stream_xtream/features/auth/presentation/bloc/auth_event.dart';
import 'xtream_config_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _videoQuality = 'Auto';
  String _subtitleLanguage = 'English';
  bool _autoplayNext = true;
  bool _downloadWifiOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Account Section
          _SectionHeader(title: 'Account'),
          _SettingsTile(
            icon: Icons.settings_input_hdmi,
            title: 'Xtream Server',
            subtitle: 'Configure server connection',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const XtreamConfigPage(),
                ),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.person_outline,
            title: 'Profile',
            subtitle: 'Manage profiles',
            onTap: () {
              // Navigate to profiles
            },
          ),
          _SettingsTile(
            icon: Icons.history,
            title: 'Watch History',
            subtitle: 'View your watch history',
            onTap: () {
              // Navigate to watch history
            },
          ),
          _SettingsTile(
            icon: Icons.favorite_border,
            title: 'My List',
            subtitle: 'View your saved content',
            onTap: () {
              // Navigate to favorites
            },
          ),

          // Playback Section
          _SectionHeader(title: 'Playback'),
          _SettingsTile(
            icon: Icons.high_quality,
            title: 'Video Quality',
            subtitle: _videoQuality,
            onTap: () {
              _showVideoQualityDialog();
            },
          ),
          _SettingsTile(
            icon: Icons.subtitles,
            title: 'Subtitle Language',
            subtitle: _subtitleLanguage,
            onTap: () {
              _showSubtitleLanguageDialog();
            },
          ),
          _SettingsSwitch(
            icon: Icons.skip_next,
            title: 'Autoplay Next Episode',
            subtitle: 'Automatically play the next episode',
            value: _autoplayNext,
            onChanged: (value) {
              setState(() {
                _autoplayNext = value;
              });
            },
          ),

          // Downloads Section
          _SectionHeader(title: 'Downloads'),
          _SettingsSwitch(
            icon: Icons.wifi,
            title: 'Download on Wi-Fi Only',
            subtitle: 'Only download content when connected to Wi-Fi',
            value: _downloadWifiOnly,
            onChanged: (value) {
              setState(() {
                _downloadWifiOnly = value;
              });
            },
          ),
          _SettingsTile(
            icon: Icons.delete_outline,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            onTap: () {
              _showClearCacheDialog();
            },
          ),

          // App Section
          _SectionHeader(title: 'App'),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () {
              _showAboutDialog();
            },
          ),
          _SettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help with StreamXtream',
            onTap: () {
              // Navigate to help
            },
          ),

          // Logout
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                _showLogoutDialog();
              },
              icon: const Icon(Icons.logout, color: AppTheme.errorColor),
              label: const Text(
                'Sign Out',
                style: TextStyle(color: AppTheme.errorColor),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.errorColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  void _showVideoQualityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Video Quality'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Auto', '4K', '1080p', '720p', '480p'].map((quality) {
            return RadioListTile<String>(
              title: Text(quality),
              value: quality,
              groupValue: _videoQuality,
              onChanged: (value) {
                setState(() {
                  _videoQuality = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSubtitleLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Subtitle Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Spanish', 'French', 'German', 'None'].map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: _subtitleLanguage,
              onChanged: (value) {
                setState(() {
                  _subtitleLanguage = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear all cached images and data. You may need to re-download some content.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('StreamXtream'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'A premium streaming platform with Xtream support for high-quality video playback including 4K, Dolby Vision, and HDR10+.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            SizedBox(height: 16),
            Text(
              '© 2024 StreamXtream',
              style: TextStyle(color: AppTheme.textHint),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppTheme.textSecondary),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textHint),
      onTap: onTap,
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const _SettingsSwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppTheme.textSecondary),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppTheme.textSecondary),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryColor,
    );
  }
}

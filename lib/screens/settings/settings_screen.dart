import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/themes/app_theme.dart';
import '../../engine/engine.dart' as engine;
import '../../models/models.dart' as models;
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../storage/storage_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: settingsAsync.when(
        data: (settings) => _buildSettingsList(theme, settings),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildSettingsList(ThemeData theme, models.Settings settings) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(theme, 'Audio'),
          _buildAudioSettings(theme, settings),
          SizedBox(height: 24.h),
          _buildSectionHeader(theme, 'Gameplay'),
          _buildGameplaySettings(theme, settings),
          SizedBox(height: 24.h),
          _buildSectionHeader(theme, 'Visual'),
          _buildVisualSettings(theme, settings),
          SizedBox(height: 24.h),
          _buildSectionHeader(theme, 'Controls'),
          _buildControlSettings(theme, settings),
          SizedBox(height: 24.h),
          _buildSectionHeader(theme, 'Appearance'),
          _buildAppearanceSettings(theme, settings),
          SizedBox(height: 24.h),
          _buildSectionHeader(theme, 'Advanced'),
          _buildAdvancedSettings(theme, settings),
          SizedBox(height: 32.h),
          _buildDangerZone(theme),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAudioSettings(ThemeData theme, models.Settings settings) {
    return SettingsCard(
      children: [
        SettingsTile(
          leading: Icon(settings.soundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded, color: theme.colorScheme.primary),
          title: 'Sound Effects',
          subtitle: 'Play sound effects during gameplay',
          trailing: Switch(
            value: settings.soundEnabled,
            onChanged: (value) => ref.read(settingsNotifierProvider.notifier).updateSettings(
              settings.copyWith(soundEnabled: value),
            ),
          ),
        ),
        SettingsTile(
          leading: Icon(settings.musicEnabled ? Icons.music_note_rounded : Icons.music_off_rounded, color: theme.colorScheme.primary),
          title: 'Background Music',
          subtitle: 'Play background music during gameplay',
          trailing: Switch(
            value: settings.musicEnabled,
            onChanged: (value) => ref.read(settingsNotifierProvider.notifier).updateSettings(
              settings.copyWith(musicEnabled: value),
            ),
          ),
        ),
        if (settings.soundEnabled) ...[
          SettingsTile(
            leading: Icon(Icons.tune_rounded, color: theme.colorScheme.primary),
            title: 'Sound Volume',
            subtitle: '${(settings.soundVolume * 100).round()}%',
            trailing: SizedBox(
              width: 150.w,
              child: Slider(
                value: settings.soundVolume,
                onChanged: (value) => ref.read(settingsNotifierProvider.notifier).setSoundVolume(value),
                min: 0.0,
                max: 1.0,
                divisions: 20,
              ),
            ),
          ),
        ],
        if (settings.musicEnabled) ...[
          SettingsTile(
            leading: Icon(Icons.music_note_rounded, color: theme.colorScheme.primary),
            title: 'Music Volume',
            subtitle: '${(settings.musicVolume * 100).round()}%',
            trailing: SizedBox(
              width: 150.w,
              child: Slider(
                value: settings.musicVolume,
                onChanged: (value) => ref.read(settingsNotifierProvider.notifier).setMusicVolume(value),
                min: 0.0,
                max: 1.0,
                divisions: 20,
              ),
            ),
          ),
        ],
        SettingsTile(
          leading: Icon(Icons.vibration_rounded, color: theme.colorScheme.primary),
          title: 'Vibration',
          subtitle: 'Vibrate on line clears and game over',
          trailing: Switch(
            value: settings.vibrationEnabled,
            onChanged: (value) => ref.read(settingsNotifierProvider.notifier).updateSettings(
              settings.copyWith(vibrationEnabled: value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameplaySettings(ThemeData theme, models.Settings settings) {
    return SettingsCard(
      children: [
        SettingsTile(
          leading: Icon(Icons.visibility_rounded, color: theme.colorScheme.primary),
          title: 'Ghost Piece',
          subtitle: 'Show where the current piece will land',
          trailing: Switch(
            value: settings.ghostPieceEnabled,
            onChanged: (value) => ref.read(settingsNotifierProvider.notifier).updateSettings(
              settings.copyWith(ghostPieceEnabled: value),
            ),
          ),
        ),
        SettingsTile(
          leading: Icon(Icons.grid_on_rounded, color: theme.colorScheme.primary),
          title: 'Grid Lines',
          subtitle: 'Show grid lines in the game area',
          trailing: Switch(
            value: settings.gridEnabled,
            onChanged: (value) => ref.read(settingsNotifierProvider.notifier).updateSettings(
              settings.copyWith(gridEnabled: value),
            ),
          ),
        ),
        SettingsTile(
          leading: Icon(Icons.skip_next_rounded, color: theme.colorScheme.primary),
          title: 'Next Piece',
          subtitle: 'Show the next piece preview',
          trailing: Switch(
            value: settings.nextPieceEnabled,
            onChanged: (value) => ref.read(settingsNotifierProvider.notifier).updateSettings(
              settings.copyWith(nextPieceEnabled: value),
            ),
          ),
        ),
        SettingsTile(
          leading: Icon(Icons.pause_circle_outline_rounded, color: theme.colorScheme.primary),
          title: 'Hold Piece',
          subtitle: 'Enable hold piece functionality',
          trailing: Switch(
            value: settings.holdPieceEnabled,
            onChanged: (value) => ref.read(settingsNotifierProvider.notifier).updateSettings(
              settings.copyWith(holdPieceEnabled: value),
            ),
          ),
        ),
        SettingsTile(
          leading: Icon(Icons.speed_rounded, color: theme.colorScheme.primary),
          title: 'Default Difficulty',
          subtitle: settings.defaultDifficulty.name.toUpperCase(),
          trailing: PopupMenuButton<engine.Difficulty>(
            initialValue: engine.Difficulty.values.firstWhere((d) => d.name == settings.defaultDifficulty.name),
            onSelected: (difficulty) => ref.read(settingsNotifierProvider.notifier).setDifficulty(difficulty),
            itemBuilder: (context) => engine.Difficulty.values.map((d) => PopupMenuItem(
              value: d,
              child: Text(d.name.toUpperCase()),
            )).toList(),
            child: Icon(Icons.arrow_drop_down_rounded, color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        SettingsTile(
          leading: Icon(Icons.auto_mode_rounded, color: theme.colorScheme.primary),
          title: 'Auto Pause',
          subtitle: 'Automatically pause when app goes to background',
          trailing: Switch(
            value: settings.autoPause,
            onChanged: (value) => ref.read(settingsNotifierProvider.notifier).updateSettings(
              settings.copyWith(autoPause: value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisualSettings(ThemeData theme, models.Settings settings) {
    return SettingsCard(
      children: [
        SettingsTile(
          leading: Icon(Icons.palette_rounded, color: theme.colorScheme.primary),
          title: 'Theme',
          subtitle: _getThemeModeName(settings.themeMode),
          trailing: PopupMenuButton<ThemeMode>(
            initialValue: settings.themeMode,
            onSelected: (mode) => ref.read(settingsNotifierProvider.notifier).setThemeMode(mode),
            itemBuilder: (context) => [
              const PopupMenuItem(value: ThemeMode.system, child: Text('System')),
              const PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
              const PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
            ],
            child: Icon(Icons.arrow_drop_down_rounded, color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        SettingsTile(
          leading: Icon(Icons.show_chart_rounded, color: theme.colorScheme.primary),
          title: 'Show FPS',
          subtitle: 'Display frames per second counter',
          trailing: Switch(
            value: settings.showFPS,
            onChanged: (value) => ref.read(settingsNotifierProvider.notifier).updateSettings(
              settings.copyWith(showFPS: value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlSettings(ThemeData theme, models.Settings settings) {
    return SettingsCard(
      children: [
        SettingsTile(
          leading: Icon(Icons.touch_app_rounded, color: theme.colorScheme.primary),
          title: 'Touch Sensitivity',
          subtitle: '${settings.touchSensitivity}%',
          trailing: SizedBox(
            width: 150.w,
            child: Slider(
              value: settings.touchSensitivity.toDouble(),
              onChanged: (value) => ref.read(settingsNotifierProvider.notifier).updateSettings(
                settings.copyWith(touchSensitivity: value.round()),
              ),
              min: 10,
              max: 100,
              divisions: 18,
            ),
          ),
        ),
        SettingsTile(
          leading: Icon(Icons.flip_rounded, color: theme.colorScheme.primary),
          title: 'Left-Handed Mode',
          subtitle: 'Swap rotation buttons for left-handed play',
          trailing: Switch(
            value: settings.leftHandedMode,
            onChanged: (value) => ref.read(settingsNotifierProvider.notifier).updateSettings(
              settings.copyWith(leftHandedMode: value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppearanceSettings(ThemeData theme, models.Settings settings) {
    return SettingsCard(
      children: [
        SettingsTile(
          leading: Icon(Icons.color_lens_rounded, color: theme.colorScheme.primary),
          title: 'Accent Color',
          subtitle: 'Coming soon - customize game colors',
          trailing: Icon(Icons.lock_rounded, color: theme.colorScheme.outline, size: 20.sp),
          onTap: null,
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings(ThemeData theme, models.Settings settings) {
    return SettingsCard(
      children: [
        SettingsTile(
          leading: Icon(Icons.delete_forever_rounded, color: theme.colorScheme.error),
          title: 'Reset Statistics',
          subtitle: 'Clear all game statistics and high scores',
          trailing: Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
          onTap: () => _showResetDialog(context),
        ),
        SettingsTile(
          leading: Icon(Icons.restore_rounded, color: theme.colorScheme.primary),
          title: 'Reset Settings',
          subtitle: 'Restore all settings to default values',
          trailing: Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
          onTap: () => _showResetSettingsDialog(context),
        ),
      ],
    );
  }

  Widget _buildDangerZone(ThemeData theme) {
    return SettingsCard(
      children: [
        SettingsTile(
          leading: Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
          title: 'Delete All Data',
          subtitle: 'Permanently delete all game data including settings, statistics, and saved games',
          trailing: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
            onPressed: () => _showDeleteAllDialog(context),
            child: const Text('DELETE'),
          ),
          onTap: null,
        ),
      ],
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Statistics?'),
        content: const Text('This will permanently delete all your game statistics and high scores. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              ref.read(statisticsNotifierProvider.notifier).reset();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Statistics reset', style: TextStyle(color: Theme.of(context).colorScheme.onError))),
              );
            },
            child: const Text('RESET'),
          ),
        ],
      ),
    );
  }

  void _showResetSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings?'),
        content: const Text('This will restore all settings to their default values.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          FilledButton(
            onPressed: () {
              ref.read(settingsNotifierProvider.notifier).updateSettings(models.Settings.defaultSettings());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Settings reset', style: TextStyle(color: Theme.of(context).colorScheme.onError))),
              );
            },
            child: const Text('RESET'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete All Data?', style: TextStyle(color: Theme.of(context).colorScheme.error)),
        content: const Text('This will permanently delete ALL game data including settings, statistics, and saved games. This action CANNOT be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () async {
              final storage = ref.read(storageServiceProvider);
              await storage.clearGameState();
              await ref.read(settingsNotifierProvider.notifier).updateSettings(models.Settings.defaultSettings());
              await ref.read(statisticsNotifierProvider.notifier).reset();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('All data deleted', style: TextStyle(color: Theme.of(context).colorScheme.onError))),
                );
              }
            },
            child: const Text('DELETE ALL'),
          ),
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const SettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Column(
        children: children.map((child) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          child: child,
        )).toList(),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(child: leading),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
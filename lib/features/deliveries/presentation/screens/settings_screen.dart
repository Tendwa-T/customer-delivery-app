import 'package:customer_delivery_app/core/theme/theme_cubit.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/widgets/section_header.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/widgets/theme_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: colorScheme.surface,
      ),
      body: ListView(
        children: [
          SectionHeader(label: 'Appearance'),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, state) => Column(
              children: [
                ThemeOptionTile(
                  title: 'System default',
                  subtitle: 'Follows your device seting',
                  icon: Icons.brightness_auto_outlined,
                  isSelected: state == ThemeMode.system,
                  onTap: () => context.read<ThemeCubit>().setSystem(),
                ),
                ThemeOptionTile(
                  title: 'Light',
                  subtitle: 'Always use light mode',
                  icon: Icons.light_mode_outlined,
                  isSelected: state == ThemeMode.light,
                  onTap: () => context.read<ThemeCubit>().setLight(),
                ),
                ThemeOptionTile(
                  title: 'Dark',
                  subtitle: 'Always use Dark Mode',
                  icon: Icons.dark_mode_outlined,
                  isSelected: state == ThemeMode.dark,
                  onTap: () => context.read<ThemeCubit>().setDark(),
                ),
                const Divider(height: 32, indent: 16, endIndent: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

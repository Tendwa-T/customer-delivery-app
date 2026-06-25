import 'package:customer_delivery_app/core/router.dart';
import 'package:customer_delivery_app/core/theme/theme.dart';
import 'package:customer_delivery_app/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<ThemeCubit>(create: (_) => ThemeCubit())],
      child: _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          title: "Delivery App",
          theme: lightTheme,
          themeMode: themeMode,
          routerConfig: appRouter,
        );
      },
    );
  }
}

import 'package:customer_delivery_app/core/navigation/app_shell.dart';
import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/screens/delivery_detail_screen.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/screens/delivery_form_screen.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/screens/delivery_list_screen.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteNames {
  const RouteNames._();
  static const String list = 'delivery-list';
  static const String detail = 'delivery-detail';
  static const String edit = 'delivery-edit';
  static const String create = 'delivery-create';
  static const String settings = 'settings';
}

class RoutePaths {
  const RoutePaths._();
  static const String list = '/deliveries';
  static const String detail = '/deliveries/:id';
  static const String edit = 'edit';
  static const String create = '/create';
  static const String settings = '/settings';

  static String fullDetail(int id) => '/deliveries/$id';
  static String fullEdit(int id) => '/deliveries/$id/edit';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _deliveriesNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'deliveries',
);
final _createNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'create');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RoutePaths.list,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _deliveriesNavigatorKey,
          routes: [
            GoRoute(
              path: RoutePaths.list,
              name: RouteNames.list,
              builder: (context, state) => const DeliveryListScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  name: RouteNames.detail,
                  builder: (context, state) {
                    final request = state.extra as DeliveryRequest?;
                    final id = int.parse(state.pathParameters['id']!);
                    return DeliveryDetailScreen(
                      deliveryId: id,
                      request: request,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: RoutePaths.edit,
                      name: RouteNames.edit,
                      builder: (context, state) {
                        final request = state.extra as DeliveryRequest?;
                        final id = int.parse(state.pathParameters['id']!);
                        return DeliveryFormScreen(
                          editId: id,
                          initialReq: request,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          navigatorKey: _createNavigatorKey,
          routes: [
            GoRoute(
              path: RoutePaths.create,
              name: RouteNames.create,
              builder: (context, state) => const DeliveryFormScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [
            GoRoute(
              path: RoutePaths.settings,
              name: RouteNames.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

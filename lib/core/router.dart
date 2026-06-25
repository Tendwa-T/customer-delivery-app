import 'package:customer_delivery_app/features/placeholder_screen.dart';
import 'package:go_router/go_router.dart';

class RouteNames {
  const RouteNames._();
  static const String list = 'delivery-list';
  static const String create = 'delivery-create';
  static const String detail = 'delivery-detail';
  static const String edit = 'delivery-edit';
}

class RoutePaths {
  const RoutePaths._();
  static const String list = '/';
  static const String create = '/create';
  static const String detail = '/delivery/:id';
  static const String edit = '/delivery/:id/edit';
}

final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.list,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RoutePaths.list,
      name: RouteNames.list,
      builder: (context, state) => PlaceholderScreen(title: RouteNames.list),
    ),
    GoRoute(
      path: RoutePaths.create,
      name: RouteNames.create,
      builder: (context, state) => PlaceholderScreen(title: RouteNames.create),
    ),

    GoRoute(
      path: RoutePaths.detail,
      name: RouteNames.detail,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return PlaceholderScreen(title: '${RouteNames.detail}: $id');
      },
      routes: [
        GoRoute(
          path: 'edit',
          name: RouteNames.edit,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return PlaceholderScreen(title: '${RouteNames.edit}: $id');
          },
        ),
      ],
    ),
  ],
);

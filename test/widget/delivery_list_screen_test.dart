import 'package:customer_delivery_app/core/theme/theme.dart';
import 'package:customer_delivery_app/core/navigation/router.dart';
import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/bloc/delivery_bloc.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/screens/delivery_list_screen.dart';
import 'package:customer_delivery_app/common/widgets/empty_state_widget.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/widgets/delivery_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:customer_delivery_app/core/bloc_observer.dart';
import '../helpers/test_helpers.dart';

void main() {
  late FakeDeliveryRequestRepository repository;
  late DeliveryBloc bloc;

  setUp(() {
    Bloc.observer = const SimpleBlocObserver();
    repository = FakeDeliveryRequestRepository();
    bloc = DeliveryBloc(repository: repository);
  });

  tearDown(() {
    bloc.close();
  });

  Widget buildTestableWidget(GoRouter router) {
    return BlocProvider<DeliveryBloc>.value(
      value: bloc,
      child: MaterialApp.router(
        routerConfig: router,
        theme: lightTheme,
      ),
    );
  }

  group('DeliveryListScreen Widget Tests', () {
    testWidgets('should display empty state widget when deliveries are empty', (WidgetTester tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DeliveryListScreen(),
          ),
        ],
      );

      bloc.add(const LoadDeliveries());
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 10)));

      await tester.pumpWidget(buildTestableWidget(router));
      await tester.pump();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text('No deliveries yet'), findsOneWidget);
    });

    testWidgets('should display delivery list and cards when loaded', (WidgetTester tester) async {
      final req = DeliveryRequest(
        id: 1,
        packageCode: 'PK-4321',
        pickUpAddress: 'Moi Avenue, Nairobi',
        deliveryAddress: 'Ngong Road, Nairobi',
        packageDescription: 'Electronics Box',
        packageWeight: 3.5,
        status: DeliveryStatus.pending,
        createdAt: DateTime.now(),
      );
      repository.deliveries.add(req);

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DeliveryListScreen(),
          ),
          GoRoute(
            path: '/detail/:id',
            name: RouteNames.detail,
            builder: (context, state) => const Scaffold(),
          ),
        ],
      );

      bloc.add(const LoadDeliveries());
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 10)));

      await tester.pumpWidget(buildTestableWidget(router));
      await tester.pump();

      expect(find.byWidgetPredicate((w) => w is ListView && w.scrollDirection == Axis.vertical), findsOneWidget);
      expect(find.byType(DeliveryCard), findsOneWidget);
      expect(find.textContaining('Moi Avenue'), findsWidgets);
      expect(find.text('Electronics Box'), findsOneWidget);
    });
  });
}

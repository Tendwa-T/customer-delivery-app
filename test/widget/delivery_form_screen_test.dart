import 'package:customer_delivery_app/core/theme/theme.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/bloc/delivery_bloc.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/screens/delivery_form_screen.dart';
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

  group('DeliveryFormScreen Widget Tests', () {
    testWidgets('should display validation errors when fields are empty and submitted', (WidgetTester tester) async {
      final router = GoRouter(
        initialLocation: '/create',
        routes: [
          GoRoute(
            path: '/create',
            builder: (context, state) => const DeliveryFormScreen(),
          ),
        ],
      );

      await tester.pumpWidget(buildTestableWidget(router));
      await tester.pumpAndSettle();

      final submitButton = find.byType(FilledButton);
      expect(submitButton, findsOneWidget);

      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.textContaining('required'), findsWidgets);
    });

    testWidgets('should successfully submit form when inputs are valid', (WidgetTester tester) async {
      final router = GoRouter(
        initialLocation: '/create',
        routes: [
          GoRoute(
            path: '/create',
            builder: (context, state) => const DeliveryFormScreen(),
          ),
          GoRoute(
            path: '/list',
            name: 'delivery-list',
            builder: (context, state) => const Scaffold(body: Text('Deliveries List')),
          ),
        ],
      );

      await tester.pumpWidget(buildTestableWidget(router));
      await tester.pumpAndSettle();

      final pickupField = find.byType(TextFormField).at(0);
      await tester.ensureVisible(pickupField);
      await tester.enterText(pickupField, '123 Tom Mboya St');

      final deliveryField = find.byType(TextFormField).at(1);
      await tester.ensureVisible(deliveryField);
      await tester.enterText(deliveryField, '45 Ngong Rd');

      final descField = find.byType(TextFormField).at(2);
      await tester.ensureVisible(descField);
      await tester.enterText(descField, 'Box of supplies');

      final weightField = find.byType(TextFormField).at(3);
      await tester.ensureVisible(weightField);
      await tester.enterText(weightField, '2.0');

      await tester.pump();

      final submitButton = find.byType(FilledButton);
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);

      // Run BLoC transitions and repository database calls on the real event loop:
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 50)));

      // Settle GoRouter navigation and SnackBar rendering
      await tester.pumpAndSettle();

      expect(find.text('Deliveries List'), findsOneWidget);
    });
  });
}

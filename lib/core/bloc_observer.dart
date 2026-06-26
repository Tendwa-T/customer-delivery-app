import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  const SimpleBlocObserver();

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    print('--- Bloc Transition ---');
    print('Bloc: ${bloc.runtimeType}');
    print('Event: ${transition.event}');
    print('Current State: ${transition.currentState}');
    print('Next State: ${transition.nextState}');
    print('----------------------');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    print('--- Bloc Error ---');
    print('Bloc: ${bloc.runtimeType}');
    print('Error: $error');
    print('StackTrace: $stackTrace');
    print('-----------------');
    super.onError(bloc, error, stackTrace);
  }
}

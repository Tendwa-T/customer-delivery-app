import 'package:customer_delivery_app/app.dart';
import 'package:customer_delivery_app/core/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const SimpleBlocObserver();

  runApp(const DeliveryApp());
}

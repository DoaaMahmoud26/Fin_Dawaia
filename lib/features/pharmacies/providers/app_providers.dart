import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/invontery_service.dart';
import '../../../core/services/notiications_service.dart';
import '../../../core/services/pharmacy_service.dart';
import '../../../core/services/requests_sevice.dart';
import 'navigation_providers.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: InventoryService.instance),
        ChangeNotifierProvider.value(value: PharmacyService.instance),
        ChangeNotifierProvider.value(value: RequestsService.instance),
        ChangeNotifierProvider(create: (_) => NotificationsService()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: child,
    );
  }
}

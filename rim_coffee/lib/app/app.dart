import 'package:flutter/material.dart';

import 'app_router.dart';
import 'route_names.dart';
import 'theme.dart';

class RimCoffeeApp extends StatelessWidget {
  const RimCoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rim Coffee',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      initialRoute: Routes.launcher,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

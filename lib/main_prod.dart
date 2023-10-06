import 'package:flutter/material.dart';
import 'package:trashcash_app/app_config.dart';
import 'core/router/app_router.dart';

void main() async {
  AppConfig.create(
    appName: "TrashCash App Prod",
    baseUrl: "",
    primaryColor: Colors.green,
    flavor: Flavor.prod,
  );
  runApp(
      MaterialApp.router(
        routerConfig: AppRouter.returnRouter(),

    ),
  );
}

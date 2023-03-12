// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:aumae_tracker/screens/testingPage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:aumae_tracker/models/favorites.dart';
import 'package:aumae_tracker/screens/vehiclePage.dart';
import 'package:aumae_tracker/screens/home.dart';
import 'package:aumae_tracker/Database/database.dart';
import 'package:aumae_tracker/Forms/addExpense.dart';

final dbHelper = DatabaseHelper();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();
  runApp(const TestingApp());
}

GoRouter router() {
  return GoRouter(
    routes: [
      GoRoute(
        path: HomePage.routeName,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: testingPage.routeName,
            builder: (context, state) => const testingPage(),
          ),
          GoRoute(
            path: VehiclesPage.routeName,
            builder: (context, state) => const VehiclesPage(),
          ),
          GoRoute(
            path: addExpensePage.routeName,
            builder: (context, state) => addExpensePage(),
          ),
        ],
      ),
    ],
  );
}

class TestingApp extends StatelessWidget {
  const TestingApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Favorites>(
      create: (context) => Favorites(),
      child: MaterialApp.router(
        title: 'Testing Sample',
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        routerConfig: router(),
      ),
    );
  }
}

// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:aumae_tracker/models/favorites.dart';
import 'package:aumae_tracker/screens/favorites.dart';
import 'package:aumae_tracker/screens/home.dart';
import 'package:aumae_tracker/Database/database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
            path: FavoritesPage.routeName,
            builder: (context, state) => const FavoritesPage(),
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

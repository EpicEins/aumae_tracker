import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:aumae_tracker/models/favorites.dart';
import 'package:aumae_tracker/screens/vehiclePage.dart';
import 'package:aumae_tracker/Database/database.dart';

import '../main.dart';
import 'package:uuid/uuid.dart';

class testingPage extends StatelessWidget {
  static const routeName = 'testing_page';
  static const fullPath = '/$routeName';

  const testingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Sample'),
        actions: [
          TextButton.icon(
            onPressed: () {
              context.go(VehiclesPage.fullPath);
            },
            icon: const Icon(Icons.favorite_border),
            label: const Text('Favorites'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insert,
              child: const Text('insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _query,
              child: const Text('query'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('delete'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _insertVehicle,
              child: const Text('insert Vehicle'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _insertExpense,
              child: const Text('insert Expense'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _insertExpense2,
              child: const Text('insert Refuel Expense'),
            ),
          ],
        ),
      ),
    );
  }

  void _insert() async {
    var uniqueIdentifier = DateTime.now().millisecondsSinceEpoch;
    print(uniqueIdentifier);
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnAge: 23
    };
    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
  }

  void _insertVehicle() async {
    var uniqueIdentifier = DateTime.now().millisecondsSinceEpoch;
    print(uniqueIdentifier);
    // row to insert
    final id = await dbHelper.insertVehicle(vehicleList(
        vehicleNickName: "Testing",
        vehicleIdentification: uniqueIdentifier.toString(),
        vehicleMake: "Ford",
        vehicleModel: "F150",
        vehicleYear: "1999",
        vehicleOdometer: "0000",
        vehicleFuelType: "Gasoline"));
    debugPrint('inserted row id: $uniqueIdentifier');
  }
  void _insertExpense() async {
    var uniqueIdentifier = DateTime.now().millisecondsSinceEpoch;
    print(uniqueIdentifier);
    // row to insert
    final id = await dbHelper.insertExpense(expenseList(
        expenseType: "1",
        expenseVehicleIdentification: uniqueIdentifier.toString(),
        expenseName: "expenseName",
        expenseTotalCost: "150.00",
        expenseDate: uniqueIdentifier.toString(),
        expenseIdentificationNumber: uniqueIdentifier.toString()));
    debugPrint('inserted row id: $uniqueIdentifier');
  }

  void _insertExpense2() async {
    var uniqueIdentifier = DateTime
        .now()
        .millisecondsSinceEpoch;
    print(uniqueIdentifier);
    // row to insert
    final id = await dbHelper.insertExpense(expenseList(
        expenseType: "2",
        expenseVehicleIdentification: uniqueIdentifier.toString(),
        expenseTotalCost: "100.00",
        expenseFuelAmount: "20.00",
        expenseFuelCost: "2.25",
        expenseDate: uniqueIdentifier.toString(),
        expenseIdentificationNumber: uniqueIdentifier.toString()));

    debugPrint('inserted row id: $uniqueIdentifier');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }
}

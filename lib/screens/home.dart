import 'package:aumae_tracker/Forms/addExpense.dart';
import 'package:aumae_tracker/screens/testingPage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:aumae_tracker/models/favorites.dart';
import 'package:aumae_tracker/screens/vehiclePage.dart';
import 'package:aumae_tracker/Database/database.dart';

import '../main.dart';


class HomePage extends StatelessWidget {
  static const routeName = '/';

  const HomePage({super.key});

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
          TextButton.icon(
            onPressed: () {
              context.go(testingPage.fullPath);
            },
            icon: const Icon(Icons.adb),
            label: const Text('Testing'),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<expenseList>>(
          //DatabaseHelper.instance.getList()
            future: dbHelper.getExpenseList(),
            builder: (BuildContext context,
                AsyncSnapshot<List<expenseList>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              return snapshot.data!.isEmpty
                  ? Center(child: Text('No items in List'))
                  : ListView(
                children: snapshot.data!.map((expenseList) {
                  var expenseName = expenseList.expenseName;
                  var expenseTotalCost = expenseList.expenseTotalCost;
                  var expenseFuelAmount = expenseList.expenseFuelAmount;
                  var expenseFuelCost = expenseList.expenseFuelCost;
                  var expenseType = expenseList.expenseType;
                  var expenseVehicleIdentification = expenseList.expenseVehicleIdentification;
                  if(expenseType == '1') { //other expense
                    return Center(
                        child: Card(
                          child: ListTile(
                            onLongPress: () async {
                              await dbHelper.removeExpenseRecord(expenseList.id!);
                            },
                            onTap: () async {
                            },
                            contentPadding: EdgeInsets.all(5),
                            leading: Icon(Icons.local_gas_station),
                            title: Column(
                              children: [
                                Center(child: Text("Expense name: $expenseName!")),
                                Center(child: Text(expenseTotalCost)),
                              ],
                            ),

                          ),
                        ));
                  } else { //refuel expense
                    return Center(
                        child: Card(
                          child: ListTile(
                            onLongPress: () {
                            },
                            onTap: () async {
                            },
                            contentPadding: EdgeInsets.all(5),
                            leading: Icon(Icons.local_gas_station),
                            title: Column(
                              children: [
                                Center(child: Text(expenseTotalCost)),

                              ],
                            ),
                          ),
                        ));
                  }
                }).toList(),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(addExpensePage.fullPath);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.navigation),
      ),
    );
  }
}

class StatmentExample extends StatelessWidget {
  Widget build(BuildContext context) {
    return Text((() {
      if(true){
        return "tis true";}

      return "anything but true";
    })());
  }
}


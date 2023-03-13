import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aumae_tracker/models/favorites.dart';
import 'package:aumae_tracker/Database/database.dart';

import '../main.dart';

class VehiclesPage extends StatefulWidget {
  static const routeName = 'vehicles_page';
  static const fullPath = '/$routeName';

  const VehiclesPage({super.key});
  vehiclePage createState() => vehiclePage();
}

class vehiclePage extends State<VehiclesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
        ),
        body: Center(
          child: FutureBuilder<List<vehicleList>>(
            //DatabaseHelper.instance.getList()
              future: dbHelper.getVehicleList(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<vehicleList>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text('Loading...'));
                }
                return snapshot.data!.isEmpty
                    ? Center(child: Text('No items in List'))
                    : ListView(
                  children: snapshot.data!.map((vehicleList) {
                    var vehicleNickName = vehicleList.vehicleNickName;
                    var vehicleModel = vehicleList.vehicleModel;
                    var vehicleYear = vehicleList.vehicleYear;
                    return Center(
                        child: Card(
                          child: ListTile(
                            onLongPress: () async {
                              await dbHelper
                                  .removeVehicle(vehicleList.id!);
                              setState(() {
                              });
                            },
                            onTap: () async {},
                            contentPadding: EdgeInsets.all(5),
                            leading: Icon(Icons.local_gas_station),
                            title: Column(
                              children: [
                                Center(child: Text("MPG: $vehicleNickName!")),
                                Center(child: Text(vehicleModel)),
                              ],
                            ),
                          ),
                        ));
                  }).toList(),
                );
              }),
        )
    );
  }

  UnimplementedError() {
    // TODO: implement UnimplementedError
    throw UnimplementedError();
  }
}
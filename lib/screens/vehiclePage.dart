import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aumae_tracker/models/favorites.dart';
import 'package:aumae_tracker/Database/database.dart';

import '../main.dart';

class VehiclesPage extends StatelessWidget {
  static const routeName = 'vehicles_page';
  static const fullPath = '/$routeName';

  const VehiclesPage({super.key});

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
                children: snapshot.data!.map((myTableContents) {
                  var vehicleNickName = myTableContents.vehicleNickName;
                  var vehicleModel = myTableContents.vehicleModel;
                  var vehicleYear = myTableContents.vehicleYear;
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
}

class FavoriteItemTile extends StatelessWidget {
  final int itemNo;

  const FavoriteItemTile(this.itemNo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[itemNo % Colors.primaries.length],
        ),
        title: Text(
          'Item $itemNo',
          key: Key('favorites_text_$itemNo'),
        ),
        trailing: IconButton(
          key: Key('remove_icon_$itemNo'),
          icon: const Icon(Icons.close),
          onPressed: () {
            context.read<Favorites>().remove(itemNo);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Removed from favorites.'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}

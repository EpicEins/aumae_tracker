import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:aumae_tracker/main.dart' as mainDart;


class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    print("Initializing database");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // Have not used main.db for final application
    String path = join(documentsDirectory.path, 'main.db');
    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE refuelCost (id INTEGER PRIMARY KEY, carName TEXT, date TEXT, fuelCost TEXT, location TEXT, odometer TEXT, 
       amountFuel TEXT, dollarAmount TEXT, fullTankToggle TEXT, mpg TEXT, oldOdometer TEXT, fuelType TEXT, expenseUniqueID TEXT)''');
      await db.execute('''CREATE TABLE otherExpense (id INTEGER PRIMARY KEY, carName TEXT, date TEXT, location TEXT, odometer TEXT, 
       expenseName TEXT, dollarAmount TEXT, category TEXT, description TEXT, expenseUniqueID TEXT)''');
      await db.execute('''CREATE TABLE carList (id INTEGER PRIMARY KEY, name TEXT, make TEXT, model, TEXT, year TEXT, odometer TEXT, fuelType TEXT, carUniqueID TEXT)''');
    }, onUpgrade: (Database db, int oldV, int newV) async{
      try {
        await db.execute("ALTER TABLE refuelCost ADD COLUMN fuelType TEXT;");
        await db.execute("ALTER TABLE carList ADD COLUMN fuelType TEXT;");
      }catch (error){
        print(error);
      }
//      await db.execute('''DROP TABLE carList''');
//      await db.execute('''CREATE TABLE carList (id INTEGER PRIMARY KEY, name TEXT, make TEXT, model, TEXT, year TEXT, odometer TEXT)''');
      //print("carList table created");
    }

    );

  }



  Future<List<listContents>> getList() async {
    print("Shit is happening");
    Database db = await instance.database;
    var organizedContent = await db.rawQuery('SELECT * FROM refuelCost ORDER BY date DESC');
    List<listContents> groceryList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => listContents.fromMap(c)).toList()
        : [];
    return groceryList;
  }

  Future<List<otherExpenses>> getExpenseList() async {
    Database db = await instance.database;
//    var organizedContent = await db.query('otherExpense', orderBy: 'date');
    var organizedContent = await db.rawQuery('SELECT * FROM otherExpense ORDER BY date DESC');
    List<otherExpenses> groceryList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => otherExpenses.fromMap(c)).toList()
        : [];
    return groceryList;
  }

  //SELECT TOP 1 column_name FROM table_name

  Future<List<listContents>> getLastOdometer(String carID) async {
    Database db = await instance.database;
    var organizedContent = await db.rawQuery('SELECT * FROM refuelCost WHERE id = ? ORDER BY id DESC LIMIT 1', ['$carID']);
    List<listContents> groceryList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => listContents.fromMap(c)).toList()
        : [];
    print(organizedContent);
    return groceryList;
  }

  Future<List<listContents>> getFilterFuelType(String fuelType) async {
    Database db = await instance.database;
    var organizedContent = await db.rawQuery('SELECT * FROM refuelCost WHERE fuelType = ? ORDER BY id', ['$fuelType']);
    List<listContents> groceryList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => listContents.fromMap(c)).toList()
        : [];
    print(organizedContent);
    return groceryList;
  }
  Future<List<carList>> getCarList() async {
    Database db = await instance.database;
    var organizedContent = await db.query('carList', orderBy: 'id');
    List<carList> groceryList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => carList.fromMap(c)).toList()
        : [];
    return groceryList;
  }
  Future<int> add(listContents listcontents) async {
    Database db = await instance.database;
    return await db.insert('refuelCost', listcontents.toMap());
  }
  Future<int> addExpense(otherExpenses otherExpenses) async {
    Database db = await instance.database;
    return await db.insert('otherExpense', otherExpenses.toMap());
  }
  Future<int> addCar(carList carList) async {
    Database db = await instance.database;
    return await db.insert('carList', carList.toMap());
  }
  Future<int> removeRefuelRecord(int id) async {
    Database db = await instance.database;
    return await db.delete('refuelCost', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> removeExpenseRecord(int id) async {
    Database db = await instance.database;
    return await db.delete('otherExpense', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> removeCar(int id) async {
    Database db = await instance.database;
    return await db.delete('carList', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> update(listContents item) async {
    Database db = await instance.database;
    return await db.update('refuelCost', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }
  Future<int> updateOtherExpense(otherExpenses item) async {
    var itemID =  item.id;
    print("Printing itemID: $itemID");
    Database db = await instance.database;
    return await db.update('otherExpense', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }
  Future<int> updateCar(carList item) async {
    Database db = await instance.database;
    return await db.update('carList', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }
  returnDBPath() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'main2.db');
    return path;
  }
  returnDBPathiCloudDownload() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'backUP.db');
    return path;
  }
  clearDatabase() async {
    Database db = await instance.database;
    await db.execute('''DROP TABLE carList''');
    await db.execute('''DROP TABLE refuelCost''');
    await db.execute('''DROP TABLE otherExpense''');
  }
}


class DatabaseHelperBackUp {
  DatabaseHelperBackUp._privateConstructor();
  static final DatabaseHelperBackUp instance = DatabaseHelperBackUp._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'backUP.db');
    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {}, onUpgrade: (Database db, int oldV, int newV) async{}

    );

  }



  Future<List<listContents>> getList() async {
    Database db = await DatabaseHelperBackUp.instance.database;
    var organizedContent = await db.query('refuelCost', orderBy: 'id');
    List<listContents> groceryList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => listContents.fromMap(c)).toList()
        : [];
    return groceryList;
  }
  Future<List<otherExpenses>> getExpenseList() async {
    Database db = await DatabaseHelperBackUp.instance.database;
    var organizedContent = await db.query('otherExpense', orderBy: 'id');
    List<otherExpenses> groceryList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => otherExpenses.fromMap(c)).toList()
        : [];
    return groceryList;
  }

  //SELECT TOP 1 column_name FROM table_name

  Future<List<listContents>> getLastOdometer(String carName) async {
    Database db = await DatabaseHelperBackUp.instance.database;
    var organizedContent = await db.rawQuery('SELECT * FROM refuelCost WHERE carName = ? ORDER BY id DESC LIMIT 1', ['$carName']);
    List<listContents> groceryList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => listContents.fromMap(c)).toList()
        : [];
    print(organizedContent);
    return groceryList;
  }

  Future<List<carList>> getCarList() async {
    Database db = await DatabaseHelperBackUp.instance.database;
    var organizedContent = await db.query('carList', orderBy: 'id');
    List<carList> groceryList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => carList.fromMap(c)).toList()
        : [];
    return groceryList;
  }
  Future<int> add(listContents listcontents) async {
    Database db = await DatabaseHelperBackUp.instance.database;
    return await db.insert('refuelCost', listcontents.toMap());
  }
  Future<int> addExpense(otherExpenses otherExpenses) async {
    Database db = await DatabaseHelperBackUp.instance.database;
    return await db.insert('otherExpense', otherExpenses.toMap());
  }
  Future<int> addCar(carList carList) async {
    Database db = await DatabaseHelperBackUp.instance.database;
    return await db.insert('carList', carList.toMap());
  }
  Future<int> removeRefuelRecord(int id) async {
    Database db = await DatabaseHelperBackUp.instance.database;
    return await db.delete('refuelCost', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> removeExpenseRecord(int id) async {
    Database db = await DatabaseHelperBackUp.instance.database;
    return await db.delete('otherExpense', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> removeCar(int id) async {
    Database db = await DatabaseHelperBackUp.instance.database;
    return await db.delete('carList', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> update(listContents item) async {
    Database db = await DatabaseHelperBackUp.instance.database;
    return await db.update('refuelCost', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  returnDBPath() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'main1.db');
    return path;
  }
}

class rtrnpath {
  returnDBPath() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'main1.db');
    return path;
  }
}


class listContents {
  final int? id;
  final String odometer;
  final String carName;
  final String date;
  var location;
  final String dollarAmount;
  final String fuelCost;
  final String amountFuel;
  final String fullTankToggle;
  final String mpg;
  final String oldOdometer;
  var fuelType;

  listContents({this.id, required this.odometer, required this.carName,
    required this.date, required this.amountFuel, this.location, required this.fuelCost
    , required this.dollarAmount, required this.fullTankToggle, required this.mpg, required this.oldOdometer
    , this.fuelType});

  factory listContents.fromMap(Map<String, dynamic> json) => listContents(
    id: json['id'],
    odometer: json['odometer'],
    dollarAmount: json['dollarAmount'],
    date: json['date'],
    carName: json['carName'],
    location: json['location'],
    amountFuel: json['amountFuel'],
    fuelCost: json['fuelCost'],
    fullTankToggle: json['fullTankToggle'],
    mpg: json['mpg'],
    oldOdometer: json['oldOdometer'],
    fuelType: json['fuelType'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'carName' : carName,
      'dollarAmount' : dollarAmount,
      'date' : date,
      'location' : location,
      'odometer' : odometer,
      'amountFuel' : amountFuel,
      'fuelCost' : fuelCost,
      'fullTankToggle' : fullTankToggle,
      'mpg' : mpg,
      'oldOdometer' : oldOdometer,
      'fuelType' : fuelType,
    };
  }

}

class otherExpenses {
  final int? id;
  final String odometer;
  final String carName;
  final String date;
  var location;
  final String dollarAmount;
  final String category;
  final String description;
  final String expenseName;

  otherExpenses({this.id, required this.odometer, required this.carName,
    required this.date, required this.description, this.location, required this.expenseName
    , required this.dollarAmount, required this.category,});

  factory otherExpenses.fromMap(Map<String, dynamic> json) => otherExpenses(
    id: json['id'],
    odometer: json['odometer'],
    dollarAmount: json['dollarAmount'],
    date: json['date'],
    carName: json['carName'],
    location: json['location'],
    expenseName: json['expenseName'],
    category: json['category'],
    description: json['description'],

  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'carName' : carName,
      'dollarAmount' : dollarAmount,
      'date' : date,
      'location' : location,
      'odometer' : odometer,
      'description' : description,
      'expenseName' : expenseName,
      'category' : category,
    };
  }

}

class carList {
  final int? id;
  final String odometer;
  final String name;
  final String make;
  final String model;
  final String year;
  var fuelType;

  carList({this.id, required this.odometer, required this.name,
    required this.make, required this.model, required this.year, this.fuelType});

  factory carList.fromMap(Map<String, dynamic> json) => carList(
    id: json['id'],
    odometer: json['odometer'],
    name: json['name'],
    make: json['make'],
    model: json['model'],
    year: json['year'],
    fuelType: json['fuelType'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'odometer' : odometer,
      'name' : name,
      'make' : make,
      'model' : model,
      'year' : year,
      'fuelType' : fuelType,
    };
  }

}

class compareBackUptoCurrent {
  compareDatabases() async { // checks the tables within each database and then adds the entries that are missing in the current
                             // database from the backup database.
    var getListItemsBackUp = await DatabaseHelperBackUp.instance.getList(); //get backup refuel items
    var getExpenseListBackUp = await DatabaseHelperBackUp.instance.getExpenseList(); //get backup expense items
    var getCarListBackup = await DatabaseHelperBackUp.instance.getCarList(); //get backup car items
    var getExpenseListCheckList = await DatabaseHelperBackUp.instance.getExpenseList();
    var getCarListChekList = await DatabaseHelperBackUp.instance.getCarList();
    var getExpenseListCurrent = await DatabaseHelper.instance.getExpenseList();
    var getCarListCurrent = await DatabaseHelper.instance.getCarList();
    var getListItemsBackUpCheckList = await DatabaseHelperBackUp.instance.getList();
    var getListItems = await DatabaseHelper.instance.getList();
    print(getCarListCurrent);
    for (var i in getListItemsBackUp) {
      //comparing results, for each object in backUp getList, it's comaring to see if
      //normal getList has that item as well. This is to determine which items from
      //backup database need to be inserted into the normal database.
      for (var k in getListItems) {
        if (i.id.toString() == k.id.toString()) {
          if (i.odometer.toString() == k.odometer.toString()) {
            var index1 = getListItemsBackUpCheckList.indexWhere((element) => element.odometer.toString() == i.odometer.toString());
            getListItemsBackUpCheckList.removeAt(index1);
          }
        }
      }
    }
    for (var i in getExpenseListBackUp) {
      //comparing results, for each object in backUp getList, it's comaring to see if
      //normal getList has that item as well. This is to determine which items from
      //backup database need to be inserted into the normal database.
      for (var k in getExpenseListCurrent) {
        if (i.id.toString() == k.id.toString()) {
          if (i.odometer.toString() == k.odometer.toString()) {
            var index1 = getExpenseListCheckList.indexWhere((element) => element.odometer.toString() == i.odometer.toString());
            getExpenseListCheckList.removeAt(index1);
          }
        }
      }
    }
    for (var i in getCarListBackup) {
      //comparing results, for each object in backUp getList, it's comaring to see if
      //normal getList has that item as well. This is to determine which items from
      //backup database need to be inserted into the normal database.
      for (var k in getCarListCurrent) {
        if (i.id.toString() == k.id.toString()) {
          if (i.odometer.toString() == k.odometer.toString()) {
            print("Printing matching K below");
            print(k.name);
            print(k.odometer);
            print(k.model);
            print("Printing matching K above");
            var index1 = getCarListChekList.indexWhere((element) => element.odometer.toString() == i.odometer.toString());
            getCarListChekList.removeAt(index1);
          }
        }
      }
    }
    for (var i in getListItemsBackUpCheckList) {
      await DatabaseHelper.instance.add(listContents(
          odometer: i.odometer,
          carName: i.carName,
          date: i.date,
          amountFuel: i.amountFuel,
          location: i.location,
          fuelCost: i.fuelCost,
          dollarAmount: i.dollarAmount,
          fullTankToggle: i.fullTankToggle,
          mpg: i.mpg,
          oldOdometer: i.oldOdometer,
          fuelType: i.fuelType,
      ));
    }
    for (var i in getCarListChekList) {
      await DatabaseHelper.instance.addCar(carList(
          odometer: i.odometer,
          name: i.name,
          make: i.make,
          model: i.model,
          year: i.year,
          fuelType: i.fuelType,
      ));
    }
    for (var i in getExpenseListCheckList) {
      await DatabaseHelper.instance.addExpense(otherExpenses(
          odometer: i.odometer,
          carName: i.carName,
          date: i.date,
          description: i.description,
          location: i.location,
          expenseName: i.expenseName,
          dollarAmount: i.dollarAmount,
          category: i.category));
    }
    print(getCarListChekList);

  }

  restoreFromBackup() async {
    DatabaseHelper.instance.clearDatabase();
    Database db = await DatabaseHelper.instance.database;
    var getListItemsBackUpCheckList = await DatabaseHelperBackUp.instance.getList();
    var getExpenseList = await DatabaseHelperBackUp.instance.getExpenseList();
    var getCarList = await DatabaseHelperBackUp.instance.getCarList();
    for (var i in getListItemsBackUpCheckList) {
      print(i.mpg);
      await DatabaseHelper.instance.add(listContents(
          odometer: i.odometer,
          carName: i.carName,
          date: i.date,
          amountFuel: i.amountFuel,
          location: i.location,
          fuelCost: i.fuelCost,
          dollarAmount: i.dollarAmount,
          fullTankToggle: i.fullTankToggle,
          mpg: i.mpg,
          oldOdometer: i.oldOdometer,
          fuelType: i.fuelType,
      ));
    }
    for (var i in getExpenseList) {
      await DatabaseHelper.instance.addExpense(otherExpenses(
          odometer: i.odometer,
          carName: i.carName,
          date: i.date,
          description: i.description,
          location: i.location,
          expenseName: i.expenseName,
          dollarAmount: i.dollarAmount,
          category: i.category));
    }
    for (var i in getCarList) {
      await DatabaseHelper.instance.addCar(carList(
          odometer: i.odometer,
          name: i.name,
          make: i.make,
          model: i.model,
          year: i.year,
          fuelType: i.fuelType,
      ));
    }

  }
}
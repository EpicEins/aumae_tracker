import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
//*************************************************
  static const table = 'my_table';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnAge = 'age';
//*************************************************
  late Database _db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    print("Opening Database");
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    print("Creating Database");
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnAge TEXT NOT NULL
          )
          ''');
    await db.execute('''
           CREATE TABLE vehicleList (
            id INTEGER PRIMARY KEY,
            vehicleNickName TEXT, 
            vehicleIdentification TEXT,
            vehicleMake TEXT,
            vehicleModel TEXT,
            vehicleYear TEXT,
            vehicleOdometer TEXT,
            vehiclePicture TEXT,
            vehicleNotes TEXT,
            vehicleFuelType TEXT
            )
            ''');
    await db.execute('''
           CREATE TABLE expenseList (
            id INTEGER PRIMARY KEY,
            expenseType TEXT, 
            expenseVehicleIdentification TEXT,
            expenseName TEXT,
            expenseTotalCost TEXT,
            expenseFuelCost TEXT,
            expenseFuelAmount TEXT,
            expenseDate TEXT,
            expensePicture TEXT,
            expenseNotes TEXT,
            expenseIdentificationNumber TEXT
            )
            ''');
  }
  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }
  Future<int> insertVehicle(vehicleList vehicleList) async {
    return await _db.insert('vehicleList', vehicleList.toMap());
  }
  Future<int> insertExpense(expenseList expenseList) async {
    return await _db.insert('expenseList', expenseList.toMap());
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<List<myTableContents>> getList() async {
    var organizedContent = await _db.rawQuery('SELECT * FROM my_table ORDER BY _id DESC');
    List<myTableContents> myTableList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => myTableContents.fromMap(c)).toList()
        : [];
    return myTableList;
  }
  Future<List<expenseList>> getExpenseList() async {
    var organizedContent = await _db.rawQuery('SELECT * FROM expenseList ORDER BY id DESC');
    List<expenseList> myExpenseList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => expenseList.fromMap(c)).toList()
        : [];
    return myExpenseList;
  }
  Future<List<vehicleList>> getVehicleList() async {
    var organizedContent = await _db.rawQuery('SELECT * FROM vehicleList ORDER BY id DESC');
    List<vehicleList> myVehicleList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => vehicleList.fromMap(c)).toList()
        : [];
    return myVehicleList;
  }



  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
  Future<int> removeExpenseRecord(int id) async {
    return await _db.delete('expenseList', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> removeVehicle(int id) async {
    return await _db.delete('vehicleList', where: 'id = ?', whereArgs: [id]);
  }

}

class myTableContents {
  final int? id;
  final String columnName;
  final String columnAge;

  myTableContents({this.id, required this.columnName, required this.columnAge});

  factory myTableContents.fromMap(Map<String, dynamic> json) => myTableContents(
    id: json['id'],
    columnName: json['name'],
    columnAge: json['age'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name' : columnName,
      'age' : columnAge,
    };
  }

}

class vehicleList {
  final int? id;
  final String vehicleNickName;
  final String vehicleIdentification;
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleYear;
  final String vehicleOdometer;
  var vehiclePicture;
  var vehicleNotes;
  var vehicleFuelType;

  vehicleList({
    this.id,
    required this.vehicleNickName,
    required this.vehicleIdentification,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.vehicleOdometer,
    this.vehiclePicture,
    this.vehicleNotes,
    this.vehicleFuelType});

  factory vehicleList.fromMap(Map<String, dynamic> json) => vehicleList(
    id: json['id'],
    vehicleOdometer: json['vehicleOdometer'],
    vehicleNickName: json['vehicleNickName'],
    vehicleMake: json['vehicleMake'],
    vehicleModel: json['vehicleModel'],
    vehicleYear: json['vehicleYear'],
    vehicleFuelType: json['vehicleFuelType'],
    vehiclePicture: json['vehiclePicture'],
    vehicleNotes: json['vehicleNotes'],
    vehicleIdentification: json['vehicleIdentification'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'vehicleOdometer' : vehicleOdometer,
      'vehicleNickName' : vehicleNickName,
      'vehicleMake' : vehicleMake,
      'vehicleModel' : vehicleModel,
      'vehicleYear' : vehicleYear,
      'vehiclePicture' : vehiclePicture,
      'vehicleNotes' : vehicleNotes,
      'vehicleIdentification' : vehicleIdentification,
    };
  }

}

class expenseList {
  final int? id;
  final String expenseType;
  final String expenseVehicleIdentification;
  final String expenseTotalCost;
  final String expenseDate;
  final  expenseIdentificationNumber;
  var expenseFuelCost;
  var expenseFuelAmount;
  var expenseName;
  var expensePicture;
  var expenseNotes;

  expenseList({
    this.id,
    required this.expenseType,
    required this.expenseVehicleIdentification,
    required this.expenseTotalCost,
    required this.expenseDate,
    this.expenseName,
    this.expenseFuelCost,
    this.expenseFuelAmount,
    this.expensePicture,
    this.expenseNotes,
    required this.expenseIdentificationNumber});

  factory expenseList.fromMap(Map<String, dynamic> json) => expenseList(
    id: json['id'],
    expenseType: json['expenseType'],
    expenseVehicleIdentification: json['expenseVehicleIdentification'],
    expenseName: json['expenseName'],
    expenseTotalCost: json['expenseTotalCost'],
    expenseFuelCost: json['expenseFuelCost'],
    expenseFuelAmount: json['expenseFuelAmount'],
    expenseDate: json['expenseDate'],
    expensePicture: json['expensePicture'],
    expenseNotes: json['expenseNotes'],
    expenseIdentificationNumber: json['expenseIdentificationNumber'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'expenseType' : expenseType,
      'expenseVehicleIdentification' : expenseVehicleIdentification,
      'expenseName' : expenseName,
      'expenseTotalCost' : expenseTotalCost,
      'expenseFuelCost' : expenseFuelCost,
      'expenseFuelAmount' : expenseFuelAmount,
      'expenseDate' : expenseDate,
      'expensePicture' : expensePicture,
      'expenseNotes' : expenseNotes,
      'expenseIdentificationNumber' : expenseIdentificationNumber,
    };
  }

}
// sqflite package: local SQLite database
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';

// https://flutter.dev/docs/cookbook/persistence/sqlite
// https://medium.com/@suragch/simple-sqflite-database-example-in-flutter-e56a5aaa3f91


class Record {
  final int id;
  final String value;
  final String language;

  Record({this.id, this.value, this.language});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
      'language': language,
    };
  }
}


class LocalDatabase {
  static Database _database;
  Future<Database> get database async {
    if (_database != null)
      return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // Open the database and store the reference.
  static final Future<Database> database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'fluent_io.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE records(id INTEGER PRIMARY KEY, value TEXT, language TEXT)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );


  // Define a function that inserts dogs into the database
  static Future<void> insertRecord(Record record) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  // A method that retrieves all the dogs from the dogs table.
  static Future<List<Record>> getRecords() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('records');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Record(
        id: maps[i]['id'],
        value: maps[i]['value'],
        language: maps[i]['language'],
      );
    });
  }


  static Future<void> updateRecord(Record record) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Record.
    await db.update(
      'records',
      record.toMap(),
      // Ensure that the Record has a matching id.
      where: "id = ?",
      // Pass the Record's id as a whereArg to prevent SQL injection.
      whereArgs: [record.id],
    );
  }
}



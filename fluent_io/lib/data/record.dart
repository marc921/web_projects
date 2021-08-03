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

  // Convert a Record into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
      'language': language,
    };
  }

  @override
  String toString() {
    return "id: $id, value: $value, language: $language";
  }
}

class Link {
  final int id;
  final int record1;
  final int record2;

  Link({this.id, this.record1, this.record2});

  // Convert a Link into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'record1': record1,
      'record2': record2,
    };
  }
}

class FakeDatabase {
  static Map<int, Map<String, dynamic>> _records = {
    0: {'id': 0, 'value': "hello", 'language': "English"},
    1: {'id': 1, 'value': "howdy", 'language': "English"},
    2: {'id': 2, 'value': "yallah", 'language': "Arabic"},
    3: {'id': 3, 'value': "I love you", 'language': "English"},
    4: {'id': 4, 'value': "Arigato Gosaimas", 'language': "Arabic"},
    5: {'id': 5, 'value': "inshallah", 'language': "Arabic"},
    6: {'id': 6, 'value': "Don't tell me what to do", 'language': "English"},
    7: {'id': 7, 'value': "Stand by me", 'language': "English"},
    8: {'id': 8, 'value': "mateam", 'language': "Arabic"},
  };
  static Map<int, Map<String, dynamic>> _links = {};

  static void insertRecord(Record record) {
    _records[record.id] = record.toMap();
  }

  static void insertLink(Link link) {
    _links[link.id] = link.toMap();
  }

  static void insertGraph(List<Record> records, List<Link> links) {
    records.forEach((record) => insertRecord(record));
    links.forEach((link) => insertLink(link));
  }

  static Map<int, Map<String, dynamic>> getRecords() {
    return _records;
  }

  static Map<int, Map<String, dynamic>> getLinks() {
    return _links;
  }

  static List<Record> getMatchingRecords(String _searchText) {
    List<Record> matchingRecords = new List();
    FakeDatabase.getRecords()
        .values
        .where((entry) => entry['value'].toString().contains(_searchText))
        .forEach((recordMap) => matchingRecords.add(new Record(id: recordMap['id'], value: recordMap['value'], language: recordMap['language'])));
    return matchingRecords;
  }

  static List<String> getLanguages() {
    return <String>['Arabic', 'English'];
  }
}

class LocalDatabase {
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'fluent_io.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE records(id INTEGER PRIMARY KEY, value TEXT, language TEXT);" +
            "CREATE TABLE links(id INTEGER PRIMARY KEY, record1 INTEGER, record2 INTEGER);",
      );
    });
  }

  // Define a function that inserts records into the database
  static Future<void> insertRecord(Record record) async {
    // Insert the Record into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await _database.insert(
      'records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertLink(Link link) async {
    await _database.insert(
      'links',
      link.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the records from the dogs table.
  static Future<List<Record>> getRecords() async {
    // Query the table for all the records.
    final List<Map<String, dynamic>> maps = await _database.query('records');

    // Convert the List<Map<String, dynamic> into a List<Record>.
    return List.generate(maps.length, (i) {
      return Record(
        id: maps[i]['id'],
        value: maps[i]['value'],
        language: maps[i]['language'],
      );
    });
  }

  static Future<List<Link>> getLinks() async {
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await _database.query('links');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Link(
        id: maps[i]['id'],
        record1: maps[i]['record1'],
        record2: maps[i]['record2'],
      );
    });
  }

  static Future<void> updateRecord(Record record) async {
    // Update the given Record.
    await _database.update(
      'records',
      record.toMap(),
      // Ensure that the Record has a matching id.
      where: "id = ?",
      // Pass the Record's id as a whereArg to prevent SQL injection.
      whereArgs: [record.id],
    );
  }

  static Future<void> updateLink(Link link) async {
    // Update the given link.
    await _database.update(
      'links',
      link.toMap(),
      // Ensure that the link has a matching id.
      where: "id = ?",
      // Pass the link's id as a whereArg to prevent SQL injection.
      whereArgs: [link.id],
    );
  }
}

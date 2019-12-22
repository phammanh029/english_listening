import 'package:english_listening/model/Lession.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database _database;
  static DatabaseService _instance;
  DatabaseService._() {}

  static Future<DatabaseService> get instance async {
    if (_instance == null) {
      _instance = DatabaseService._();
      await _instance._initialize();
    }
    return _instance;
  }

  // initialize database
  Future _initialize() async {
    _database = await openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'lessions_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE lessions(path TEXT PRIMARY KEY, transcription TEXT, thumbnail TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return true;
  }

  // add new lession to database
  Future<bool> addNewLession(Lession lession) async {
    try {
      await _database.insert('lessions', lession.toJson(),
          conflictAlgorithm: ConflictAlgorithm.fail);
      return true;
    } catch (error) {
      print(error);
    }
    return false;
  }

  Future<bool> updateLession(Lession lession) async {
    return await _database.update('lessions', lession.toJson(),
            where: 'path = ?', whereArgs: [lession.path]) >
        0;
  }

  // get lession from database
  Future<Lession> getLession(String path) async {
    final result =
        await _database.query('lessions', where: 'path = ?', whereArgs: [path]);
    if (result != null && result.length > 0) {
      return Lession.fromJson(result[0]);
    }

    return null;
  }

  // get list of lession from database
  Future<List<Lession>> listLessions() async {
    final result = await _database.query('lessions');
    if (result != null) {
      return result.map((lession) => Lession.fromJson(lession)).toList();
    }

    return null;
  }

  Future<bool> removeLession(Lession lession) async {
    return await _database
            .delete('lessions', where: 'path = ?', whereArgs: [lession.path]) >
        0;
  }
}

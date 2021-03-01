import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sql_lite/models/persons_model.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static const _databaseName = 'PersonData.db';
  static const _databaseVersion = 1;


  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;
  Future <Database> get database async{
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
    }

    _initDatabase() async{
      Directory dataDirectory = await getApplicationDocumentsDirectory();
      String dbPath = join(dataDirectory.path,_databaseName);
      return await openDatabase(dbPath, 
      version: _databaseVersion, onCreate: _onCreateDB);
    }

    _onCreateDB(Database db, int version)async{
      await db.execute('''
        CREATE TABLE ${Person.tblPerson}(
          ${Person.perId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${Person.perIdenty} TEXT NOT NULL,
          ${Person.perName} TEXT NOT NULL,
          ${Person.perLastname} TEXT NOT NULL,
          ${Person.perDatebirth} TEXT NOT NULL,
          ${Person.perDisability} TEXT NOT NULL
        )

      ''');
    }

    Future<int> insertPerson(Person person) async{
      Database db = await database;
      return await db.insert(Person.tblPerson,person.toMap());
    }

    Future<List<Person>> fetchPersons() async{
      Database db = await database;
      List<Map> persons = await db.query(Person.tblPerson);
      return persons.length == 0
      ? []
      :persons.map((e) => Person.fromMap(e)).toList();
    }
 
  }

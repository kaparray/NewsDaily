import 'dart:io';
import 'package:news_app/models/add_news_to_interesting.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static final DBHelper _dbHelper = new DBHelper._internal();

  final String tableName = "InterestingNews";

  Database db;

  static DBHelper get() {
    return _dbHelper;
  }

  DBHelper._internal();


  Future init() async {
    // Get a location usses path_provider
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "local.db");
    db = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async{
      await db.execute(
        "CREATE TABLE $tableName"
        "Id INTEGER PRIMARY KEY"
        "news_type TEXT"
        "blocked BIT"
        ");"
        );
    });
  }

  Future newInterestingTheme(InterestingModel model) async {
    var table;

    try {
      table = await db.rawInsert(
        "INSERT INTO $tableName (Id, news_type, blocked)"
        " VALUES (${model.Id}, ${model.news_type}, ${model.blocked});"
        );
    } catch (Exeption ) {
      // ToDo make user notification
      print('Database error');
    }
    return table;
  }

}

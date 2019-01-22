import 'dart:io';
import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';

class ObjectDBHelper {

  ObjectDB db;

  addDatr() {
    db.open();
    db.insertMany([
      {
        'id': '1',
        'name': 'Rich'
      },
      {
        'id': '2',
        'name': 'Cirill'
      },
      {
        'id': '3',
        'name': 'Loh'
      }
    ]);
  }

   void loadContactsFromDb() async {
    var contacts = await db.find({'id': '2'});
    print(contacts);
  }


  createDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    print(appDocDir);
    String dbFilePath = [appDocDir.path, 'user.db'].join('/');
    db = ObjectDB(dbFilePath);
    addDatr();
    loadContactsFromDb();
  }
}

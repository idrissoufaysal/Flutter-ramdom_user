import 'package:sqflite/sqflite.dart' as sql;

class SqliteService {
   
static Future<void> createTable(sql.Database database) async {
  await database.execute(
    '''
      CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      gender TEXT,
      email TEXT,
      phone TEXT
    )

       '''
  );
}

static Future<sql.Database> db() async {
  return sql.openDatabase(
    'randomUser.db',
    version: 1,
    onCreate: (sql.Database database, int version) async{
      await createTable(database);
    }
  );
}

static Future<int> createData(String genre, email, telephone) async{
  final db =await SqliteService.db();
  final data= {'email':email,'phone':telephone,'gender':genre};
  final id= await db.insert('users', data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
  
  return id;

}

static Future<List<Map<String, dynamic>>> getAllUser() async{
  final db=await SqliteService.db();
  return db.query('users', orderBy: 'id DESC');
}





static Future<List<Map<String, dynamic>>> getSingleUser(int id) async{
  final db=await SqliteService.db();
  return db.query('users', where: "id = ?", whereArgs: [id], limit: 1);
}

static Future<int> updateUser(int id,String email, telephone,genre) async{
  final db = await SqliteService.db();
  final data ={'email':email,'phone':telephone,'gender':genre};
  final result = await db.update('users', data, where:"id = ? ", whereArgs: [id]);
  return result;
}

static Future<void> deleteUser(int id) async{
  final db =await SqliteService.db();
  try {
    await db.delete('users', where: "id = ?", whereArgs: [id]);
  } catch (e) {
    print(e);
  }
}

}
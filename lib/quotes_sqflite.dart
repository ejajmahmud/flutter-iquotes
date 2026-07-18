import 'package:flutter/foundation.dart';
import 'package:qute_app/models/quote_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QuotesDb{
  static Database? _database;
  Future<Database?>get database async{
    if(_database==null){
      return _database=await initDb();
  }else{
      return _database;
  }
}


  initDb()async{
    String dbpath=await getDatabasesPath();
    String path=join(dbpath,'quotes.db');
    Database database=await openDatabase(path,onCreate:_onCreate ,version: 1 );
    return database;
  }
  _onCreate (Database database,int version)async{

    await database.execute('''
    CREATE TABLE users(
    user_id INTEGER PRIMARY KEY AUTOINCREMENT ,
    user_name TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL
    )
    ''');

    await database.execute('''
    CREATE TABLE user_quotes (
    quote_id INTEGER PRIMARY KEY AUTOINCREMENT , 
    user_id INTEGER NOT NULL,
    quote_text TEXT NOT NULL,
    author TEXT NOT NULL,
    is_favorite INTEGER DEFAULT 0,
    is_archived INTEGER DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
    )
    '''
    );

if (kDebugMode) {
  print('========================Database Created');
}
  }

  Future<int> insertModelData(String table, Map<String, dynamic> data) async {
    Database? db = await database;
    // conflictAlgorithm.ignore will not insert if a unique constraint is violated (e.g., username)
    // and will return 0.
    // conflictAlgorithm.replace will replace the existing row.
    // Choose based on your needs.
    return await db!.insert(table, data, conflictAlgorithm: ConflictAlgorithm.ignore);
  }
  Future<int> insertModelDataQuotes(String table, Map<String, dynamic> data) async {
    Database? db = await database;
    return await db!.insert(table, data);
  }

  // Secure Read (example for getting all users)
  Future<List<Map<String, dynamic>>> getAllRows(String table) async {
    Database? db = await database;
    return await db!.query(table);
  }

  // Secure Read with arguments (example for getting a user by ID)
  Future<List<Map<String, dynamic>>> queryWithArgs(String table, String whereClause, List<dynamic> whereArgs) async {
    Database? db = await database;
    return await db!.query(table, where: whereClause, whereArgs: whereArgs);
  }

  // Secure Update
  Future<int> updateModelData(String table, Map<String, dynamic> data, String whereClause, List<dynamic> whereArgs) async {
    Database? db = await database;
    return await db!.update(table, data, where: whereClause, whereArgs: whereArgs);
  }

  // Secure Delete
  Future<int> deleteModelData(String table, String whereClause, List<dynamic> whereArgs) async {
    Database? db = await database;
    return await db!.delete(table, where: whereClause, whereArgs: whereArgs);
  }
Future<void> deleteUser (int userId)async{
    int deletedQuoteCount=await deleteModelData(
      "users",
      'user_id=?',
      [userId],);
    if (kDebugMode) {
      print('Deleted $deletedQuoteCount quotes for user ID: $userId');
    }

}
  // Keep rawQuery for complex queries, but ensure arguments are passed separately
  Future<List<Map<String, dynamic>>> executeRawQuery(String sql, [List<dynamic>? arguments]) async {
    Database? db = await database;
    return await db!.rawQuery(sql, arguments);
  }

  Future<void> executeRawCommand(String sql, [List<dynamic>? arguments]) async { // For rawInsert, rawUpdate, rawDelete
    Database? db = await database;
    return await db!.execute(sql, arguments); // db.execute is for non-query SQL
  }
Future <bool> doesUserNameExist(String userName)async{
    Database? db=await database;
    final List<Map<String, dynamic>>maps=await db!.query(
      'users',
      columns: ['user_id'],
      where: 'user_name=?',
      whereArgs: [userName],
    );
    return maps.isNotEmpty;

}

Future <UserModel?> getUserByUsername(String username) async{
    Database? db=await database;
    final List<Map<String,dynamic>> maps=await db!.query(
      'users',
      where: 'user_name=?',
      whereArgs: [username],
      limit: 1,//we expect at most one user with a given username
    );
    if(maps.isNotEmpty){
      return UserModel.fromMap(maps.first); // Convert the map to a UserModel

    }
    return null; //User not found
}

Future<UserModel?> getUserById(int userId)async{
    Database? db=await database;
    if(db==null) return null;

    final List<Map<String,dynamic>> maps=await db.query(
      'users',
      where: 'user_id=?',
      whereArgs: [userId],
      limit: 1,
    );
    if(maps.isNotEmpty){
      return UserModel.fromMap(maps.first);
    }
    return null;
}

Future<List<Map<String,dynamic>>> getQuotesByUserId(int userId)async{
    final db=await database;
    return await db!.query('user_quotes',
     where: 'user_id=?',
      whereArgs: [userId],
    );
}

Future<int>updateUserQuote(UserQuoteModel quote)async{
    final db=await database;
    return await db!.update(
      'user_quotes',
      quote.toMap(),
      where: 'quote_id=?AND user_id=?',
      whereArgs: [quote.quoteId,quote.userId],
    );
}

Future<int>deleteUserQuote(UserQuoteModel quote)async{
    final db=await database;
    if(db==null){
      if (kDebugMode) {
        print('Database not initialized . Cannot delete quote.');
      }
      return 0;
    }
    return await db.delete(
      'user_quotes',
      where: 'quote_id=? AND user_id=?',
      whereArgs: [quote.quoteId,quote.userId],
    );
}

}

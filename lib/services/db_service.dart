import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbService {
  static Future<List<Map<String, dynamic>>> getDomains() async {
    sqfliteFfiInit();
    final db = await databaseFactoryFfi.openDatabase('shepherd.db');
    final result = await db.rawQuery('SELECT * FROM domains');
    await db.close();
    return result;
  }
}

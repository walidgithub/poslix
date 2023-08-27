import 'package:path/path.dart';
import 'package:poslix_app/pos/domain/entities/hold_order_items_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/hold_order_names_model.dart';

class DbHelper {
  Database? _db;

  static int? insertedNewHoldId;

  String dbdName = 'poslix_hold_orders4.db';

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDB(dbdName);
      return _db!;
    }
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database db, int version) async {
    await db.execute(
        'create table poslix_hold_head(id integer primary key autoincrement, customerTel varchar(15), customer varchar(255), discount varchar(15), holdText varchar(15), date TEXT NOT NULL)');

    await db.execute(
        'create table poslix_hold_items(id integer primary key autoincrement, holdOrderId integer, category varchar(15), itemAmount varchar(15), itemName varchar(15), itemPrice varchar(15), productType varchar(15), itemQuantity integer, brand varchar(15), itemOption varchar(15), productId integer, variationId integer, customerTel varchar(15), customer varchar(255), discount varchar(15), holdText varchar(15), date TEXT NOT NULL)');

  }

  // Hold Operations----------------------------------------------------------------------------------------

  Future<HoldOrderNamesModel> createHoldCard(HoldOrderNamesModel holdOrder) async {
    final db = _db!.database;

    insertedNewHoldId = await db.insert('poslix_hold_head', holdOrder.toMap());

    return holdOrder;
  }

  Future<HoldOrderItemsModel> createHoldCardItems(HoldOrderItemsModel holdOrderItems) async {
    final db = _db!.database;

    await db.insert('poslix_hold_items', holdOrderItems.toMap());

    return holdOrderItems;
  }

  Future<int> deleteHoldOrder(int id) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    return db.delete('poslix_hold_head', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteHoldOrderItems(int id) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    return db.delete('poslix_hold_items', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<HoldOrderNamesModel>> getAllHoldOrders() async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final result = await db.rawQuery(
        'SELECT * FROM poslix_hold_head Order by id ASC');
    return result.map((map) => HoldOrderNamesModel.fromMap(map)).toList();
  }

  Future<List<HoldOrderNamesModel>> getHoldOrdersByCustomer(String customer) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final result = await db.rawQuery(
        'SELECT * FROM poslix_hold_head where customer = ? Order by id ASC',[customer]);
    return result.map((map) => HoldOrderNamesModel.fromMap(map)).toList();
  }

  Future<List<HoldOrderNamesModel>> getHoldOrdersByTel(String tel) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final result = await db.rawQuery(
        'SELECT * FROM poslix_hold_head where customerTel = ? Order by id ASC',[tel]);
    return result.map((map) => HoldOrderNamesModel.fromMap(map)).toList();
  }

  Future<List<HoldOrderItemsModel>> getAllHoldOrdersItemsById(int holdOrderId) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final result = await db.rawQuery(
        'SELECT * FROM poslix_hold_items where holdOrderId = ? Order by id ASC', [holdOrderId]);

    return result.map((map) => HoldOrderItemsModel.fromMap(map)).toList();
  }


  // Others -----------------------------------------------------------------------------------------------

  Future close() async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    db.close();
  }
}

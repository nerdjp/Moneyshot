import 'package:sqflite/sqflite.dart';

import '../entity/entity.dart';

abstract class DatabaseHelper<T extends Entity> {
  static Database? _database;

  String getTable();

  T transform(Map<String, Object?> map);

  DatabaseHelper();

  Future<Database> get database async {
    if (_database == null) {
      print('initdb');
      _database = await _initDB('moneyshot.db');
    }
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final db = await openDatabase(filePath, version: 1, onCreate: _createDB);
    return db;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
			CREATE TABLE categories (
				id 					INTEGER 		NOT NULL  	PRIMARY KEY,
				description 		TEXT	 		NOT NULL
			);
			''');
    /*await db.execute(
			'''
			CREATE TABLE spendings (
				id 					INTEGER 		NOT NULL  	PRIMARY KEY,
				description 		TEXT	 		NOT NULL,
				date 				DATE 			NOT NULL,
				category_id 		INTEGER 		NOT NULL,
				value 				REAL 			NOT NULL,
				date_payment 		DATE,
				n_installments		INTEGER,
				nt_installments 	INTEGER
			);
			'''
		);
		await db.execute(
			'''
			CREATE TABLE plannings (
				id 					INTEGER 		NOT NULL  	PRIMARY KEY,
				value 				REAL 			NOT NULL
			);
			'''
		);
		await db.execute(
			'''
			CREATE TABLE details (
				id 					INTEGER 		NOT NULL  	PRIMARY KEY,
				planning_id 		INTEGER 		NOT NULL,
				category_id 		INTEGER 		NOT NULL,
				percentual_value	REAL 			NOT NULL
			);
			'''
		);*/
  }

  void save(T entity) async {
    if (getTable() == null) return;
    final db = await database;
    if (entity.id == null) {
      entity.id = await db.insert(getTable(), entity.toJson());
    } else {
      await db.update(getTable(), entity.toJson(),
          where: 'id = ?', whereArgs: [entity.id]);
    }
  }

  Future<int> remove(T entity) async {
    if (entity.id != null) {
      final db = await database;
      return db.delete(getTable(), where: 'id = ?', whereArgs: [entity.id]);
    }
    return Future.value(0);
  }

  Future<T> get(int id) async {
    final db = await database;
    final map = await db.query(getTable());
    throw UnimplementedError('Não implementado.');
  }

  Future<List<T>> getAll() async {
    final db = await database;
    return await db.query(getTable()).then((value) {
      List<T> list = transformAll(value);
      return Future.value(list);
    });
  }

  List<T> transformAll(List<Map<String, Object?>> listMap) {
    List<T> list = [];
    for (var map in listMap) {
      list.add(transform(map));
    }
    return list;
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}

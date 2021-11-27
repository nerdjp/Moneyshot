import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'categories.dart';
import 'data.dart';

class DatabaseHelper {

	static final DatabaseHelper instance = DatabaseHelper._init();
	static Database? _database;

	Future<Database> get database async {
		if(_database == null) {
			print('initdb');
			_database = await _initDB('moneyshot.db');
		}
		return _database!;
	}

	Future<Database> _initDB(String filePath) async{
		//final dbPath = await getDatabasesPath();
		//final path = join(dbPath.path, filePath);
		final db = await openDatabase(filePath, version: 1, onCreate: _createDB);
		return db;
	}

	Future _createDB(Database db, int version) async {
		await db.execute(
			'''
			CREATE TABLE categories (
				id 					INTEGER 		NOT NULL  	PRIMARY KEY,
				description 		TEXT	 		NOT NULL
			);
			'''
		);
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

	 void create(Data data) async {
		if(data.table == null) return;
		final db = await instance.database;
		final id = await db.insert(data.table!, data.toJson());
		data.id = id;
	}

	Future<int> createCategory(Category category) async {
		final db = await instance.database;
		return await db.insert('categories', category.toJson());
	}

	Future<int> removeCategory(int? id) async {
		final db = await instance.database;
		return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
	}

	Future<int> updateCategory(Category category) async {
		final db = await instance.database;
		return await db.update('categories', category.toJson(), where: 'id = ?', whereArgs: [category.id]);
	}

	Future<List<Map<String, Object?>>> read(String table) async {
		final db = await instance.database;
		final map = await db.query(table);
		return map;
	}

	Future close() async{
		final db = await instance.database;
		db.close();
	}

	DatabaseHelper._init();

}

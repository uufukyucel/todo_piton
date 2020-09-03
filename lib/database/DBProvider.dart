import 'dart:async';

import 'package:path/path.dart';
import 'package:piton_todo/models/todo_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  /* Veritabanı tablo ve sütun isimlerini statik değişkene attık */
  static const String TABLE_TODO = "todos"; // tablo adı
  static const String COLUMN_ID = "id"; // id sütunu
  static const String COLUMN_TITLE = "title"; // başlık sütunu
  static const String COLUMN_DESC = "desc"; // açıklama sütunu
  static const String COLUMN_TYPE =
      "type"; // tip sütunu (günlük, haftalık, aylık)
  static const String COLUMN_CHECKED =
      "checked"; // görev check butonu için ayrılan sütun

  DBProvider._();
  static final DBProvider db = DBProvider
      ._(); // her sayfadan ulaşabilmek için provideri statik belirledik

  static Database _database; // Database ref tanımladık

  /* Veritabanı varsa */
  Future<Database> get database async {
    print("database getter called");
    if (_database != null) {
      return _database;
    }
    // Veritabanı oluşturuyoruz ilk kurulum için
    _database = await createDatabase();
    return _database;
  }

  // Veritabanı oluşturma fonksiyonu
  Future<Database> createDatabase() async {
    // Veritabanı oluşturulacak yolu belirliyoruz.
    String dbPath = await getDatabasesPath();
    // veritabanı dossyamıza bi isim verdik. versiyon sonraki güncellemeler için
    // veritabanı baştan oluşturulsun mu kontrolünü sağlamakta
    return await openDatabase(join(dbPath, 'todoDb.db'), version: 1,
        onCreate: (Database database, int version) async {
      print('creating todos tabled');
      // veritabanımızı oluşturuyoruz
      await database.execute(
        "CREATE TABLE $TABLE_TODO (" // tabloyu oluşturdu
        "$COLUMN_ID INTEGER PRIMARY KEY," // ilk sütun id, otomatik id atamalı
        "$COLUMN_TITLE TEXT," // başlık sütunu
        "$COLUMN_DESC TEXT," // açıklama sütunu
        "$COLUMN_TYPE TEXT," // tip sütunu
        "$COLUMN_CHECKED INTEGER" // check sütunu
        ")",
      );
    });
  }

  // veritabanında olan bütün görevleri listeler
  Future<List<Todo>> getTodos() async {
    final db = await database;
    var todos = await db.query(TABLE_TODO, columns: [
      COLUMN_ID,
      COLUMN_TITLE,
      COLUMN_DESC,
      COLUMN_TYPE,
      COLUMN_CHECKED
    ]);
    List<Todo> todoList = List<Todo>();
    todos.forEach((element) {
      Todo todo = Todo.fromMap(element);
      todoList.add(todo);
    });
    return todoList;
  }

  // veritabanında olan günlük görevleri listeler
  Future<List<Todo>> getTodosDaily() async {
    final db = await database;
    var todos = await db.query(TABLE_TODO, where: "type = ?", whereArgs: [
      "Günlük"
    ], columns: [
      COLUMN_ID,
      COLUMN_TITLE,
      COLUMN_DESC,
      COLUMN_TYPE,
      COLUMN_CHECKED
    ]);
    List<Todo> todoList = List<Todo>();
    todos.forEach((element) {
      Todo todo = Todo.fromMap(element);
      todoList.add(todo);
    });
    return todoList;
  }

  // veritabanında olan haftalık görevleri listeler
  Future<List<Todo>> getTodosWeekly() async {
    final db = await database;
    var todos = await db.query(TABLE_TODO, where: "type = ?", whereArgs: [
      "Haftalık"
    ], columns: [
      COLUMN_ID,
      COLUMN_TITLE,
      COLUMN_DESC,
      COLUMN_TYPE,
      COLUMN_CHECKED
    ]);
    List<Todo> todoList = List<Todo>();
    todos.forEach((element) {
      Todo todo = Todo.fromMap(element);
      todoList.add(todo);
    });
    return todoList;
  }

  // veritabanında olan aylık görevleri listeler
  Future<List<Todo>> getTodosMonthly() async {
    final db = await database;
    var todos = await db.query(TABLE_TODO, where: "type = ?", whereArgs: [
      "Aylık"
    ], columns: [
      COLUMN_ID,
      COLUMN_TITLE,
      COLUMN_DESC,
      COLUMN_TYPE,
      COLUMN_CHECKED
    ]);
    // Listeye atadık böylece anasayfada listviewer ile görüntüleyebiliriz
    List<Todo> todoList = List<Todo>();
    todos.forEach((element) {
      Todo todo = Todo.fromMap(element);
      todoList.add(todo);
    });
    return todoList;
  }

  // veritabanında yeni görev ekler
  Future<Todo> insert(Todo todo) async {
    final db = await database;
    todo.id = await db.insert(TABLE_TODO, todo.toMap());
    return todo;
  }

  // veritabanında olan bir veriyi id aracılığıyla bularak siler
  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_TODO,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // veritabanında olan bir veriyi id aracılığıyla bularak günceller
  Future<int> update(Todo todo) async {
    final db = await database;
    return await db.update(TABLE_TODO, todo.toMap(),
        where: "id = ?", whereArgs: [todo.id]);
  }
}

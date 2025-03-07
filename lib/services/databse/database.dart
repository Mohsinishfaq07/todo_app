import 'package:diary_app/model/notes_model/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDB();
    return _database!;
  }

  Future<Database> initializeDB() async {
    String dbPath = join(await getDatabasesPath(), 'diary.db');
    debugPrint('Database initialized path: $dbPath');
    return await openDatabase(dbPath, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Diary (id INTEGER PRIMARY KEY, title TEXT, description TEXT, emoji TEXT)');
  }

  Future<void> insertTask(DiaryModel diary) async {
    final db = await database;
    await db.insert('Diary', diary.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Stream<List<DiaryModel>> getTasksStream() async* {
    final db = await database;
    yield* Stream.periodic(const Duration(milliseconds: 200), (_) async {
      final List<Map<String, dynamic>> maps = await db.query('Diary');
      return List.generate(maps.length, (i) {
        return DiaryModel.fromMap(maps[i]);
      });
    }).asyncMap((event) async => await event);
  }

  Future<void> updateTask(DiaryModel notes) async {
    final db = await database;

    await db.update(
      'Diary',
      notes.toMap(),
      where: 'id = ?',
      whereArgs: [notes.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'Diary',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

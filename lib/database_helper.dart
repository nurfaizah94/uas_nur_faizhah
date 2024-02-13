import 'dart:async';
import 'package:flutter_crud/student.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'students.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE Student (
        id INTEGER PRIMARY KEY,
        nama TEXT,
        nim TEXT,
        jurusan TEXT,
        nilai_uas REAL,
        nilai_uts REAL,
        nilai_tugas REAL
      )
    ''');
  }

  Future<int> insertStudent(Student student) async {
    Database dbClient = await db;
    return await dbClient.insert('Student', student.toMap());
  }

  Future<List<Student>> getStudents() async {
    Database dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('Student');
    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  Future<void> deleteAllStudents() async {
    Database dbClient = await db;
    await dbClient.delete('Student');
  }

  Future<void> deleteStudent(int id) async {
    Database dbClient = await db;
    await dbClient.delete('Student', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateStudent(Student student) async {
    Database dbClient = await db;
    await dbClient.update(
      'Student',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }
}

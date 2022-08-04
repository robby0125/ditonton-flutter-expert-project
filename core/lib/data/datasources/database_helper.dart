import 'dart:async';

import 'package:core/common/encrypt.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblMovieWatchlist = 'movie_watchlist';
  static const String _tblTvWatchlist = 'tv_watchlist';
  static const String _tblMovieCache = 'cache_movie';
  static const String _tblTvCache = 'cache_tv';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
      password: encrypt('robby2501'),
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblMovieWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE  $_tblTvWatchlist (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE  $_tblMovieCache (
        id INTEGER,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT,
        PRIMARY KEY (id, category)
      );
    ''');

    await db.execute('''
      CREATE TABLE  $_tblTvCache (
        id INTEGER,
        name TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT,
        PRIMARY KEY (id, category)
      );
    ''');
  }
}

import 'package:core/core.dart';
import 'package:movie/movie.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class MovieDatabaseHelper {
  static MovieDatabaseHelper? _movieDatabaseHelper;

  MovieDatabaseHelper._instance() {
    _movieDatabaseHelper = this;
  }

  factory MovieDatabaseHelper() =>
      _movieDatabaseHelper ?? MovieDatabaseHelper._instance();

  static const String _tblMovieWatchlist = 'movie_watchlist';
  static const String _tblMovieCache = 'cache_movie';

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await DatabaseHelper().database;
    return _database;
  }

  Future<int> insertMovieWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.insert(_tblMovieWatchlist, movie.toJson());
  }

  Future<int> removeMovieWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tblMovieWatchlist,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblMovieWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db!.query(_tblMovieWatchlist);

    return results;
  }

  Future<void> insertMovieCacheTransaction(
      List<MovieTable> movies, String category) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final movie in movies) {
        final movieJson = movie.toJson();
        movieJson['category'] = category;
        txn.insert(_tblMovieCache, movieJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheMovies(String category) async {
    final db = await database;
    final results = await db!.query(
      _tblMovieCache,
      where: 'category = ?',
      whereArgs: [category],
    );

    return results;
  }

  Future<int> clearMoviesCache(String category) async {
    final db = await database;
    return await db!.delete(
      _tblMovieCache,
      where: 'category = ?',
      whereArgs: [category],
    );
  }
}

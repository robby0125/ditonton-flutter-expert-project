import 'package:core/core.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:tv_series/tv_series.dart';

class TvDatabaseHelper {
  static TvDatabaseHelper? _tvDatabaseHelper;

  TvDatabaseHelper._instance() {
    _tvDatabaseHelper = this;
  }

  factory TvDatabaseHelper() =>
      _tvDatabaseHelper ?? TvDatabaseHelper._instance();

  static const String _tblTvWatchlist = 'tv_watchlist';
  static const String _tblTvCache = 'cache_tv';

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await DatabaseHelper().database;
    return _database;
  }

  Future<int> insertTvWatchlist(TvTable tv) async {
    final db = await database;
    return await db!.insert(_tblTvWatchlist, tv.toJson());
  }

  Future<int> removeTvWatchlist(TvTable tv) async {
    final db = await database;
    return await db!.delete(
      _tblTvWatchlist,
      where: 'id = ?',
      whereArgs: [tv.id],
    );
  }

  Future<Map<String, dynamic>?> getTvById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblTvWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvSeries() async {
    final db = await database;
    final results = await db!.query(_tblTvWatchlist);

    return results;
  }

  Future<void> insertTvCacheTransaction(
      List<TvTable> tvSeries, String category) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final tv in tvSeries) {
        final tvJson = tv.toJson();
        tvJson['category'] = category;
        txn.insert(_tblTvCache, tvJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheTvSeries(String category) async {
    final db = await database;
    final result = db!.query(
      _tblTvCache,
      where: 'category = ?',
      whereArgs: [category],
    );

    return result;
  }

  Future<int> clearTvSeriesCache(String category) async {
    final db = await database;
    return await db!.delete(
      _tblTvCache,
      where: 'category = ?',
      whereArgs: [category],
    );
  }
}

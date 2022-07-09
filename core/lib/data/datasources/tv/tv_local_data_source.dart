import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/models/tv_table.dart';
import 'package:core/utils/exception.dart';

abstract class TvLocalDataSource {
  Future<String> insertWatchlist(TvTable tv);

  Future<String> removeWatchlist(TvTable tv);

  Future<TvTable?> getTvById(int id);

  Future<List<TvTable>> getWatchlistTvSeries();

  Future<void> cacheOnAirTvSeries(List<TvTable> tvSeries);

  Future<List<TvTable>> getCachedOnAirTvSeries();

  Future<void> cachePopularTvSeries(List<TvTable> tvSeries);

  Future<List<TvTable>> getCachedPopularTvSeries();

  Future<void> cacheTopRatedTvSeries(List<TvTable> tvSeries);

  Future<List<TvTable>> getCachedTopRatedTvSeries();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(TvTable tv) async {
    try {
      await databaseHelper.insertTvWatchlist(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvTable tv) async {
    try {
      await databaseHelper.removeTvWatchlist(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvTable?> getTvById(int id) async {
    final result = await databaseHelper.getTvById(id);

    if (result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTvSeries() async {
    final result = await databaseHelper.getWatchlistTvSeries();
    return result.map((data) => TvTable.fromMap(data)).toList();
  }

  @override
  Future<void> cacheOnAirTvSeries(List<TvTable> tvSeries) async {
    await databaseHelper.clearTvSeriesCache('on air');
    await databaseHelper.insertTvCacheTransaction(tvSeries, 'on air');
  }

  @override
  Future<List<TvTable>> getCachedOnAirTvSeries() async {
    final result = await databaseHelper.getCacheTvSeries('on air');

    if (result.isNotEmpty) {
      return result.map((tv) => TvTable.fromMap(tv)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }

  @override
  Future<void> cachePopularTvSeries(List<TvTable> tvSeries) async {
    await databaseHelper.clearTvSeriesCache('popular');
    await databaseHelper.insertTvCacheTransaction(tvSeries, 'popular');
  }

  @override
  Future<List<TvTable>> getCachedPopularTvSeries() async {
    final result = await databaseHelper.getCacheTvSeries('popular');

    if (result.isNotEmpty) {
      return result.map((tv) => TvTable.fromMap(tv)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }

  @override
  Future<void> cacheTopRatedTvSeries(List<TvTable> tvSeries) async {
    await databaseHelper.clearTvSeriesCache('top rated');
    await databaseHelper.insertTvCacheTransaction(tvSeries, 'top rated');
  }

  @override
  Future<List<TvTable>> getCachedTopRatedTvSeries() async {
    final result = await databaseHelper.getCacheTvSeries('top rated');

    if (result.isNotEmpty) {
      return result.map((tv) => TvTable.fromMap(tv)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }
}

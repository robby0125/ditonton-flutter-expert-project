import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/tv_table.dart';

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
    final _result = await databaseHelper.getTvById(id);

    if (_result != null) {
      return TvTable.fromMap(_result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTvSeries() async {
    final _result = await databaseHelper.getWatchlistTvSeries();
    return _result.map((data) => TvTable.fromMap(data)).toList();
  }

  @override
  Future<void> cacheOnAirTvSeries(List<TvTable> tvSeries) async {
    await databaseHelper.clearTvSeriesCache('on air');
    await databaseHelper.insertTvCacheTransaction(tvSeries, 'on air');
  }

  @override
  Future<List<TvTable>> getCachedOnAirTvSeries() async {
    final result = await databaseHelper.getCacheTvSeries('on air');

    if (result.length > 0) {
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

    if (result.length > 0) {
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

    if (result.length > 0) {
      return result.map((tv) => TvTable.fromMap(tv)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }
}

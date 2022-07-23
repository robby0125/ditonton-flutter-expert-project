import 'package:core/data/datasources/tv/tv_local_data_source.dart';
import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TvLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertTvWatchlist(testTvTable))
          .thenAnswer((_) async => 1);

      // act
      final result = await dataSource.insertWatchlist(testTvTable);

      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () {
      // arrange
      when(mockDatabaseHelper.insertTvWatchlist(testTvTable))
          .thenThrow(Exception());

      // act
      final call = dataSource.insertWatchlist(testTvTable);

      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeTvWatchlist(testTvTable))
          .thenAnswer((_) async => 1);

      // act
      final result = await dataSource.removeWatchlist(testTvTable);

      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () {
      // arrange
      when(mockDatabaseHelper.removeTvWatchlist(testTvTable))
          .thenThrow(Exception());

      // act
      final call = dataSource.removeWatchlist(testTvTable);

      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get tv detail by id', () {
    const tId = 1;

    test('should return Tv Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTvById(tId))
          .thenAnswer((_) async => testTvMap);

      // act
      final result = await dataSource.getTvById(tId);

      // assert
      expect(result, testTvTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvById(tId)).thenAnswer((_) async => null);

      // act
      final result = await dataSource.getTvById(tId);

      // assert
      expect(result, null);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TvTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvMap]);

      // act
      final result = await dataSource.getWatchlistTvSeries();

      // assert
      expect(result, [testTvTable]);
    });
  });

  group('cache on air tv series', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearTvSeriesCache('on air'))
          .thenAnswer((_) async => 1);

      // arrange
      await dataSource.cacheOnAirTvSeries([testTvCache]);

      // assert
      verify(mockDatabaseHelper.clearTvSeriesCache('on air'));
      verify(
          mockDatabaseHelper.insertTvCacheTransaction([testTvCache], 'on air'));
    });

    test('should return list tv series from db when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getCacheTvSeries('on air'))
          .thenAnswer((_) async => [testTvCacheMap]);

      // act
      final result = await dataSource.getCachedOnAirTvSeries();

      // assert
      expect(result, [testTvCache]);
    });

    test('should throw CacheException when data is empty', () async {
      // arrange
      when(mockDatabaseHelper.getCacheTvSeries('on air'))
          .thenAnswer((_) async => []);

      // act
      final call = dataSource.getCachedOnAirTvSeries();

      // assert
      expect(call, throwsA(isA<CacheException>()));
    });
  });

  group('cache popular tv series', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearTvSeriesCache('popular'))
          .thenAnswer((_) async => 1);

      // arrange
      await dataSource.cachePopularTvSeries([testTvCache]);

      // assert
      verify(mockDatabaseHelper.clearTvSeriesCache('popular'));
      verify(mockDatabaseHelper
          .insertTvCacheTransaction([testTvCache], 'popular'));
    });

    test('should return list tv series from db when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getCacheTvSeries('popular'))
          .thenAnswer((_) async => [testTvCacheMap]);

      // act
      final result = await dataSource.getCachedPopularTvSeries();

      // assert
      expect(result, [testTvCache]);
    });

    test('should throw CacheException when data is empty', () async {
      // arrange
      when(mockDatabaseHelper.getCacheTvSeries('popular'))
          .thenAnswer((_) async => []);

      // act
      final call = dataSource.getCachedPopularTvSeries();

      // assert
      expect(call, throwsA(isA<CacheException>()));
    });
  });

  group('cache top rated tv series', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearTvSeriesCache('top rated'))
          .thenAnswer((_) async => 1);

      // arrange
      await dataSource.cacheTopRatedTvSeries([testTvCache]);

      // assert
      verify(mockDatabaseHelper.clearTvSeriesCache('top rated'));
      verify(mockDatabaseHelper
          .insertTvCacheTransaction([testTvCache], 'top rated'));
    });

    test('should return list tv series from db when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getCacheTvSeries('top rated'))
          .thenAnswer((_) async => [testTvCacheMap]);

      // act
      final result = await dataSource.getCachedTopRatedTvSeries();

      // assert
      expect(result, [testTvCache]);
    });

    test('should throw CacheException when data is empty', () async {
      // arrange
      when(mockDatabaseHelper.getCacheTvSeries('top rated'))
          .thenAnswer((_) async => []);

      // act
      final call = dataSource.getCachedTopRatedTvSeries();

      // assert
      expect(call, throwsA(isA<CacheException>()));
    });
  });
}

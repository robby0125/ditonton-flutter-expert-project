import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv/tv_local_data_source.dart';
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
      final _result = await dataSource.insertWatchlist(testTvTable);

      // assert
      expect(_result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () {
      // arrange
      when(mockDatabaseHelper.insertTvWatchlist(testTvTable))
          .thenThrow(Exception());

      // act
      final _call = dataSource.insertWatchlist(testTvTable);

      // assert
      expect(() => _call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeTvWatchlist(testTvTable))
          .thenAnswer((_) async => 1);

      // act
      final _result = await dataSource.removeWatchlist(testTvTable);

      // assert
      expect(_result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () {
      // arrange
      when(mockDatabaseHelper.removeTvWatchlist(testTvTable))
          .thenThrow(Exception());

      // act
      final _call = dataSource.removeWatchlist(testTvTable);

      // assert
      expect(() => _call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get tv detail by id', () {
    final _tId = 1;

    test('should return Tv Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTvById(_tId))
          .thenAnswer((_) async => testTvMap);

      // act
      final _result = await dataSource.getTvById(_tId);

      // assert
      expect(_result, testTvTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvById(_tId)).thenAnswer((_) async => null);

      // act
      final _result = await dataSource.getTvById(_tId);

      // assert
      expect(_result, null);
    });
  });
}

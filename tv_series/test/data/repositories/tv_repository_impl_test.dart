import 'dart:io';

import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tTvModel = TvModel(
    backdropPath: '/1qpUk27LVI9UoTS7S0EixUBj5aR.jpg',
    firstAirDate: DateTime.tryParse('2022-03-24'),
    genreIds: const [10759, 10765],
    id: 52814,
    name: 'Halo',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'Halo',
    overview:
        'Depicting an epic 26th-century conflict between humanity and an alien threat known as the Covenant, the series weaves deeply drawn personal stories with action, adventure and a richly imagined vision of the future.',
    popularity: 4244.572,
    posterPath: '/eO0QV5qJaEngP1Ax9w3eV6bJG2f.jpg',
    voteAverage: 8.6,
    voteCount: 829,
  );

  final tTv = Tv(
    backdropPath: '/1qpUk27LVI9UoTS7S0EixUBj5aR.jpg',
    firstAirDate: DateTime.tryParse('2022-03-24'),
    genreIds: const [10759, 10765],
    id: 52814,
    name: 'Halo',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'Halo',
    overview:
        'Depicting an epic 26th-century conflict between humanity and an alien threat known as the Covenant, the series weaves deeply drawn personal stories with action, adventure and a richly imagined vision of the future.',
    popularity: 4244.572,
    posterPath: '/eO0QV5qJaEngP1Ax9w3eV6bJG2f.jpg',
    voteAverage: 8.6,
    voteCount: 829,
  );

  final tTvModelList = [tTvModel];
  final tTvList = [tTv];

  group('On Air TV Series', () {
    test('should check if device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getOnAirTvSeries()).thenAnswer((_) async => []);

      // act
      await repository.getOnAirTvSeries();

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getOnAirTvSeries())
            .thenAnswer((_) async => tTvModelList);

        // act
        final result = await repository.getOnAirTvSeries();

        // assert
        verify(mockRemoteDataSource.getOnAirTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getOnAirTvSeries())
            .thenAnswer((_) async => tTvModelList);

        // act
        await repository.getOnAirTvSeries();

        // assert
        verify(mockRemoteDataSource.getOnAirTvSeries());
        verify(mockLocalDataSource.cacheOnAirTvSeries([testTvCache]));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getOnAirTvSeries())
            .thenThrow(ServerException());

        // act
        final result = await repository.getOnAirTvSeries();

        // assert
        verify(mockRemoteDataSource.getOnAirTvSeries());
        expect(result, equals(Left(ServerFailure(''))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedOnAirTvSeries())
            .thenAnswer((_) async => [testTvCache]);

        // act
        final result = await repository.getOnAirTvSeries();

        // assert
        verify(mockLocalDataSource.getCachedOnAirTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedOnAirTvSeries())
            .thenThrow(CacheException('No Cache'));

        // act
        final result = await repository.getOnAirTvSeries();

        // assert
        verify(mockLocalDataSource.getCachedOnAirTvSeries());
        expect(result, equals(Left(CacheFailure('No Cache'))));
      });
    });
  });

  group('Popular TV Series', () {
    test('should check if device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenAnswer((_) async => []);

      // act
      await repository.getPopularTvSeries();

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getPopularTvSeries())
            .thenAnswer((_) async => tTvModelList);

        // act
        final result = await repository.getPopularTvSeries();

        // assert
        verify(mockRemoteDataSource.getPopularTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getPopularTvSeries())
            .thenAnswer((_) async => tTvModelList);

        // act
        await repository.getPopularTvSeries();

        // assert
        verify(mockRemoteDataSource.getPopularTvSeries());
        verify(mockLocalDataSource.cachePopularTvSeries([testTvCache]));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getPopularTvSeries())
            .thenThrow(ServerException());

        // act
        final result = await repository.getPopularTvSeries();

        // assert
        verify(mockRemoteDataSource.getPopularTvSeries());
        expect(result, equals(Left(ServerFailure(''))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedPopularTvSeries())
            .thenAnswer((_) async => [testTvCache]);

        // act
        final result = await repository.getPopularTvSeries();

        // assert
        verify(mockLocalDataSource.getCachedPopularTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedPopularTvSeries())
            .thenThrow(CacheException('No Cache'));

        // act
        final result = await repository.getPopularTvSeries();

        // assert
        verify(mockLocalDataSource.getCachedPopularTvSeries());
        expect(result, equals(Left(CacheFailure('No Cache'))));
      });
    });
  });

  group('Top Rated TV Series', () {
    test('should check if device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenAnswer((_) async => []);

      // act
      await repository.getTopRatedTvSeries();

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTvSeries())
            .thenAnswer((_) async => tTvModelList);

        // act
        final result = await repository.getTopRatedTvSeries();

        // assert
        verify(mockRemoteDataSource.getTopRatedTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTvSeries())
            .thenAnswer((_) async => tTvModelList);

        // act
        await repository.getTopRatedTvSeries();

        // assert
        verify(mockRemoteDataSource.getTopRatedTvSeries());
        verify(mockLocalDataSource.cacheTopRatedTvSeries([testTvCache]));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTvSeries())
            .thenThrow(ServerException());

        // act
        final result = await repository.getTopRatedTvSeries();

        // assert
        verify(mockRemoteDataSource.getTopRatedTvSeries());
        expect(result, equals(Left(ServerFailure(''))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedTopRatedTvSeries())
            .thenAnswer((_) async => [testTvCache]);

        // act
        final result = await repository.getTopRatedTvSeries();

        // assert
        verify(mockLocalDataSource.getCachedTopRatedTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedTopRatedTvSeries())
            .thenThrow(CacheException('No Cache'));

        // act
        final result = await repository.getTopRatedTvSeries();

        // assert
        verify(mockLocalDataSource.getCachedTopRatedTvSeries());
        expect(result, equals(Left(CacheFailure('No Cache'))));
      });
    });
  });

  group('Get Tv Detail', () {
    const tId = 1;
    final tTvResponse = TvDetailResponse(
      firstAirDate: DateTime.parse('2001-01-01'),
      genres: const [GenreModel(id: 1, name: 'Comedy')],
      id: 1,
      name: 'name',
      numberOfSeasons: 1,
      overview: 'overview',
      popularity: 10,
      posterPath: '/path.jpg',
      seasons: [
        TvSeasonModel(
          airDate: DateTime.tryParse('2001-01-01'),
          episodeCount: 1,
          id: 1,
          name: 'name',
          overview: 'overview',
          posterPath: '/path.jpg',
          seasonNumber: 1,
        ),
      ],
      status: 'status',
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return Tv data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenAnswer((_) async => tTvResponse);

      // act
      final result = await repository.getTvDetail(tId);

      // assert
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Right(testTvDetail)));
    });

    test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tId)).thenThrow(ServerException());

      // act
      final result = await repository.getTvDetail(tId);

      // assert
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return ConnectionFailure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));

      // act
      final result = await repository.getTvDetail(tId);

      // assert
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Tv Recommendations', () {
    const tId = 1;
    final tTvList = <TvModel>[];

    test('should return recommendation tv list when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendation(tId))
          .thenAnswer((_) async => tTvList);

      // act
      final result = await repository.getTvRecommendation(tId);

      // assert
      verify(mockRemoteDataSource.getTvRecommendation(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvList));
    });

    test('should return ServerFailure when the call is unsuccessful', () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendation(tId))
          .thenThrow(ServerException());

      // act
      final result = await repository.getTvRecommendation(tId);

      // assert
      verify(mockRemoteDataSource.getTvRecommendation(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return ConnectionFailure when device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendation(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));

      // act
      final result = await repository.getTvRecommendation(tId);

      // assert
      verify(mockRemoteDataSource.getTvRecommendation(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Season Detail', () {
    const tId = 1;
    const tSeasonNumber = 1;
    final tSeasonDetailModel = TvSeasonDetailResponse(
      id: '1',
      airDate: DateTime.tryParse('2001-01-01'),
      episodes: [
        TvEpisodeModel(
          airDate: DateTime.tryParse('2001-01-01'),
          episodeNumber: 1,
          id: 1,
          name: 'name',
          overview: 'overview',
          runtime: 1,
          seasonNumber: 1,
          stillPath: '/path.jpg',
          voteAverage: 1,
          voteCount: 1,
        ),
      ],
      name: 'name',
      overview: 'overview',
      tvEpisodeId: 1,
      posterPath: '/path.jpg',
      seasonNumber: 1,
    );

    test('should return tv season detail data when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeasonDetail(tId, tSeasonNumber))
          .thenAnswer((_) async => tSeasonDetailModel);

      // act
      final result = await repository.getTvSeasonDetail(tId, tSeasonNumber);

      // assert
      verify(mockRemoteDataSource.getTvSeasonDetail(tId, tSeasonNumber));
      expect(result, equals(Right(testSeasonDetail)));
    });

    test('should return ServerFailure when the call is unsuccessful', () async {
      // arrange
      when(mockRemoteDataSource.getTvSeasonDetail(tId, tSeasonNumber))
          .thenThrow(ServerException());

      // act
      final result = await repository.getTvSeasonDetail(tId, tSeasonNumber);

      // assert
      verify(mockRemoteDataSource.getTvSeasonDetail(tId, tSeasonNumber));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return ConnectionFailure when device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeasonDetail(tId, tSeasonNumber))
          .thenThrow(const SocketException('Failed to connect to the network'));

      // act
      final result = await repository.getTvSeasonDetail(tId, tSeasonNumber);

      // assert
      verify(mockRemoteDataSource.getTvSeasonDetail(tId, tSeasonNumber));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Search TV Series', () {
    const tQuery = 'halo';

    test('should return tv list when the call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenAnswer((_) async => tTvModelList);

      // act
      final result = await repository.searchTvSeries(tQuery);

      // assert
      verify(mockRemoteDataSource.searchTvSeries(tQuery));
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return ServerFailure when the call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(ServerException());

      // act
      final result = await repository.searchTvSeries(tQuery);

      // assert
      verify(mockRemoteDataSource.searchTvSeries(tQuery));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return ConnectionFailure when device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));

      // act
      final result = await repository.searchTvSeries(tQuery);

      // assert
      verify(mockRemoteDataSource.searchTvSeries(tQuery));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');

      // act
      final result = await repository.saveWatchlist(testTvDetail);

      // assert
      verify(mockLocalDataSource.insertWatchlist(testTvTable));
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));

      // act
      final result = await repository.saveWatchlist(testTvDetail);

      // assert
      verify(mockLocalDataSource.insertWatchlist(testTvTable));
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when removing successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenAnswer((_) async => 'Removed from Watchlist');

      // act
      final result = await repository.removeWatchlist(testTvDetail);

      // assert
      verify(mockLocalDataSource.removeWatchlist(testTvTable));
      expect(result, const Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when removing unsuccessful', () async {
      // assert
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));

      // act
      final result = await repository.removeWatchlist(testTvDetail);

      // assert
      verify(mockLocalDataSource.removeWatchlist(testTvTable));
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);

      // act
      final result = await repository.isAddedToWatchlist(tId);

      // assert
      verify(mockLocalDataSource.getTvById(tId));
      expect(result, false);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of Tv Series', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvTable]);

      // act
      final result = await repository.getWatchlistTvSeries();

      // assert
      verify(mockLocalDataSource.getWatchlistTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testTvWatchlist]);
    });
  });
}

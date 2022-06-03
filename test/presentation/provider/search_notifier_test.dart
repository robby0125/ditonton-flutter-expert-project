import 'package:dartz/dartz.dart';
import 'package:ditonton/common/content_search_enum.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/provider/search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_notifier_test.mocks.dart';

@GenerateMocks([SearchMovies, SearchTvSeries])
void main() {
  late SearchNotifier provider;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTvSeries mockSearchTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchMovies = MockSearchMovies();
    mockSearchTvSeries = MockSearchTvSeries();
    provider = SearchNotifier(
      searchMovies: mockSearchMovies,
      searchTvSeries: mockSearchTvSeries,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  group('search movies', () {
    final tMovieModel = Movie(
      adult: false,
      backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
      genreIds: [14, 28],
      id: 557,
      originalTitle: 'Spider-Man',
      overview:
          'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
      popularity: 60.441,
      posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
      releaseDate: '2002-05-01',
      title: 'Spider-Man',
      video: false,
      voteAverage: 7.2,
      voteCount: 13507,
    );
    final tMovieList = <Movie>[tMovieModel];
    final tType = ContentSearch.Movie;
    final tQuery = 'spiderman';

    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      provider.performSearch(type: tType, query: tQuery);
      // assert
      expect(provider.movieState, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      await provider.performSearch(type: tType, query: tQuery);
      // assert
      expect(provider.movieState, RequestState.Loaded);
      expect(provider.searchMovieResult, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.performSearch(type: tType, query: tQuery);
      // assert
      expect(provider.movieState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('search tv series', () {
    final tTvModel = Tv(
      backdropPath: '/1qpUk27LVI9UoTS7S0EixUBj5aR.jpg',
      firstAirDate: DateTime.tryParse('2022-03-24'),
      genreIds: [10759, 10765],
      id: 52814,
      name: 'Halo',
      originCountry: ['US'],
      originalLanguage: 'en',
      originalName: 'Halo',
      overview:
          'Depicting an epic 26th-century conflict between humanity and an alien threat known as the Covenant, the series weaves deeply drawn personal stories with action, adventure and a richly imagined vision of the future.',
      popularity: 4296.232,
      posterPath: '/eO0QV5qJaEngP1Ax9w3eV6bJG2f.jpg',
      voteAverage: 8.6,
      voteCount: 818,
    );
    final tTvList = [tTvModel];
    final tType = ContentSearch.TvSeries;
    final tQuery = 'Halo';

    test('should change state to loading when use case is called', () async {
      // arrange
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));

      // act
      provider.performSearch(type: tType, query: tQuery);

      // assert
      expect(provider.tvState, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));

      // act
      await provider.performSearch(type: tType, query: tQuery);

      // assert
      expect(provider.tvState, RequestState.Loaded);
      expect(provider.searchTvResult, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      // act
      await provider.performSearch(type: tType, query: tQuery);

      // assert
      expect(provider.tvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}

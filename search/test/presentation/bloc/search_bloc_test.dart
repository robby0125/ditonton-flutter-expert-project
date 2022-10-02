import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/content_search_enum.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_tv_series.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:tv_series/tv_series.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies, SearchTvSeries])
void main() {
  late SearchBloc searchBloc;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    mockSearchTvSeries = MockSearchTvSeries();
    searchBloc = SearchBloc(
      searchMovies: mockSearchMovies,
      searchTvSeries: mockSearchTvSeries,
    );
  });

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchEmpty());
  });

  blocTest<SearchBloc, SearchState>(
    'should emit [Empty] when clearing state',
    build: () => searchBloc,
    seed: () => SearchLoading(),
    act: (bloc) => bloc.add(const ClearState()),
    expect: () => [SearchEmpty()],
  );

  group('Search movie', () {
    final tMovieModel = Movie(
      adult: false,
      backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
      genreIds: const [14, 28],
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

    const tQuery = 'spiderman';
    const tContentSearch = ContentSearch.Movie;

    blocTest<SearchBloc, SearchState>(
      'should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockSearchMovies.execute(tQuery)).thenAnswer(
          (_) async => Right(tMovieList),
        );
        return searchBloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged(
        query: tQuery,
        contentSearch: tContentSearch,
      )),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        SearchHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'should emit [Loading, Error] when get search is unsuccessfully',
      build: () {
        when(mockSearchMovies.execute(tQuery)).thenAnswer(
          (_) async => Left(
            ServerFailure('Server Failure'),
          ),
        );
        return searchBloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged(
        query: tQuery,
        contentSearch: tContentSearch,
      )),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        const SearchError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );
  });

  group('Search TV Series', () {
    final tTvModel = Tv(
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
      popularity: 4296.232,
      posterPath: '/eO0QV5qJaEngP1Ax9w3eV6bJG2f.jpg',
      voteAverage: 8.6,
      voteCount: 818,
    );
    final tTvList = [tTvModel];

    const tQuery = 'Halo';
    const tContentSearch = ContentSearch.TvSeries;

    blocTest<SearchBloc, SearchState>(
      'should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockSearchTvSeries.execute(tQuery)).thenAnswer(
          (_) async => Right(tTvList),
        );
        return searchBloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged(
        query: tQuery,
        contentSearch: tContentSearch,
      )),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        SearchHasData(tTvList),
      ],
      verify: (bloc) {
        verify(mockSearchTvSeries.execute(tQuery));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'should emit [Loading, Error] when get search is unsuccessfully',
      build: () {
        when(mockSearchTvSeries.execute(tQuery)).thenAnswer(
          (_) async => Left(
            ServerFailure('Server Failure'),
          ),
        );
        return searchBloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged(
        query: tQuery,
        contentSearch: tContentSearch,
      )),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        const SearchError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchTvSeries.execute(tQuery));
      },
    );
  });
}

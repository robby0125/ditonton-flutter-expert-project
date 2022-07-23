import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/content_search_enum.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_tv_series.dart';
import 'package:search/presentation/bloc/search_bloc.dart';

import '../provider/search_notifier_test.mocks.dart';

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
}

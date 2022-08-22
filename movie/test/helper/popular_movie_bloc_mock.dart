import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

class MockPopularMovieBloc
    extends MockBloc<FetchPopularMovies, PopularMovieState>
    implements PopularMovieBloc {}

class FakeFetchPopularMovies extends Fake implements FetchPopularMovies {}

class FakePopularMovieState extends Fake implements PopularMovieState {}

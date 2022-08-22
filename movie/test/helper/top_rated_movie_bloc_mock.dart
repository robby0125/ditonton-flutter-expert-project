import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

class MockTopRatedMovieBloc
    extends MockBloc<FetchTopRatedMovies, TopRatedMovieState>
    implements TopRatedMovieBloc {}

class FakeFetchTopRatedMovies extends Fake implements FetchTopRatedMovies {}

class FakeTopRatedMovieState extends Fake implements TopRatedMovieState {}

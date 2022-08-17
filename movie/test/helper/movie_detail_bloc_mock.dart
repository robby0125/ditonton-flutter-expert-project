import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

class MockMovieDetailBloc extends MockBloc<FetchMovieDetail, MovieDetailState>
    implements MovieDetailBloc {}

class FakeFetchMovieDetail extends Fake implements FetchMovieDetail {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

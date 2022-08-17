import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

class MockMovieWatchlistBloc
    extends MockBloc<MovieWatchlistEvent, MovieWatchlistState>
    implements MovieWatchlistBloc {}

class FakeMovieWatchlistEvent extends Fake implements MovieWatchlistEvent {}

class FakeMovieWatchlistState extends Fake implements MovieWatchlistState {}

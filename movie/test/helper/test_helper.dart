import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

class MockRouteObserver extends Mock implements RouteObserver {}

class FakeRoute extends Fake implements Route {}

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  MovieDatabaseHelper,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
])
void main() {}

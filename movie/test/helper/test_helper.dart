import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:movie/movie.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  MovieDatabaseHelper,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
  MockSpec<RouteObserver<ModalRoute>>(returnNullOnMissingStub: true),
])
void main() {}

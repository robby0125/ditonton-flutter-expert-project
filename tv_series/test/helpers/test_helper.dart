import 'package:core/utils/network_info.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

class MockRouteObserver extends Mock implements RouteObserver {}

class FakeRoute extends Fake implements Route {}

@GenerateMocks([
  TvRepository,
  TvLocalDataSource,
  TvRemoteDataSource,
  TvDatabaseHelper,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
])
void main() {}

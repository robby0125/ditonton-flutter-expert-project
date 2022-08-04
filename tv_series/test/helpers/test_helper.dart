import 'package:core/utils/network_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:tv_series/tv_series.dart';

@GenerateMocks([
  TvRepository,
  TvLocalDataSource,
  TvRemoteDataSource,
  TvDatabaseHelper,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
  MockSpec<RouteObserver<ModalRoute>>(returnNullOnMissingStub: true),
])
void main() {}

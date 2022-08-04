import 'dart:convert';

import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get on air tv series', () {
    final tTvList = TvResponse.fromJson(
      jsonDecode(readJson('dummy_data/now_playing_tv.json')),
    ).tvList;

    test('should return list of Tv Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/now_playing_tv.json'), 200));

      // act
      final result = await dataSource.getOnAirTvSeries();

      // assert
      expect(result, equals(tTvList));
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final call = dataSource.getOnAirTvSeries();

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get popular tv series', () {
    final tTvList = TvResponse.fromJson(
      jsonDecode(readJson('dummy_data/popular_tv.json')),
    ).tvList;

    test('should return Tv Model list when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/popular_tv.json'), 200));

      // act
      final result = await dataSource.getPopularTvSeries();

      // assert
      expect(result, equals(tTvList));
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final call = dataSource.getPopularTvSeries();

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get top rated tv series', () {
    final tTvList = TvResponse.fromJson(
      jsonDecode(readJson('dummy_data/top_rated_tv.json')),
    ).tvList;

    test('should return Tv Model list when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/top_rated_tv.json'), 200));

      // act
      final result = await dataSource.getTopRatedTvSeries();

      // assert
      expect(result, equals(tTvList));
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final call = dataSource.getTopRatedTvSeries();

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv detail', () {
    const tId = 1;
    final tTvDetail = TvDetailResponse.fromJson(
      jsonDecode(readJson('dummy_data/tv_detail.json')),
    );

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_detail.json'), 200));

      // act
      final result = await dataSource.getTvDetail(tId);

      // assert
      expect(result, equals(tTvDetail));
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final call = dataSource.getTvDetail(tId);

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv recommendations', () {
    const tId = 1;
    final tTvRecommendationList = TvResponse.fromJson(
      jsonDecode(readJson('dummy_data/tv_recommendations.json')),
    ).tvList;

    test('should return Tv Model list when the response code is 200', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_recommendations.json'), 200));

      // act
      final result = await dataSource.getTvRecommendation(tId);

      // assert
      expect(result, equals(tTvRecommendationList));
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final call = dataSource.getTvRecommendation(tId);

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv season detail', () {
    const tId = 1;
    const tSeasonNumber = 1;
    final tSeasonDetail = TvSeasonDetailResponse.fromJson(
      jsonDecode(readJson('dummy_data/tv_season_detail.json')),
    );

    test('should return TV Season Detail when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/season/$tSeasonNumber?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_season_detail.json'), 200));

      // act
      final result = await dataSource.getTvSeasonDetail(tId, tSeasonNumber);

      // assert
      expect(result, equals(tSeasonDetail));
    });

    test('should throw ServerException when the response is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/season/$tSeasonNumber?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final call = dataSource.getTvSeasonDetail(tId, tSeasonNumber);

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tv series', () {
    const tQuery = 'halo';
    final tSearchResult = TvResponse.fromJson(
      jsonDecode(readJson('dummy_data/search_halo_tv.json')),
    ).tvList;

    test('should return Tv Model list when the response code is 200', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/search_halo_tv.json'), 200));

      // act
      final result = await dataSource.searchTvSeries(tQuery);

      // assert
      expect(result, equals(tSearchResult));
    });

    test('should throw ServerException when the response is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final call = dataSource.searchTvSeries(tQuery);

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}

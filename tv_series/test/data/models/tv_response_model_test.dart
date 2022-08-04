import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    backdropPath: '/path.jpg',
    firstAirDate: DateTime.tryParse('2001-01-01'),
    genreIds: const [1],
    id: 1,
    name: 'name',
    originCountry: const ['en'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Tv Overview',
    popularity: 10,
    posterPath: '/path.jpg',
    voteAverage: 10,
    voteCount: 10,
  );

  final tTvResponse = TvResponse(tvList: [tTvModel]);

  group('fromJson', () {
    test('should return a valid models from JSON Map', () async {
      // arrange
      final jsonMap = jsonDecode(readJson('dummy_data/now_playing_tv.json'));

      // act
      final result = TvResponse.fromJson(jsonMap);

      // assert
      expect(result, tTvResponse);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tTvResponse.toJson();

      // assert
      final expectedJson =
          jsonDecode(readJson('dummy_data/now_playing_tv.json'));
      expect(result, expectedJson);
    });
  });
}

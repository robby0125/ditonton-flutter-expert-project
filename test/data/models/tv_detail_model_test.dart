import 'dart:convert';

import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvDetailResponse = TvDetailResponse.fromJson(
    jsonDecode(readJson('dummy_data/tv_detail.json')),
  );

  test('should return Map with proper data when toJson is called', () async {
    // act
    final result = tTvDetailResponse.toJson();

    // assert
    final expectedMap = {
      'first_air_date': '2022-03-24',
      'genres': [
        {'id': 10759, 'name': 'Action & Adventure'},
        {
          'id': 10765,
          'name': 'Sci-Fi & Fantasy',
        },
      ],
      'id': 52814,
      'name': 'Halo',
      'number_of_seasons': 1,
      'overview':
          'Depicting an epic 26th-century conflict between humanity and an alien threat known as the Covenant, the series weaves deeply drawn personal stories with action, adventure and a richly imagined vision of the future.',
      'popularity': 4296.232,
      'poster_path': '/eO0QV5qJaEngP1Ax9w3eV6bJG2f.jpg',
      'seasons': [
        {
          'air_date': '2022-03-24',
          'episode_count': 9,
          'id': 105701,
          'name': 'Season 1',
          'overview': '',
          'poster_path': '/nJUHX3XL1jMkk8honUZnUmudFb9.jpg',
          'season_number': 1,
        },
      ],
      'status': 'Returning Series',
      'vote_average': 8.6,
      'vote_count': 823,
    };
    expect(result, expectedMap);
  });
}

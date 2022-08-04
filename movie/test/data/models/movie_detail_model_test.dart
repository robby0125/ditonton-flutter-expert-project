import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/models/movie_detail_model.dart';

import '../../json_reader.dart';

void main() {
  final tMovieDetailResponse = MovieDetailResponse.fromJson(
    jsonDecode(readJson('dummy_data/movie_detail.json')),
  );

  test('should return Map with proper data when toJson is called', () {
    // act
    final result = tMovieDetailResponse.toJson();

    // assert
    final expectedMap = {
      'adult': false,
      'backdrop_path': '/path.jpg',
      'budget': 100,
      'genres': [
        {
          'id': 1,
          'name': 'Action',
        }
      ],
      'homepage': 'https://google.com',
      'id': 1,
      'imdb_id': 'imdb1',
      'original_language': 'en',
      'original_title': 'Original Title',
      'overview': 'Overview',
      'popularity': 1.0,
      'poster_path': '/path.jpg',
      'release_date': '2020-05-05',
      'revenue': 12000,
      'runtime': 120,
      'status': 'Status',
      'tagline': 'Tagline',
      'title': 'Title',
      'video': false,
      'vote_average': 1.0,
      'vote_count': 1,
    };
    expect(result, expectedMap);
  });
}

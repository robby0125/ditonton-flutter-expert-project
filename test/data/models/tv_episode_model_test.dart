import 'package:ditonton/data/models/tv_episode_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvEpisodeModel = TvEpisodeModel(
    airDate: DateTime.tryParse('2001-01-01'),
    episodeNumber: 1,
    id: 1,
    name: 'name',
    overview: 'overview',
    runtime: 24,
    seasonNumber: 1,
    stillPath: '/path.jpg',
    voteAverage: 1,
    voteCount: 1,
  );

  test('should return Map with proper data when toJson is called', () {
    // act
    final result = tTvEpisodeModel.toMap();

    // assert
    final expectedMap = {
      'air_date': '2001-01-01',
      'episode_number': 1,
      'id': 1,
      'name': 'name',
      'overview': 'overview',
      'runtime': 24,
      'season_number': 1,
      'still_path': '/path.jpg',
      'vote_average': 1,
      'vote_count': 1,
    };
    expect(result, expectedMap);
  });
}

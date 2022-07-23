import 'package:core/data/models/tv_episode_model.dart';
import 'package:core/data/models/tv_season_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvSeasonDetailResponse = TvSeasonDetailResponse(
    id: '1',
    airDate: DateTime.tryParse('2001-01-01'),
    episodes: [
      TvEpisodeModel(
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
      ),
    ],
    name: 'name',
    overview: 'overview',
    tvEpisodeId: 1,
    posterPath: '/path.jpg',
    seasonNumber: 1,
  );

  test('should return Map with proper data when toJson is called', () {
    // act
    final result = tTvSeasonDetailResponse.toJson();

    // assert
    final expectedMap = {
      "_id": '1',
      "air_date": '2001-01-01',
      "episodes": [
        {
          "air_date": '2001-01-01',
          "episode_number": 1,
          "id": 1,
          "name": 'name',
          "overview": 'overview',
          "runtime": 24,
          "season_number": 1,
          "still_path": '/path.jpg',
          "vote_average": 1,
          "vote_count": 1,
        }
      ],
      "name": 'name',
      "overview": 'overview',
      "id": 1,
      "poster_path": '/path.jpg',
      "season_number": 1,
    };
    expect(result, expectedMap);
  });
}

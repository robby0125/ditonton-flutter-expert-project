import 'package:tv_series/tv_series.dart';

const testTvTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: '/path.jpg',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'name': 'name',
  'posterPath': '/path.jpg',
  'overview': 'overview',
};

const testTvCache = TvTable(
  id: 52814,
  name: 'Halo',
  posterPath: '/eO0QV5qJaEngP1Ax9w3eV6bJG2f.jpg',
  overview:
      'Depicting an epic 26th-century conflict between humanity and an alien threat known as the Covenant, the series weaves deeply drawn personal stories with action, adventure and a richly imagined vision of the future.',
);

final testTvFromCache = Tv.watchList(
  id: 52814,
  name: 'Halo',
  posterPath: '/eO0QV5qJaEngP1Ax9w3eV6bJG2f.jpg',
  overview:
      'Depicting an epic 26th-century conflict between humanity and an alien threat known as the Covenant, the series weaves deeply drawn personal stories with action, adventure and a richly imagined vision of the future.',
);

final testTvCacheMap = {
  'id': 52814,
  'name': 'Halo',
  'posterPath': '/eO0QV5qJaEngP1Ax9w3eV6bJG2f.jpg',
  'overview':
      'Depicting an epic 26th-century conflict between humanity and an alien threat known as the Covenant, the series weaves deeply drawn personal stories with action, adventure and a richly imagined vision of the future.',
};

final testTvDetail = TvDetail(
  firstAirDate: DateTime.parse('2001-01-01'),
  genres: const [Genre(id: 1, name: 'Comedy')],
  id: 1,
  name: 'name',
  numberOfSeasons: 1,
  overview: 'overview',
  popularity: 10,
  posterPath: '/path.jpg',
  seasons: [
    TvSeason(
      airDate: DateTime.tryParse('2001-01-01'),
      episodeCount: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      posterPath: '/path.jpg',
      seasonNumber: 1,
    ),
  ],
  status: 'status',
  voteAverage: 1,
  voteCount: 1,
);

final testSeasonDetail = TvSeasonDetail(
  id: '1',
  airDate: DateTime.tryParse('2001-01-01'),
  episodes: [
    TvEpisode(
      airDate: DateTime.tryParse('2001-01-01'),
      episodeNumber: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      runtime: 1,
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

final testTvWatchlist = Tv.watchList(
  id: 1,
  name: 'name',
  posterPath: '/path.jpg',
  overview: 'overview',
);

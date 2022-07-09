import 'package:core/data/models/movie_table.dart';
import 'package:core/data/models/tv_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/entities/tv_episode.dart';
import 'package:core/domain/entities/tv_season.dart';
import 'package:core/domain/entities/tv_season_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: const [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

const testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

const testMovieCache = MovieTable(
  id: 557,
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  title: 'Spider-Man',
);

final testMovieFromCache = Movie.watchlist(
  id: 557,
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  title: 'Spider-Man',
);

final testMovieCacheMap = {
  'id': 557,
  'overview':
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  'posterPath': '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  'title': 'Spider-Man',
};

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

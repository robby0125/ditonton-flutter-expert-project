import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv_season.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  const TvDetail({
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.name,
    required this.numberOfSeasons,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.seasons,
    required this.status,
    required this.voteAverage,
    required this.voteCount,
  });

  final DateTime firstAirDate;
  final List<Genre> genres;
  final int id;
  final String name;
  final int numberOfSeasons;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<TvSeason> seasons;
  final String status;
  final double voteAverage;
  final int voteCount;

  @override
  List<Object?> get props => [
        firstAirDate,
        genres,
        id,
        name,
        numberOfSeasons,
        overview,
        popularity,
        posterPath,
        seasons,
        status,
        voteAverage,
        voteCount,
      ];
}

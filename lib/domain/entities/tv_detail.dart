import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_season.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  TvDetail({
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

  DateTime firstAirDate;
  List<Genre> genres;
  int id;
  String name;
  int numberOfSeasons;
  String overview;
  double popularity;
  String posterPath;
  List<TvSeason> seasons;
  String status;
  double voteAverage;
  int voteCount;

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

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:tv_series/data/models/genre_model.dart';
import 'package:tv_series/data/models/tv_season_model.dart';
import 'package:tv_series/domain/entities/tv_detail.dart';

class TvDetailResponse extends Equatable {
  const TvDetailResponse({
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
  final List<GenreModel> genres;
  final int id;
  final String name;
  final int numberOfSeasons;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<TvSeasonModel> seasons;
  final String status;
  final double voteAverage;
  final int voteCount;

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
        firstAirDate: DateTime.parse(json['first_air_date']),
        genres: List<GenreModel>.from(
          (json['genres'] as List).map((e) => GenreModel.fromJson(e)),
        ),
        id: json['id'],
        name: json['name'],
        numberOfSeasons: json['number_of_seasons'],
        overview: json['overview'],
        popularity: json['popularity'],
        posterPath: json['poster_path'],
        seasons: List<TvSeasonModel>.from((json['seasons'] as List)
            .map((e) => TvSeasonModel.fromJson(e))
            .where((e) => e.posterPath != null && e.seasonNumber > 0)),
        status: json['status'],
        voteAverage: json['vote_average'],
        voteCount: json['vote_count'],
      );

  Map<String, dynamic> toJson() => {
        'first_air_date': DateFormat('yyyy-MM-dd').format(firstAirDate),
        'genres': List<dynamic>.from(genres.map((x) => x.toJson())),
        'id': id,
        'name': name,
        'number_of_seasons': numberOfSeasons,
        'overview': overview,
        'popularity': popularity,
        'poster_path': posterPath,
        'seasons': List<dynamic>.from(seasons.map((e) => e.toJson())),
        'status': status,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };

  TvDetail toEntity() => TvDetail(
        firstAirDate: firstAirDate,
        genres: genres.map((e) => e.toEntity()).toList(),
        id: id,
        name: name,
        numberOfSeasons: numberOfSeasons,
        overview: overview,
        popularity: popularity,
        posterPath: posterPath,
        seasons: seasons.map((e) => e.toEntity()).toList(),
        status: status,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );

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

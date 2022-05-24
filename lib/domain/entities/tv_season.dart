import 'package:equatable/equatable.dart';

class TvSeason extends Equatable {
  TvSeason({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  DateTime? airDate;
  int episodeCount;
  int id;
  String name;
  String overview;
  String? posterPath;
  int seasonNumber;

  @override
  List<Object?> get props => [
        airDate,
        episodeCount,
        id,
        name,
        overview,
        posterPath,
        seasonNumber,
      ];
}

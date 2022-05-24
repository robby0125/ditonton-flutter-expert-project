import 'package:equatable/equatable.dart';

class TvEpisode extends Equatable {
  TvEpisode({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.runtime,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });

  DateTime? airDate;
  int episodeNumber;
  int id;
  String name;
  String overview;
  int runtime;
  int seasonNumber;
  String? stillPath;
  double voteAverage;
  int voteCount;

  @override
  List<Object?> get props => [
        airDate,
        episodeNumber,
        id,
        name,
        overview,
        runtime,
        seasonNumber,
        stillPath,
        voteAverage,
        voteCount,
      ];
}

import 'package:ditonton/domain/entities/tv_episode.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class TvEpisodeModel extends Equatable {
  TvEpisodeModel({
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

  final DateTime? airDate;
  final int episodeNumber;
  final int id;
  final String name;
  final String overview;
  final int runtime;
  final int seasonNumber;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;

  factory TvEpisodeModel.fromMap(Map<String, dynamic> json) => TvEpisodeModel(
        airDate: DateTime.tryParse(json["air_date"]),
        episodeNumber: json["episode_number"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        runtime: json["runtime"],
        seasonNumber: json["season_number"],
        stillPath: json["still_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toMap() => {
        "air_date": airDate == null ? null : DateFormat('yyyy-MM-dd').format(airDate!),
        "episode_number": episodeNumber,
        "id": id,
        "name": name,
        "overview": overview,
        "runtime": runtime,
        "season_number": seasonNumber,
        "still_path": stillPath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  TvEpisode toEntity() => TvEpisode(
        airDate: this.airDate,
        episodeNumber: this.episodeNumber,
        id: this.id,
        name: this.name,
        overview: this.overview,
        runtime: this.runtime,
        seasonNumber: this.seasonNumber,
        stillPath: this.stillPath,
        voteAverage: this.voteAverage,
        voteCount: this.voteCount,
      );

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

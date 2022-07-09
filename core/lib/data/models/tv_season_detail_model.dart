import 'package:core/data/models/tv_episode_model.dart';
import 'package:core/domain/entities/tv_season_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class TvSeasonDetailResponse extends Equatable {
  const TvSeasonDetailResponse({
    required this.id,
    required this.airDate,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.tvEpisodeId,
    required this.posterPath,
    required this.seasonNumber,
  });

  final String id;
  final DateTime? airDate;
  final List<TvEpisodeModel> episodes;
  final String name;
  final String overview;
  final int tvEpisodeId;
  final String? posterPath;
  final int seasonNumber;

  factory TvSeasonDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvSeasonDetailResponse(
        id: json["_id"],
        airDate: DateTime.tryParse(json["air_date"]),
        episodes: List<TvEpisodeModel>.from(
            json["episodes"].map((x) => TvEpisodeModel.fromMap(x))),
        name: json["name"],
        overview: json["overview"],
        tvEpisodeId: json["id"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "air_date":
            airDate == null ? null : DateFormat('yyyy-MM-dd').format(airDate!),
        "episodes": List<dynamic>.from(episodes.map((x) => x.toMap())),
        "name": name,
        "overview": overview,
        "id": tvEpisodeId,
        "poster_path": posterPath,
        "season_number": seasonNumber,
      };

  TvSeasonDetail toEntity() => TvSeasonDetail(
        id: id,
        airDate: airDate,
        episodes: episodes.map((e) => e.toEntity()).toList(),
        name: name,
        overview: overview,
        tvEpisodeId: tvEpisodeId,
        posterPath: posterPath,
        seasonNumber: seasonNumber,
      );

  @override
  List<Object?> get props => [
        id,
        airDate,
        episodes,
        name,
        overview,
        tvEpisodeId,
        posterPath,
        seasonNumber,
      ];
}

part of 'tv_season_detail_bloc.dart';

class FetchTvSeasonDetail extends Equatable {
  final int tvId;
  final int seasonNumber;

  const FetchTvSeasonDetail(this.tvId, this.seasonNumber);

  @override
  List<Object?> get props => [tvId, seasonNumber];
}

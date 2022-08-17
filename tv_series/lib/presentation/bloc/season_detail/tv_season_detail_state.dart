part of 'tv_season_detail_bloc.dart';

abstract class TvSeasonDetailState extends Equatable {
  const TvSeasonDetailState();

  @override
  List<Object> get props => [];
}

class TvSeasonDetailLoading extends TvSeasonDetailState {}

class TvSeasonDetailHasData extends TvSeasonDetailState {
  final TvDetail tvDetail;
  final TvSeasonDetail tvSeasonDetail;

  const TvSeasonDetailHasData(this.tvDetail, this.tvSeasonDetail);

  @override
  List<Object> get props => [tvDetail, tvSeasonDetail];
}

class TvSeasonDetailError extends TvSeasonDetailState {
  final String message;

  const TvSeasonDetailError(this.message);

  @override
  List<Object> get props => [message];
}

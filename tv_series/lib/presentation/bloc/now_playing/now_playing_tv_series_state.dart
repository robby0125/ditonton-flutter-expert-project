part of 'now_playing_tv_series_bloc.dart';

abstract class NowPlayingTvSeriesState extends Equatable {
  const NowPlayingTvSeriesState();

  @override
  List<Object> get props => [];
}

class NowPlayingTvSeriesLoading extends NowPlayingTvSeriesState {}

class NowPlayingTvSeriesError extends NowPlayingTvSeriesState {
  final String message;

  const NowPlayingTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingTvSeriesHasData extends NowPlayingTvSeriesState {
  final List<Tv> tvSeries;

  const NowPlayingTvSeriesHasData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

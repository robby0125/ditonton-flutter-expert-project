part of 'tv_episode_panel_bloc.dart';

class TvEpisodePanelState extends Equatable {
  final List<int> expandedIndex;

  const TvEpisodePanelState(this.expandedIndex);

  @override
  List<Object?> get props => [expandedIndex];
}

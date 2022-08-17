part of 'tv_episode_panel_bloc.dart';

abstract class TvEpisodePanelEvent extends Equatable {
  const TvEpisodePanelEvent();

  @override
  List<Object?> get props => [];
}

class OpenPanel extends TvEpisodePanelEvent {
  final int index;

  const OpenPanel(this.index);

  @override
  List<Object?> get props => [index];
}

class ClosePanel extends TvEpisodePanelEvent {
  final int index;

  const ClosePanel(this.index);

  @override
  List<Object?> get props => [index];
}

class CloseAllPanels extends TvEpisodePanelEvent {
  const CloseAllPanels();
}

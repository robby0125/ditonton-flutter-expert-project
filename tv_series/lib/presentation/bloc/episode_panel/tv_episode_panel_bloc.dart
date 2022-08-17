import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_episode_panel_event.dart';

part 'tv_episode_panel_state.dart';

class TvEpisodePanelBloc
    extends Bloc<TvEpisodePanelEvent, TvEpisodePanelState> {
  TvEpisodePanelBloc() : super(const TvEpisodePanelState([])) {
    on<OpenPanel>(_openPanel);
    on<ClosePanel>(_closePanel);
    on<CloseAllPanels>(_closeAllPanels);
  }

  void _openPanel(OpenPanel event, Emitter emit) {
    final expandedIndex = state.expandedIndex.toList();
    expandedIndex.add(event.index);
    emit(TvEpisodePanelState(expandedIndex));
  }

  void _closePanel(ClosePanel event, Emitter emit) {
    final expandedIndex = state.expandedIndex.toList();
    final closeIndex = event.index;

    if (expandedIndex.contains(closeIndex)) {
      expandedIndex.remove(closeIndex);
      emit(TvEpisodePanelState(expandedIndex));
    }
  }

  void _closeAllPanels(CloseAllPanels event, Emitter emit) {
    emit(const TvEpisodePanelState([]));
  }
}

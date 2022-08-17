import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

void main() {
  late TvEpisodePanelBloc tvEpisodePanelBloc;

  setUp(() {
    tvEpisodePanelBloc = TvEpisodePanelBloc();
  });

  test('initial state should be empty index list', () {
    expect(tvEpisodePanelBloc.state, const TvEpisodePanelState([]));
  });

  blocTest<TvEpisodePanelBloc, TvEpisodePanelState>(
    'should be add new index to expanded index list when open panel',
    build: () => tvEpisodePanelBloc,
    act: (bloc) => bloc.add(const OpenPanel(1)),
    expect: () => [
      const TvEpisodePanelState([1]),
    ],
  );

  blocTest<TvEpisodePanelBloc, TvEpisodePanelState>(
    'should be remove index from expanded index list when close panel',
    build: () => tvEpisodePanelBloc,
    seed: () => const TvEpisodePanelState([1, 2]),
    act: (bloc) => bloc.add(const ClosePanel(1)),
    expect: () => [
      const TvEpisodePanelState([2]),
    ],
  );

  blocTest<TvEpisodePanelBloc, TvEpisodePanelState>(
    'should be empty expanded index list when all panels is closed',
    build: () => tvEpisodePanelBloc,
    seed: () => const TvEpisodePanelState([1, 2]),
    act: (bloc) => bloc.add(const CloseAllPanels()),
    expect: () => [
      const TvEpisodePanelState([]),
    ],
  );
}

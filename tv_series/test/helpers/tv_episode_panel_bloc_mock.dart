import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

class MockTvEpisodePanelBloc
    extends MockBloc<TvEpisodePanelEvent, TvEpisodePanelState>
    implements TvEpisodePanelBloc {}

class FakeTvEpisodePanelEvent extends Fake implements TvEpisodePanelEvent {}

class FakeTvEpisodePanelState extends Fake implements TvEpisodePanelState {}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

class MockTvSeriesWatchlistBloc
    extends MockBloc<TvSeriesWatchlistEvent, TvSeriesWatchlistState>
    implements TvSeriesWatchlistBloc {}

class FakeTvSeriesWatchlistEvent extends Fake
    implements TvSeriesWatchlistEvent {}

class FakeTvSeriesWatchlistState extends Fake
    implements TvSeriesWatchlistState {}

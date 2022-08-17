import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

class MockTvSeriesDetailBloc
    extends MockBloc<FetchTvSeriesDetail, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

class FakeFetchTvSeriesDetail extends Fake implements FetchTvSeriesDetail {}

class FakeTvSeriesDetailState extends Fake implements TvSeriesDetailState {}

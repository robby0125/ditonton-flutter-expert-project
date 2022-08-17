import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

class MockTvSeasonDetailBloc
    extends MockBloc<FetchTvSeasonDetail, TvSeasonDetailState>
    implements TvSeasonDetailBloc {}

class FakeFetchTvSeasonDetail extends Fake implements FetchTvSeasonDetail {}

class FakeTvSeasonDetailState extends Fake implements TvSeasonDetailState {}

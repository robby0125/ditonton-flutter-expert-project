import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

class MockTopRatedTvSeriesBloc
    extends MockBloc<FetchTopRatedTvSeries, TopRatedTvSeriesState>
    implements TopRatedTvSeriesBloc {}

class FakeFetchTopRatedTvSeries extends Fake implements FetchTopRatedTvSeries {}

class FakeTopRatedTvSeriesState extends Fake implements TopRatedTvSeriesState {}

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

class MockPopularTvSeriesBloc
    extends MockBloc<FetchPopularTvSeries, PopularTvSeriesState>
    implements PopularTvSeriesBloc {}

class FakeFetchPopularTvSeries extends Fake implements FetchPopularTvSeries {}

class FakePopularTvSeriesState extends Fake implements PopularTvSeriesState {}

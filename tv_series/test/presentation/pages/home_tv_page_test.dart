import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/popular_tv_series_bloc_mock.dart';
import '../../helpers/test_helper.dart';
import '../../helpers/top_rated_tv_series_bloc_mock.dart';
import '../../helpers/tv_series_detail_bloc_mock.dart';
import '../../helpers/tv_series_watchlist_bloc_mock.dart';

class MockNowPlayingTvSeriesBloc
    extends MockBloc<FetchNowPlayingTvSeries, NowPlayingTvSeriesState>
    implements NowPlayingTvSeriesBloc {}

class FakeFetchNowPlayingTvSeries extends Fake
    implements FetchNowPlayingTvSeries {}

class FakeNowPlayingTvSeriesState extends Fake
    implements NowPlayingTvSeriesState {}

void main() {
  late MockNowPlayingTvSeriesBloc mockNowPlayingTvSeriesBloc;
  late MockPopularTvSeriesBloc mockPopularTvSeriesBloc;
  late MockTopRatedTvSeriesBloc mockTopRatedTvSeriesBloc;
  late MockTvSeriesDetailBloc mockTvSeriesDetailBloc;
  late MockTvSeriesWatchlistBloc mockTvSeriesWatchlistBloc;
  late MockRouteObserver mockRouteObserver;
  late MaterialPageRoute popularRoute;
  late MaterialPageRoute topRatedRoute;
  late MaterialPageRoute detailRoute;

  setUp(() {
    mockNowPlayingTvSeriesBloc = MockNowPlayingTvSeriesBloc();
    mockPopularTvSeriesBloc = MockPopularTvSeriesBloc();
    mockTopRatedTvSeriesBloc = MockTopRatedTvSeriesBloc();
    mockTvSeriesDetailBloc = MockTvSeriesDetailBloc();
    mockTvSeriesWatchlistBloc = MockTvSeriesWatchlistBloc();
    mockRouteObserver = MockRouteObserver();

    when(() => mockNowPlayingTvSeriesBloc.state)
        .thenReturn(NowPlayingTvSeriesHasData([testTvFromCache]));
    when(() => mockPopularTvSeriesBloc.state)
        .thenReturn(PopularTvSeriesHasData([testTvFromCache]));
    when(() => mockTopRatedTvSeriesBloc.state)
        .thenReturn(TopRatedTvSeriesHasData([testTvFromCache]));
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingTvSeriesBloc>(
          create: (_) => mockNowPlayingTvSeriesBloc,
        ),
        BlocProvider<PopularTvSeriesBloc>(
          create: (_) => mockPopularTvSeriesBloc,
        ),
        BlocProvider<TopRatedTvSeriesBloc>(
          create: (_) => mockTopRatedTvSeriesBloc,
        ),
        BlocProvider<TvSeriesDetailBloc>(
          create: (_) => mockTvSeriesDetailBloc,
        ),
        BlocProvider<TvSeriesWatchlistBloc>(
          create: (_) => mockTvSeriesWatchlistBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
        navigatorObservers: [mockRouteObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case popularTvSeriesRoute:
              popularRoute = MaterialPageRoute(
                builder: (_) => const PopularTvSeriesPage(),
              );
              return popularRoute;

            case topRatedTvSeriesRoute:
              topRatedRoute = MaterialPageRoute(
                builder: (_) => const TopRatedTvSeriesPage(),
              );
              return topRatedRoute;

            case tvDetailRoute:
              final id = settings.arguments as int;
              detailRoute = MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );

              return detailRoute;

            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }

  testWidgets('AppBar title should be Ditonton TV Series', (tester) async {
    await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Ditonton TV Series'), findsOneWidget);
  });

  testWidgets(
      'should display error message when get now playing TV Series is failed',
      (tester) async {
    when(() => mockNowPlayingTvSeriesBloc.state)
        .thenReturn(const NowPlayingTvSeriesError('Server Failure'));

    await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));

    expect(find.text('Server Failure'), findsOneWidget);
  });

  testWidgets(
      'should navigate to PopularTvSeriesPage when see more popular tapped',
      (tester) async {
    await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));

    final seeMorePopular = find.byKey(const Key('popular_heading')).last;

    expect(seeMorePopular, findsOneWidget);

    await tester.tap(seeMorePopular);
    await tester.pump();

    verify(() => mockRouteObserver.didPush(popularRoute, any()));
  });

  testWidgets(
      'should display error message when get popular TV Series is failed',
      (tester) async {
    when(() => mockPopularTvSeriesBloc.state)
        .thenReturn(const PopularTvSeriesError('Server Failure'));

    await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));

    expect(find.text('Server Failure'), findsOneWidget);
  });

  testWidgets(
      'should navigate to TopRatedTvSeriesPage when see more top rated tapped',
      (tester) async {
    await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));

    final seeMoreTopRated = find.byKey(const Key('top_rated_heading')).last;

    expect(seeMoreTopRated, findsOneWidget);

    await tester.tap(seeMoreTopRated);
    await tester.pump();

    verify(() => mockRouteObserver.didPush(topRatedRoute, any()));
  });

  testWidgets(
      'should display error message when get top rated TV Series is failed',
      (tester) async {
    when(() => mockTopRatedTvSeriesBloc.state)
        .thenReturn(const TopRatedTvSeriesError('Server Failure'));

    await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));

    expect(find.text('Server Failure'), findsOneWidget);
  });

  testWidgets('should navigate to TvDetailPage when tv item tapped',
      (tester) async {
    when(() => mockTvSeriesDetailBloc.state)
        .thenReturn(const TvSeriesDetailError('Server Failure'));
    when(() => mockTvSeriesWatchlistBloc.state)
        .thenReturn(const TvSeriesWatchlistState());

    await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));

    final tvItem = find.byKey(const Key('now_playing_0'));

    expect(tvItem, findsOneWidget);

    await tester.tap(tvItem);
    await tester.pump();

    verify(() => mockRouteObserver.didPush(detailRoute, any()));
  });
}

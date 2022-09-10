import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/popular_tv_series_bloc_mock.dart';
import '../../helpers/test_helper.dart';
import '../../helpers/tv_series_detail_bloc_mock.dart';
import '../../helpers/tv_series_watchlist_bloc_mock.dart';

void main() {
  late MockPopularTvSeriesBloc mockPopularTvSeriesBloc;
  late MockTvSeriesDetailBloc mockTvSeriesDetailBloc;
  late MockTvSeriesWatchlistBloc mockTvSeriesWatchlistBloc;
  late MockRouteObserver mockRouteObserver;
  late MaterialPageRoute detailRoute;

  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    mockPopularTvSeriesBloc = MockPopularTvSeriesBloc();
    mockTvSeriesDetailBloc = MockTvSeriesDetailBloc();
    mockTvSeriesWatchlistBloc = MockTvSeriesWatchlistBloc();
    mockRouteObserver = MockRouteObserver();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PopularTvSeriesBloc>(
          create: (_) => mockPopularTvSeriesBloc,
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

  testWidgets('should display CircularProgressIndicator when loading data',
      (tester) async {
    when(() => mockPopularTvSeriesBloc.state)
        .thenReturn(PopularTvSeriesLoading());

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'should display ListView and at least one ItemCard when data is loaded',
      (tester) async {
    when(() => mockPopularTvSeriesBloc.state)
        .thenReturn(PopularTvSeriesHasData([testTvFromCache]));

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ItemCard), findsOneWidget);
  });

  testWidgets('should display error message when load data is failed',
      (tester) async {
    when(() => mockPopularTvSeriesBloc.state)
        .thenReturn(const PopularTvSeriesError('Server Failure'));

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Server Failure'), findsOneWidget);
  });

  testWidgets('should navigate to TvDetailPage when ItemCard is tapped',
      (tester) async {
    when(() => mockPopularTvSeriesBloc.state)
        .thenReturn(PopularTvSeriesHasData([testTvFromCache]));
    when(() => mockTvSeriesDetailBloc.state).thenReturn(TvSeriesDetailHasData(
      tv: testTvDetail,
      recommendations: const [],
    ));
    when(() => mockTvSeriesWatchlistBloc.state)
        .thenReturn(const TvSeriesWatchlistState());

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ItemCard), findsWidgets);

    final buttonTv = find.byType(ItemCard).first;

    await tester.ensureVisible(buttonTv);
    await tester.tap(buttonTv);
    await tester.pump();

    verify(() => mockRouteObserver.didPush(detailRoute, any()));
  });
}

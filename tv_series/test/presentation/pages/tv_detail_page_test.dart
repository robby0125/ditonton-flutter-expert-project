import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';
import '../../helpers/tv_episode_panel_bloc_mock.dart';
import '../../helpers/tv_season_detail_bloc_mock.dart';
import '../../helpers/tv_series_detail_bloc_mock.dart';
import '../../helpers/tv_series_watchlist_bloc_mock.dart';

void main() {
  late MockTvSeriesDetailBloc mockTvSeriesDetailBloc;
  late MockTvSeriesWatchlistBloc mockTvSeriesWatchlistBloc;
  late MockTvSeasonDetailBloc mockTvSeasonDetailBloc;
  late MockTvEpisodePanelBloc mockTvEpisodePanelBloc;
  late MockRouteObserver mockRouteObserver;
  late MaterialPageRoute seasonDetailRoute;

  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    mockTvSeriesDetailBloc = MockTvSeriesDetailBloc();
    mockTvSeriesWatchlistBloc = MockTvSeriesWatchlistBloc();
    mockTvSeasonDetailBloc = MockTvSeasonDetailBloc();
    mockTvEpisodePanelBloc = MockTvEpisodePanelBloc();
    mockRouteObserver = MockRouteObserver();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvSeriesDetailBloc>(
          create: (_) => mockTvSeriesDetailBloc,
        ),
        BlocProvider<TvSeriesWatchlistBloc>(
          create: (_) => mockTvSeriesWatchlistBloc,
        ),
        BlocProvider<TvSeasonDetailBloc>(
          create: (_) => mockTvSeasonDetailBloc,
        ),
        BlocProvider<TvEpisodePanelBloc>(
          create: (_) => mockTvEpisodePanelBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
        navigatorObservers: [mockRouteObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case tvDetailRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );

            case tvSeasonDetailRoute:
              final seasonArgs = settings.arguments as List<int>;
              seasonDetailRoute = MaterialPageRoute(
                builder: (_) => TvSeasonDetailPage(
                  tvId: seasonArgs.first,
                  seasonNumber: seasonArgs.last,
                ),
                settings: settings,
              );

              return seasonDetailRoute;

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

  testWidgets('should pop when arrow back icon tapped', (tester) async {
    when(() => mockTvSeriesDetailBloc.state).thenReturn(TvSeriesDetailHasData(
      tv: testTvDetail,
      recommendations: const [],
    ));
    when(() => mockTvSeriesWatchlistBloc.state)
        .thenReturn(const TvSeriesWatchlistState());

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    final backArrowButton = find.byIcon(Icons.arrow_back);

    await tester.tap(backArrowButton);
    await tester.pump();

    verify(() => mockRouteObserver.didPop(any(), any()));
  });

  group('Load Tv Detail', () {
    group('data not loaded', () {
      testWidgets(
          'should display CircularProgressIndicator when loading tv detail data',
          (tester) async {
        when(() => mockTvSeriesDetailBloc.state)
            .thenReturn(TvSeriesDetailLoading());
        when(() => mockTvSeriesWatchlistBloc.state)
            .thenReturn(const TvSeriesWatchlistState());

        await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets(
          'should display Text with error message when loading tv detail data is failed',
          (tester) async {
        when(() => mockTvSeriesDetailBloc.state)
            .thenReturn(const TvSeriesDetailError('Server Failure'));
        when(() => mockTvSeriesWatchlistBloc.state)
            .thenReturn(const TvSeriesWatchlistState());

        await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

        expect(find.byType(Text), findsOneWidget);
        expect(find.text('Server Failure'), findsOneWidget);
      });
    });

    group('data loaded', () {
      setUp(() {
        when(() => mockTvSeriesDetailBloc.state).thenReturn(
          TvSeriesDetailHasData(
            tv: testTvDetail,
            recommendations: [testTvFromCache],
          ),
        );
        when(() => mockTvSeriesWatchlistBloc.state)
            .thenReturn(const TvSeriesWatchlistState());
      });

      testWidgets(
          'should display many Text widget and  tv title when loading tv detail data is success',
          (tester) async {
        await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

        expect(find.byType(Text), findsWidgets);
        expect(find.text(testTvDetail.name), findsOneWidget);
      });

      testWidgets(
          'should navigate to TvSeasonDetailPage when season InkWell is tapped',
          (tester) async {
        when(() => mockTvSeasonDetailBloc.state)
            .thenReturn(TvSeasonDetailHasData(testTvDetail, testSeasonDetail));
        when(() => mockTvEpisodePanelBloc.state)
            .thenReturn(const TvEpisodePanelState([]));

        await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

        final seasonButton = find.byKey(const Key('season_button_0'));
        expect(seasonButton, findsWidgets);

        await tester.ensureVisible(seasonButton);
        await tester.tap(seasonButton);
        await tester.pump();

        verify(() => mockRouteObserver.didPush(seasonDetailRoute, any()));
      });

      testWidgets(
          'should push replacement to TvDetailPage when recommendation is tapped',
          (tester) async {
        await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

        final recommendationButton =
            find.byKey(const Key('recommendation_button'));
        expect(recommendationButton, findsWidgets);

        await tester.ensureVisible(recommendationButton.first);
        await tester.tap(recommendationButton.first);
        await tester.pump();

        verify(() => mockRouteObserver.didPush(any(), any()));
        expect(find.byType(TvDetailPage), findsOneWidget);
      });
    });
  });

  group('Watchlist', () {
    setUp(() {
      when(() => mockTvSeriesDetailBloc.state).thenReturn(
        TvSeriesDetailHasData(
          tv: testTvDetail,
          recommendations: [testTvFromCache],
        ),
      );
    });

    testWidgets(
        'Watchlist button should display add icon when tv not added to watchlist',
        (tester) async {
      when(() => mockTvSeriesWatchlistBloc.state)
          .thenReturn(const TvSeriesWatchlistState());

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display check icon when tv is added to watchlist',
        (tester) async {
      when(() => mockTvSeriesWatchlistBloc.state)
          .thenReturn(const TvSeriesWatchlistState(isAddedToWatchlist: true));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display SnackBar when add to watchlist',
        (tester) async {
      when(() => mockTvSeriesWatchlistBloc.state)
          .thenReturn(const TvSeriesWatchlistState(isAddedToWatchlist: false));
      whenListen(
        mockTvSeriesWatchlistBloc,
        Stream.fromIterable([
          const TvSeriesWatchlistState(isAddedToWatchlist: false),
          const TvSeriesWatchlistState(
            message: 'Added to Watchlist',
            isAddedToWatchlist: true,
          ),
        ]),
      );

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton, warnIfMissed: false);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display AlertDialog when add to watchlist is failed',
        (tester) async {
      when(() => mockTvSeriesWatchlistBloc.state)
          .thenReturn(const TvSeriesWatchlistState(isAddedToWatchlist: false));
      whenListen(
        mockTvSeriesWatchlistBloc,
        Stream.fromIterable([
          const TvSeriesWatchlistState(isAddedToWatchlist: false),
          const TvSeriesWatchlistState(
            message: 'Failed',
            isAddedToWatchlist: false,
          ),
        ]),
      );

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton, warnIfMissed: false);
      await tester.pump();

      expect(find.byType(AlertDialog), findsWidgets);
      expect(find.text('Failed'), findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display SnackBar when removed from watchlist',
        (tester) async {
      when(() => mockTvSeriesWatchlistBloc.state)
          .thenReturn(const TvSeriesWatchlistState(isAddedToWatchlist: true));
      whenListen(
        mockTvSeriesWatchlistBloc,
        Stream.fromIterable([
          const TvSeriesWatchlistState(isAddedToWatchlist: true),
          const TvSeriesWatchlistState(
            message: 'Removed from Watchlist',
            isAddedToWatchlist: false,
          ),
        ]),
      );

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

      expect(find.byIcon(Icons.check), findsOneWidget);

      await tester.tap(watchlistButton, warnIfMissed: false);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Removed from Watchlist'), findsOneWidget);
    });
  });

  group('Recommendations', () {
    setUp(() {
      when(() => mockTvSeriesWatchlistBloc.state)
          .thenReturn(const TvSeriesWatchlistState());
    });

    testWidgets(
        'should display ListView recommendations when data gotten is successful',
        (tester) async {
      when(() => mockTvSeriesDetailBloc.state).thenReturn(TvSeriesDetailHasData(
          tv: testTvDetail, recommendations: [testTvFromCache]));

      await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

      expect(find.byType(ListView), findsNWidgets(2));
    });

    testWidgets(
        'should display No Recommendation text when tv recommendation is empty',
        (tester) async {
      when(() => mockTvSeriesDetailBloc.state).thenReturn(
        TvSeriesDetailHasData(
          tv: testTvDetail,
          recommendations: const [],
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

      expect(find.text('No Recommendation'), findsOneWidget);
    });
  });
}

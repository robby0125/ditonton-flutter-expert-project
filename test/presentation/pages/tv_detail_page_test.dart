import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_season_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv_season_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import 'tv_detail_page_test.mocks.dart';
import 'tv_season_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailNotifier])
void main() {
  late MockTvDetailNotifier mockTvDetailNotifier;
  late MockTvSeasonDetailNotifier mockTvSeasonDetailNotifier;
  late MockRouteObserver mockRouteObserver;

  setUp(() {
    mockTvDetailNotifier = MockTvDetailNotifier();
    mockTvSeasonDetailNotifier = MockTvSeasonDetailNotifier();
    mockRouteObserver = MockRouteObserver();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TvDetailNotifier>.value(
          value: mockTvDetailNotifier,
        ),
        ChangeNotifierProvider<TvSeasonDetailNotifier>.value(
          value: mockTvSeasonDetailNotifier,
        ),
      ],
      child: MaterialApp(
        home: body,
        navigatorObservers: [mockRouteObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );

            case TvSeasonDetailPage.ROUTE_NAME:
              final seasonArgs = settings.arguments as List<int>;
              return MaterialPageRoute(
                builder: (_) => TvSeasonDetailPage(
                  tvId: seasonArgs.first,
                  seasonNumber: seasonArgs.last,
                ),
                settings: settings,
              );

            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
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
    when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockTvDetailNotifier.tv).thenReturn(testTvDetail);
    when(mockTvDetailNotifier.recommendationState)
        .thenReturn(RequestState.Loaded);
    when(mockTvDetailNotifier.tvRecommendation).thenReturn([]);
    when(mockTvDetailNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    final backArrowButton = find.byIcon(Icons.arrow_back);

    await tester.tap(backArrowButton);
    await tester.pumpAndSettle();

    verify(mockRouteObserver.didPop(any, any));
  });

  group('Load Tv Detail', () {
    group('data not loaded', () {
      testWidgets(
          'should display CircularProgressIndicator when loading tv detail data',
          (tester) async {
        when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loading);

        await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets(
          'should display Text with error message when loading tv detail data is failed',
          (tester) async {
        when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Error);
        when(mockTvDetailNotifier.message).thenReturn('Server Failure');

        await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

        expect(find.byType(Text), findsOneWidget);
        expect(find.text('Server Failure'), findsOneWidget);
      });
    });

    group('data loaded', () {
      setUp(() {
        when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockTvDetailNotifier.tv).thenReturn(testTvDetail);
        when(mockTvDetailNotifier.recommendationState)
            .thenReturn(RequestState.Loaded);
        when(mockTvDetailNotifier.tvRecommendation)
            .thenReturn([testTvFromCache]);
        when(mockTvDetailNotifier.isAddedToWatchlist).thenReturn(false);
      });

      testWidgets(
          'should display many Text widget and  tv title when loading tv detail data is success',
          (tester) async {
        await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

        expect(find.byType(Text), findsWidgets);
        expect(find.text(testTvDetail.name), findsOneWidget);
      });

      testWidgets(
          'should navigate to TvSeasonDetailPage when season InkWell is tapped',
          (tester) async {
        when(mockTvSeasonDetailNotifier.requestState)
            .thenReturn(RequestState.Empty);
        when(mockTvSeasonDetailNotifier.message).thenReturn('Empty');

        await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

        final seasonButton = find.byKey(Key('season_button_0'));
        expect(seasonButton, findsWidgets);

        await tester.ensureVisible(seasonButton);
        await tester.tap(seasonButton);
        await tester.pumpAndSettle();

        verify(mockRouteObserver.didPush(any, any));
        expect(find.byType(TvSeasonDetailPage), findsOneWidget);
      });

      testWidgets(
          'should push replacement to TvDetailPage when recommendation is tapped',
          (tester) async {
        await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

        final recommendationButton = find.byKey(Key('recommendation_button'));
        expect(recommendationButton, findsWidgets);

        await tester.ensureVisible(recommendationButton.first);
        await tester.tap(recommendationButton.first);
        await tester.pump();

        verify(mockRouteObserver.didPush(any, any));
        expect(find.byType(TvDetailPage), findsOneWidget);
      });
    });
  });

  group('Watchlist', () {
    setUp(() {
      when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loaded);
      when(mockTvDetailNotifier.tv).thenReturn(testTvDetail);
      when(mockTvDetailNotifier.recommendationState)
          .thenReturn(RequestState.Loaded);
      when(mockTvDetailNotifier.tvRecommendation).thenReturn([]);
    });

    testWidgets(
        'Watchlist button should display add icon when tv not added to watchlist',
        (tester) async {
      when(mockTvDetailNotifier.isAddedToWatchlist).thenReturn(false);

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display check icon when tv is added to watchlist',
        (tester) async {
      when(mockTvDetailNotifier.isAddedToWatchlist).thenReturn(true);

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display SnackBar when add to watchlist',
        (tester) async {
      when(mockTvDetailNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockTvDetailNotifier.watchlistMessage)
          .thenReturn('Added to Watchlist');

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display AlertDialog when add to watchlist is failed',
        (tester) async {
      when(mockTvDetailNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockTvDetailNotifier.watchlistMessage).thenReturn('Failed');

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display SnackBar when removed from watchlist',
        (tester) async {
      when(mockTvDetailNotifier.isAddedToWatchlist).thenReturn(true);
      when(mockTvDetailNotifier.watchlistMessage)
          .thenReturn('Removed from Watchlist');

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

      expect(find.byIcon(Icons.check), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Removed from Watchlist'), findsOneWidget);
    });
  });

  group('Recommendations', () {
    setUp(() {
      when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loaded);
      when(mockTvDetailNotifier.tv).thenReturn(testTvDetail);
      when(mockTvDetailNotifier.isAddedToWatchlist).thenReturn(false);
    });

    testWidgets(
        'should display CircularProgressIndicator at recommendations section when data is loading',
        (tester) async {
      when(mockTvDetailNotifier.recommendationState)
          .thenReturn(RequestState.Loading);
      when(mockTvDetailNotifier.tvRecommendation).thenReturn([]);

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

      expect(find.byKey(Key('recommendation_progress')), findsOneWidget);
    });

    testWidgets(
        'should display ListView recommendations when data gotten is successful',
        (tester) async {
      when(mockTvDetailNotifier.recommendationState)
          .thenReturn(RequestState.Loaded);
      when(mockTvDetailNotifier.tvRecommendation).thenReturn([testTvFromCache]);

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

      expect(find.byType(ListView), findsNWidgets(2));
    });

    testWidgets(
        'should display error message at recommendations section when loading data is failed',
        (tester) async {
      when(mockTvDetailNotifier.recommendationState)
          .thenReturn(RequestState.Error);
      when(mockTvDetailNotifier.tvRecommendation).thenReturn([]);
      when(mockTvDetailNotifier.message).thenReturn('Server Failure');

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

      expect(find.byKey(Key('recommendation_error')), findsOneWidget);
      expect(find.text('Server Failure'), findsOneWidget);
    });

    testWidgets(
        'should display No Recommendation text when tv recommendation is empty',
        (tester) async {
      when(mockTvDetailNotifier.recommendationState)
          .thenReturn(RequestState.Empty);
      when(mockTvDetailNotifier.tvRecommendation).thenReturn([]);

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

      expect(find.text('No Recommendation'), findsOneWidget);
    });
  });
}

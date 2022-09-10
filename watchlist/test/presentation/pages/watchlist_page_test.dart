import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';
import 'package:watchlist/watchlist.dart';

class MockWatchlistMovieBloc
    extends MockBloc<FetchWatchlistMovie, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class MockWatchlistTvSeriesBloc
    extends MockBloc<FetchWatchlistTvSeries, WatchlistTvSeriesState>
    implements WatchlistTvSeriesBloc {}

class MockMovieDetailBloc extends MockBloc<FetchMovieDetail, MovieDetailState>
    implements MovieDetailBloc {}

class MockRouteObserver extends Mock implements RouteObserver {}

class FakeRoute extends Fake implements Route {}

void main() {
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;
  late MockWatchlistTvSeriesBloc mockWatchlistTvSeriesBloc;
  late MockRouteObserver mockRouteObserver;

  setUp(() {
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
    mockWatchlistTvSeriesBloc = MockWatchlistTvSeriesBloc();
    mockRouteObserver = MockRouteObserver();

    when(() => mockWatchlistMovieBloc.state)
        .thenReturn(WatchlistMovieLoading());
    when(() => mockWatchlistTvSeriesBloc.state)
        .thenReturn(WatchlistTvSeriesLoading());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WatchlistMovieBloc>(
          create: (_) => mockWatchlistMovieBloc,
        ),
        BlocProvider<WatchlistTvSeriesBloc>(
          create: (_) => mockWatchlistTvSeriesBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
        navigatorObservers: [mockRouteObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
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

  testWidgets('AppBar title should be Watchlist', (tester) async {
    await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Watchlist'), findsOneWidget);
  });

  group('Watchlist Movie', () {
    final testMovieWatchlist = Movie.watchlist(
      id: 1,
      overview: 'overview',
      posterPath: 'posterPath',
      title: 'title',
    );

    testWidgets('should display movie watchlist list when data is not empty',
        (tester) async {
      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(WatchlistMovieHasData([testMovieWatchlist]));

      await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));

      expect(find.byKey(const Key('movie_watchlist_listview')), findsOneWidget);
    });

    testWidgets(
        'should display error message when get movie watchlist data is failed',
        (tester) async {
      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(const WatchlistMovieError('Server Failure'));

      await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));

      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('Server Failure'), findsOneWidget);
    });

    testWidgets(
        'should display default error message when movie watchlist data is empty',
        (tester) async {
      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(WatchlistMovieEmpty());

      await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));

      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('Empty Movie Watchlist'), findsOneWidget);
    });
  });

  group('Watchlist TV Series', () {
    final testTvWatchlist = Tv.watchList(
      id: 1,
      overview: 'overview',
      posterPath: 'posterPath',
      name: 'name',
    );

    testWidgets(
        'should display tv series watchlist list when data is not empty',
        (tester) async {
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesHasData([testTvWatchlist]));

      await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));

      final tvTab = find.byKey(const Key('tv_tab'));

      expect(tvTab, findsOneWidget);

      await tester.tap(tvTab);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byKey(const Key('tv_watchlist_listview')), findsOneWidget);
    });

    testWidgets(
        'should display error message when get tv watchlist data is failed',
        (tester) async {
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(const WatchlistTvSeriesError('Server Failure'));

      await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));

      final tvTab = find.byKey(const Key('tv_tab'));

      expect(tvTab, findsOneWidget);

      await tester.tap(tvTab);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('Server Failure'), findsOneWidget);
    });

    testWidgets(
        'should display default error message when tv watchlist data is empty',
        (tester) async {
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesEmpty());

      await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));

      final tvTab = find.byKey(const Key('tv_tab'));

      expect(tvTab, findsOneWidget);

      await tester.tap(tvTab);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('Empty TV Watchlist'), findsOneWidget);
    });
  });
}

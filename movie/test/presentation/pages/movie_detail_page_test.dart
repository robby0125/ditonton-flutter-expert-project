import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helper/movie_detail_bloc_mock.dart';
import '../../helper/movie_watchlist_bloc_mock.dart';
import '../../helper/test_helper.dart';

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieWatchlistBloc mockMovieWatchlistBloc;
  late MockRouteObserver mockRouteObserver;

  setUpAll(() {
    registerFallbackValue(FakeMovieWatchlistEvent());
    registerFallbackValue(FakeMovieWatchlistState());
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieWatchlistBloc = MockMovieWatchlistBloc();
    mockRouteObserver = MockRouteObserver();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>(
          create: (_) => mockMovieDetailBloc,
        ),
        BlocProvider<MovieWatchlistBloc>(
          create: (_) => mockMovieWatchlistBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
        navigatorObservers: [mockRouteObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case movieDetailRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );

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

  testWidgets('should add FetchMovieDetail and LoadWatchlistStatus event on initState', (tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailLoading());

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    verify(() => mockMovieDetailBloc.add(const FetchMovieDetail(1)));
    verify(() => mockMovieWatchlistBloc.add(const LoadWatchlistStatus(1)));
  });

  testWidgets(
      'should display CircularProgressIndicator when loading data in progress',
      (tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailLoading());

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display error message when loading data is failed',
      (tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(
      const MovieDetailError('Server Failure'),
    );

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byType(Text), findsOneWidget);
    expect(find.text('Server Failure'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(const MovieDetailHasData(
      movie: testMovieDetail,
      recommendations: [],
    ));
    when(() => mockMovieWatchlistBloc.state).thenReturn(
      const MovieWatchlistState(isAddedToWatchlist: false),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(const MovieDetailHasData(
      movie: testMovieDetail,
      recommendations: [],
    ));
    when(() => mockMovieWatchlistBloc.state).thenReturn(
      const MovieWatchlistState(isAddedToWatchlist: true),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  group('Add Watchlist', () {
    setUp(() {
      when(() => mockMovieDetailBloc.state).thenReturn(const MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [],
      ));
      when(() => mockMovieWatchlistBloc.state).thenReturn(
        const MovieWatchlistState(isAddedToWatchlist: false),
      );
    });

    testWidgets('should add AddWatchlist event when add icon tapped',
        (tester) async {
      await tester.pumpWidget(
        _makeTestableWidget(const MovieDetailPage(id: 1)),
      );

      final addButton = find.byIcon(Icons.add);

      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      await tester.pump();

      verify(() =>
          mockMovieWatchlistBloc.add(const AddWatchlist(testMovieDetail)));
    });

    testWidgets('should display Snackbar when added to watchlist',
        (WidgetTester tester) async {
      whenListen(
        mockMovieWatchlistBloc,
        Stream.fromIterable([
          const MovieWatchlistState(),
          const MovieWatchlistState(
            message: 'Added to Watchlist',
            isAddedToWatchlist: true,
          ),
        ]),
      );

      await tester.pumpWidget(
        _makeTestableWidget(const MovieDetailPage(id: 1)),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    });

    testWidgets('should display AlertDialog when add to watchlist failed',
        (WidgetTester tester) async {
      whenListen(
        mockMovieWatchlistBloc,
        Stream.fromIterable([
          const MovieWatchlistState(
            message: '',
            isAddedToWatchlist: false,
          ),
          const MovieWatchlistState(
            message: 'Failed',
            isAddedToWatchlist: false,
          ),
        ]),
      );

      await tester
          .pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.byType(AlertDialog), findsWidgets);
      expect(find.text('Failed'), findsOneWidget);
    });
  });

  group('Remove Watchlist', () {
    setUp(() {
      when(() => mockMovieDetailBloc.state).thenReturn(const MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [],
      ));
      when(() => mockMovieWatchlistBloc.state).thenReturn(
        const MovieWatchlistState(isAddedToWatchlist: true),
      );
    });

    testWidgets('should add RemoveWatchlist event when check icon tapped',
        (tester) async {
      await tester.pumpWidget(
        _makeTestableWidget(const MovieDetailPage(id: 1)),
      );

      final checkButton = find.byIcon(Icons.check);

      expect(checkButton, findsOneWidget);

      await tester.tap(checkButton);
      await tester.pump();

      verify(() =>
          mockMovieWatchlistBloc.add(const RemoveWatchlist(testMovieDetail)));
    });

    testWidgets('should display SnackBar when removed from watchlist',
        (tester) async {
      whenListen(
        mockMovieWatchlistBloc,
        Stream.fromIterable([
          const MovieWatchlistState(
            message: '',
            isAddedToWatchlist: true,
          ),
          const MovieWatchlistState(
            message: 'Removed from Watchlist',
            isAddedToWatchlist: false,
          ),
        ]),
      );

      await tester.pumpWidget(
        _makeTestableWidget(const MovieDetailPage(id: 1)),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Removed from Watchlist'), findsOneWidget);
    });
  });

  testWidgets('should pop when arrow back icon tapped', (tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(const MovieDetailHasData(
      movie: testMovieDetail,
      recommendations: [],
    ));
    when(() => mockMovieWatchlistBloc.state).thenReturn(
      const MovieWatchlistState(isAddedToWatchlist: true),
    );

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    final backArrowButton = find.byIcon(Icons.arrow_back);

    await tester.tap(backArrowButton);
    await tester.pumpAndSettle();

    verify(() => mockRouteObserver.didPop(any(), any()));
  });

  testWidgets(
      'should push replacement to MovieDetailPage when recommendation is tapped',
      (tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailHasData(
      movie: testMovieDetail,
      recommendations: [testMovieFromCache],
    ));
    when(() => mockMovieWatchlistBloc.state).thenReturn(
      const MovieWatchlistState(isAddedToWatchlist: true),
    );

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    final recommendationButton = find.byKey(const Key('recommendation_button'));
    expect(recommendationButton, findsWidgets);

    await tester.ensureVisible(recommendationButton.first);
    await tester.tap(recommendationButton.first);
    await tester.pump();

    verify(() => mockRouteObserver.didPush(any(), any()));
    expect(find.byType(MovieDetailPage), findsOneWidget);
  });

  group('Recommendations', () {
    setUp(() {
      when(() => mockMovieDetailBloc.state).thenReturn(const MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [],
      ));
      when(() => mockMovieWatchlistBloc.state).thenReturn(
        const MovieWatchlistState(isAddedToWatchlist: false),
      );
    });

    testWidgets(
        'should display ListView recommendations when data gotten is successful',
        (tester) async {
      when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [testMovieFromCache],
      ));

      await tester.pumpWidget(
        _makeTestableWidget(const MovieDetailPage(id: 1)),
      );

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets(
        'should display No Recommendation text when tv recommendation is empty',
        (tester) async {
      await tester.pumpWidget(
        _makeTestableWidget(const MovieDetailPage(id: 1)),
      );

      expect(find.text('No Recommendation'), findsOneWidget);
    });
  });
}

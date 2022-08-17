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

class MockTopRatedMovieBloc
    extends MockBloc<FetchTopRatedMovies, TopRatedMovieState>
    implements TopRatedMovieBloc {}

class FakeFetchTopRatedMovies extends Fake implements FetchTopRatedMovies {}

class FakeTopRatedMovieState extends Fake implements TopRatedMovieState {}

void main() {
  late MockTopRatedMovieBloc mockTopRatedMovieBloc;
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieWatchlistBloc mockMovieWatchlistBloc;
  late MockRouteObserver mockRouteObserver;
  late MaterialPageRoute detailRoute;

  setUpAll(() {
    registerFallbackValue(FakeFetchTopRatedMovies());
    registerFallbackValue(FakeTopRatedMovieState());
    registerFallbackValue(FakeMovieWatchlistEvent());
    registerFallbackValue(FakeMovieWatchlistState());
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    mockTopRatedMovieBloc = MockTopRatedMovieBloc();
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieWatchlistBloc = MockMovieWatchlistBloc();
    mockRouteObserver = MockRouteObserver();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TopRatedMovieBloc>(
          create: (_) => mockTopRatedMovieBloc,
        ),
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
              detailRoute = MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
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

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTopRatedMovieBloc.state).thenReturn(TopRatedMoviesLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets(
      'Page should display ListView and at least one ItemCard when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTopRatedMovieBloc.state)
        .thenReturn(TopRatedMoviesHasData([testMovieFromCache]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(ItemCard), findsWidgets);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTopRatedMovieBloc.state)
        .thenReturn(const TopRatedMoviesError('Error Message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('should navigate to MovieDetailPage when ItemCard is tapped',
      (tester) async {
    when(() => mockTopRatedMovieBloc.state)
        .thenReturn(TopRatedMoviesHasData([testMovieFromCache]));
    when(() => mockMovieDetailBloc.state).thenReturn(const MovieDetailHasData(
      movie: testMovieDetail,
      recommendations: [],
    ));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(const MovieWatchlistState());

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ItemCard), findsWidgets);

    final buttonMovie = find.byType(ItemCard).first;

    await tester.ensureVisible(buttonMovie);
    await tester.tap(buttonMovie);
    await tester.pump();

    verify(() => mockRouteObserver.didPush(detailRoute, any()));
  });
}

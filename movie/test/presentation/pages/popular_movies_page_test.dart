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

class MockPopularMovieBloc
    extends MockBloc<FetchPopularMovies, PopularMovieState>
    implements PopularMovieBloc {}

class FakeFetchPopularMovies extends Fake implements FetchPopularMovies {}

class FakePopularMovieState extends Fake implements PopularMovieState {}

void main() {
  late MockPopularMovieBloc mockPopularMovieBloc;
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieWatchlistBloc mockMovieWatchlistBloc;
  late MockRouteObserver mockRouteObserver;
  late MaterialPageRoute detailRoute;

  setUpAll(() {
    registerFallbackValue(FakeFetchPopularMovies());
    registerFallbackValue(FakePopularMovieState());
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    mockPopularMovieBloc = MockPopularMovieBloc();
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieWatchlistBloc = MockMovieWatchlistBloc();
    mockRouteObserver = MockRouteObserver();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PopularMovieBloc>(
          create: (_) => mockPopularMovieBloc,
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

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockPopularMovieBloc.state).thenReturn(PopularMoviesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      'Page should display ListView and at least one ItemCard when data is loaded',
      (WidgetTester tester) async {
    when(() => mockPopularMovieBloc.state)
        .thenReturn(PopularMoviesHasData([testMovieFromCache]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(ItemCard), findsWidgets);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockPopularMovieBloc.state)
        .thenReturn(const PopularMoviesError('Error Message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('should navigate to MovieDetailPage when ItemCard is tapped', (tester) async {
    when(() => mockPopularMovieBloc.state)
        .thenReturn(PopularMoviesHasData([testMovieFromCache]));
    when(() => mockMovieDetailBloc.state).thenReturn(const MovieDetailHasData(
      movie: testMovieDetail,
      recommendations: [],
    ));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(const MovieWatchlistState());

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ItemCard), findsWidgets);

    final buttonTv = find.byType(ItemCard).first;

    await tester.ensureVisible(buttonTv);
    await tester.tap(buttonTv);
    await tester.pump();

    verify(() => mockRouteObserver.didPush(detailRoute, any()));
  });
}

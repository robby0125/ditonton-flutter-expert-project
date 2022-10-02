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
import '../../helper/popular_movie_bloc_mock.dart';
import '../../helper/test_helper.dart';
import '../../helper/top_rated_movie_bloc_mock.dart';

class MockNowPlayingMovieBloc
    extends MockBloc<FetchNowPlayingMovies, NowPlayingMovieState>
    implements NowPlayingMovieBloc {}

void main() {
  late MockNowPlayingMovieBloc mockNowPlayingMovieBloc;
  late MockPopularMovieBloc mockPopularMovieBloc;
  late MockTopRatedMovieBloc mockTopRatedMovieBloc;
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieWatchlistBloc mockMovieWatchlistBloc;
  late MockRouteObserver mockRouteObserver;
  late MaterialPageRoute popularRoute;
  late MaterialPageRoute topRatedRoute;
  late MaterialPageRoute detailRoute;
  late MaterialPageRoute searchPageRoute;

  setUp(() {
    mockNowPlayingMovieBloc = MockNowPlayingMovieBloc();
    mockPopularMovieBloc = MockPopularMovieBloc();
    mockTopRatedMovieBloc = MockTopRatedMovieBloc();
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieWatchlistBloc = MockMovieWatchlistBloc();
    mockRouteObserver = MockRouteObserver();

    when(() => mockNowPlayingMovieBloc.state)
        .thenReturn(NowPlayingMovieHasData([testMovieFromCache]));
    when(() => mockPopularMovieBloc.state)
        .thenReturn(PopularMoviesHasData([testMovieFromCache]));
    when(() => mockTopRatedMovieBloc.state)
        .thenReturn(TopRatedMoviesHasData([testMovieFromCache]));
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMovieBloc>(
          create: (_) => mockNowPlayingMovieBloc,
        ),
        BlocProvider<PopularMovieBloc>(
          create: (_) => mockPopularMovieBloc,
        ),
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
            case popularMoviesRoute:
              popularRoute = MaterialPageRoute(
                builder: (_) => const PopularMoviesPage(),
              );
              return popularRoute;

            case topRatedMovieRoute:
              topRatedRoute = MaterialPageRoute(
                builder: (_) => const TopRatedMoviesPage(),
              );
              return topRatedRoute;

            case movieDetailRoute:
              final id = settings.arguments as int;
              detailRoute = MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );

              return detailRoute;

            case searchRoute:
              searchPageRoute = MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: SizedBox.shrink(),
                  );
                },
              );
              return searchPageRoute;

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

  testWidgets('AppBar title should be Ditonton Movies', (tester) async {
    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Ditonton Movies'), findsOneWidget);
  });

  testWidgets('should navigate to search route when search icon tapped', (tester) async {
    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    final searchButton = find.byIcon(Icons.search);

    expect(searchButton, findsOneWidget);

    await tester.tap(searchButton);
    await tester.pump();

    verify(() => mockRouteObserver.didPush(searchPageRoute, any()));
  });

  testWidgets(
      'should display error message when get now playing Movie is failed',
      (tester) async {
    when(() => mockNowPlayingMovieBloc.state)
        .thenReturn(const NowPlayingMovieError('Server Failure'));

    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    expect(find.text('Server Failure'), findsOneWidget);
  });

  testWidgets(
      'should navigate to PopularMoviesPage when see more popular tapped',
      (tester) async {
    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    final seeMorePopular = find.byKey(const Key('popular_heading')).last;

    expect(seeMorePopular, findsOneWidget);

    await tester.tap(seeMorePopular);
    await tester.pump();

    verify(() => mockRouteObserver.didPush(popularRoute, any()));
  });

  testWidgets(
      'should display error message when get popular TV Series is failed',
      (tester) async {
    when(() => mockPopularMovieBloc.state)
        .thenReturn(const PopularMoviesError('Server Failure'));

    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    expect(find.text('Server Failure'), findsOneWidget);
  });

  testWidgets(
      'should navigate to TopRatedMoviesPage when see more top rated tapped',
      (tester) async {
    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    final seeMoreTopRated = find.byKey(const Key('top_rated_heading')).last;

    expect(seeMoreTopRated, findsOneWidget);

    await tester.tap(seeMoreTopRated);
    await tester.pump();

    verify(() => mockRouteObserver.didPush(topRatedRoute, any()));
  });

  testWidgets(
      'should display error message when get top rated TV Series is failed',
      (tester) async {
    when(() => mockTopRatedMovieBloc.state)
        .thenReturn(const TopRatedMoviesError('Server Failure'));

    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    expect(find.text('Server Failure'), findsOneWidget);
  });

  testWidgets('should navigate to MovieDetailPage when tv item tapped',
      (tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailError('Server Failure'));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(const MovieWatchlistState());

    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    final tvItem = find.byKey(const Key('now_playing_0'));

    expect(tvItem, findsOneWidget);

    await tester.tap(tvItem);
    await tester.pump();

    verify(() => mockRouteObserver.didPush(detailRoute, any()));
  });
}

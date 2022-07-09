import 'package:core/core.dart';
import 'package:core/presentation/pages/movie_detail_page.dart';
import 'package:core/presentation/pages/popular_movies_page.dart';
import 'package:core/presentation/provider/movie_detail_notifier.dart';
import 'package:core/presentation/provider/popular_movies_notifier.dart';
import 'package:core/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import 'movie_detail_page_test.mocks.dart';
import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([PopularMoviesNotifier])
void main() {
  late MockPopularMoviesNotifier mockPopularMoviesNotifier;
  late MockMovieDetailNotifier mockMovieDetailNotifier;
  late MockRouteObserver mockRouteObserver;

  setUp(() {
    mockPopularMoviesNotifier = MockPopularMoviesNotifier();
    mockMovieDetailNotifier = MockMovieDetailNotifier();
    mockRouteObserver = MockRouteObserver();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PopularMoviesNotifier>.value(
          value: mockPopularMoviesNotifier,
        ),
        ChangeNotifierProvider<MovieDetailNotifier>.value(
          value: mockMovieDetailNotifier,
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

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockPopularMoviesNotifier.state).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      'Page should display ListView and at least one ItemCard when data is loaded',
      (WidgetTester tester) async {
    when(mockPopularMoviesNotifier.state).thenReturn(RequestState.Loaded);
    when(mockPopularMoviesNotifier.movies).thenReturn([testMovieFromCache]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(ItemCard), findsWidgets);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockPopularMoviesNotifier.state).thenReturn(RequestState.Error);
    when(mockPopularMoviesNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('should navigate to MovieDetailPage when ItemCard is tapped',
      (tester) async {
    when(mockPopularMoviesNotifier.state).thenReturn(RequestState.Loaded);
    when(mockPopularMoviesNotifier.movies).thenReturn([testMovieFromCache]);
    when(mockMovieDetailNotifier.movieState).thenReturn(RequestState.Error);
    when(mockMovieDetailNotifier.message).thenReturn('Server Failure');

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ItemCard), findsWidgets);

    final buttonTv = find.byType(ItemCard).first;

    await tester.ensureVisible(buttonTv);
    await tester.tap(buttonTv);
    await tester.pumpAndSettle();

    verify(mockRouteObserver.didPush(any, any));
    expect(find.byType(MovieDetailPage), findsOneWidget);
  });
}

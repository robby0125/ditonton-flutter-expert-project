import 'package:core/core.dart';
import 'package:core/presentation/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import 'popular_tv_series_page_test.mocks.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([PopularTvSeriesNotifier])
void main() {
  late MockPopularTvSeriesNotifier mockPopularTvSeriesNotifier;
  late MockTvDetailNotifier mockTvDetailNotifier;
  late MockRouteObserver mockRouteObserver;

  setUp(() {
    mockPopularTvSeriesNotifier = MockPopularTvSeriesNotifier();
    mockTvDetailNotifier = MockTvDetailNotifier();
    mockRouteObserver = MockRouteObserver();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PopularTvSeriesNotifier>.value(
          value: mockPopularTvSeriesNotifier,
        ),
        ChangeNotifierProvider<TvDetailNotifier>.value(
          value: mockTvDetailNotifier,
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
    when(mockPopularTvSeriesNotifier.state).thenReturn(RequestState.Loading);

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'should display ListView and at least one ItemCard when data is loaded',
      (tester) async {
    when(mockPopularTvSeriesNotifier.state).thenReturn(RequestState.Loaded);
    when(mockPopularTvSeriesNotifier.tvSeries).thenReturn([testTvFromCache]);

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ItemCard), findsOneWidget);
  });

  testWidgets('should display error message when load data is failed',
      (tester) async {
    when(mockPopularTvSeriesNotifier.state).thenReturn(RequestState.Error);
    when(mockPopularTvSeriesNotifier.message).thenReturn('Server Failure');

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Server Failure'), findsOneWidget);
  });

  testWidgets('should navigate to TvDetailPage when ItemCard is tapped',
      (tester) async {
    when(mockPopularTvSeriesNotifier.state).thenReturn(RequestState.Loaded);
    when(mockPopularTvSeriesNotifier.tvSeries).thenReturn([testTvFromCache]);
    when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Error);
    when(mockTvDetailNotifier.message).thenReturn('Server Failure');

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ItemCard), findsWidgets);

    final buttonTv = find.byType(ItemCard).first;

    await tester.ensureVisible(buttonTv);
    await tester.tap(buttonTv);
    await tester.pumpAndSettle();

    verify(mockRouteObserver.didPush(any, any));
    expect(find.byType(TvDetailPage), findsOneWidget);
  });
}

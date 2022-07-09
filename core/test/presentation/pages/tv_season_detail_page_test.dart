import 'package:core/domain/entities/tv_episode.dart';
import 'package:core/domain/entities/tv_season_detail.dart';
import 'package:core/presentation/pages/tv_season_detail_page.dart';
import 'package:core/presentation/provider/tv_season_detail_notifier.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import 'tv_season_detail_page_test.mocks.dart';

@GenerateMocks([TvSeasonDetailNotifier])
void main() {
  late MockTvSeasonDetailNotifier mockNotifier;
  late MockRouteObserver mockRouteObserver;

  setUp(() {
    mockNotifier = MockTvSeasonDetailNotifier();
    mockRouteObserver = MockRouteObserver();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSeasonDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
        navigatorObservers: [mockRouteObserver],
      ),
    );
  }

  testWidgets('should display CircularProgressIndicator when state is Loading',
      (tester) async {
    when(mockNotifier.requestState).thenReturn(RequestState.Loading);

    await tester.pumpWidget(
      _makeTestableWidget(const TvSeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display season title when loading data is successful',
      (tester) async {
    when(mockNotifier.requestState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvDetail).thenReturn(testTvDetail);
    when(mockNotifier.tvSeasonDetail).thenReturn(testSeasonDetail);
    when(mockNotifier.curEpisodeExpanded).thenReturn(-1);

    await tester.pumpWidget(
      _makeTestableWidget(const TvSeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byType(Text), findsWidgets);
    expect(find.text(testSeasonDetail.name), findsWidgets);
  });

  testWidgets('should call expandEpisodePanel when episode panel is tapped',
      (tester) async {
    when(mockNotifier.requestState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvDetail).thenReturn(testTvDetail);
    when(mockNotifier.tvSeasonDetail).thenReturn(testSeasonDetail);
    when(mockNotifier.curEpisodeExpanded).thenReturn(-1);

    await tester.pumpWidget(
      _makeTestableWidget(const TvSeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byType(ExpansionPanelList), findsOneWidget);
    expect(find.byType(ExpandIcon), findsOneWidget);

    await tester.ensureVisible(find.byType(ExpansionPanelList));
    await tester.tap(find.byType(ExpandIcon).first);

    verify(mockNotifier.expandEpisodePanel(0));
  });

  testWidgets('should display Coming Soon when episode air date is null',
      (tester) async {
    final tSeasonDetail = testSeasonDetail;
    tSeasonDetail.episodes[0] = const TvEpisode(
      airDate: null,
      episodeNumber: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      runtime: 1,
      seasonNumber: 1,
      stillPath: '/path.jpg',
      voteAverage: 1,
      voteCount: 1,
    );

    when(mockNotifier.requestState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvDetail).thenReturn(testTvDetail);
    when(mockNotifier.tvSeasonDetail).thenReturn(tSeasonDetail);
    when(mockNotifier.curEpisodeExpanded).thenReturn(0);

    await tester.pumpWidget(
      _makeTestableWidget(const TvSeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byType(ExpansionPanelList), findsOneWidget);
    expect(find.text('Coming Soon!'), findsOneWidget);
  });

  testWidgets('should display error message when loading data is failed',
      (tester) async {
    when(mockNotifier.requestState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Server Failure');

    await tester.pumpWidget(
      _makeTestableWidget(const TvSeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byType(Text), findsOneWidget);
    expect(find.text('Server Failure'), findsOneWidget);
  });

  testWidgets('should pop when button with icon arrow_back is tapped',
      (tester) async {
    when(mockNotifier.requestState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvDetail).thenReturn(testTvDetail);
    when(mockNotifier.tvSeasonDetail).thenReturn(testSeasonDetail);
    when(mockNotifier.curEpisodeExpanded).thenReturn(-1);

    await tester.pumpWidget(
      _makeTestableWidget(const TvSeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    final backButton = find.byIcon(Icons.arrow_back);

    await tester.ensureVisible(backButton);
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    verify(mockRouteObserver.didPop(any, any));
  });

  testWidgets('should display Coming Soon text when season air date is null',
      (tester) async {
    const tSeasonDetail = TvSeasonDetail(
      id: '1',
      airDate: null,
      episodes: [],
      name: 'name',
      overview: 'overview',
      tvEpisodeId: 1,
      posterPath: '/path.jpg',
      seasonNumber: 1,
    );

    when(mockNotifier.requestState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvDetail).thenReturn(testTvDetail);
    when(mockNotifier.tvSeasonDetail).thenReturn(tSeasonDetail);
    when(mockNotifier.curEpisodeExpanded).thenReturn(-1);

    await tester.pumpWidget(
      _makeTestableWidget(const TvSeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.text('Coming Soon!'), findsOneWidget);
  });
}

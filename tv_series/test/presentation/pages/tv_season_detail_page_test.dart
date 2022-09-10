import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';
import '../../helpers/tv_episode_panel_bloc_mock.dart';
import '../../helpers/tv_season_detail_bloc_mock.dart';

void main() {
  late MockTvSeasonDetailBloc mockTvSeasonDetailBloc;
  late MockTvEpisodePanelBloc mockTvEpisodePanelBloc;
  late MockRouteObserver mockRouteObserver;

  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    mockTvSeasonDetailBloc = MockTvSeasonDetailBloc();
    mockTvEpisodePanelBloc = MockTvEpisodePanelBloc();
    mockRouteObserver = MockRouteObserver();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
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
      ),
    );
  }

  testWidgets('should display CircularProgressIndicator when state is Loading',
      (tester) async {
    when(() => mockTvSeasonDetailBloc.state)
        .thenReturn(TvSeasonDetailLoading());

    await tester.pumpWidget(
      _makeTestableWidget(const TvSeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display season title when loading data is successful',
      (tester) async {
    when(() => mockTvSeasonDetailBloc.state)
        .thenReturn(TvSeasonDetailHasData(testTvDetail, testSeasonDetail));
    when(() => mockTvEpisodePanelBloc.state)
        .thenReturn(const TvEpisodePanelState([]));

    await tester.pumpWidget(
      _makeTestableWidget(const TvSeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byType(Text), findsWidgets);
    expect(find.text(testSeasonDetail.name), findsWidgets);
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

    when(() => mockTvSeasonDetailBloc.state)
        .thenReturn(TvSeasonDetailHasData(testTvDetail, testSeasonDetail));
    when(() => mockTvEpisodePanelBloc.state)
        .thenReturn(const TvEpisodePanelState([0]));

    await tester.pumpWidget(
      _makeTestableWidget(const TvSeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byType(ExpansionPanelList), findsOneWidget);
    expect(find.text('Coming Soon!'), findsOneWidget);
  });

  testWidgets('should display error message when loading data is failed',
      (tester) async {
    when(() => mockTvSeasonDetailBloc.state)
        .thenReturn(const TvSeasonDetailError('Server Failure'));
    when(() => mockTvEpisodePanelBloc.state)
        .thenReturn(const TvEpisodePanelState([]));

    await tester.pumpWidget(
      _makeTestableWidget(const TvSeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byType(Text), findsOneWidget);
    expect(find.text('Server Failure'), findsOneWidget);
  });

  testWidgets('should pop when button with icon arrow_back is tapped',
      (tester) async {
    when(() => mockTvSeasonDetailBloc.state)
        .thenReturn(TvSeasonDetailHasData(testTvDetail, testSeasonDetail));
    when(() => mockTvEpisodePanelBloc.state)
        .thenReturn(const TvEpisodePanelState([]));

    await tester.pumpWidget(
      _makeTestableWidget(const TvSeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    final backButton = find.byIcon(Icons.arrow_back);

    await tester.ensureVisible(backButton);
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    verify(() => mockRouteObserver.didPop(any(), any()));
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

    when(() => mockTvSeasonDetailBloc.state)
        .thenReturn(TvSeasonDetailHasData(testTvDetail, tSeasonDetail));
    when(() => mockTvEpisodePanelBloc.state)
        .thenReturn(const TvEpisodePanelState([]));

    await tester.pumpWidget(
      _makeTestableWidget(const TvSeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.text('Coming Soon!'), findsOneWidget);
  });
}

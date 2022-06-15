import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  late FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    await driver.close();
  });

  group('Movies Test', () {
    test('home movies page test', () async {
      final appBarTitle = find.text('Ditonton Movies');
      final nowPlayingTitle = find.text('Now Playing');
      final popularTitle = find.text('Popular');
      final topRatedTitle = find.text('Top Rated');

      await driver.waitFor(nowPlayingTitle);
      await driver.waitFor(popularTitle);
      await driver.waitFor(topRatedTitle);

      expect(await driver.getText(appBarTitle), 'Ditonton Movies');
      expect(await driver.getText(nowPlayingTitle), 'Now Playing');
      expect(await driver.getText(popularTitle), 'Popular');
      expect(await driver.getText(topRatedTitle), 'Top Rated');
    });

    test('popular movies page test', () async {
      await driver.tap(find.byValueKey('popular_heading'));
      await driver.waitFor(find.byValueKey('popular_list'));

      final popularPageTitle = find.text('Popular Movies');

      expect(await driver.getText(popularPageTitle), 'Popular Movies');
    });

    test('top rated movies page test', () async {
      await driver.tap(find.pageBack());
      await driver.tap(find.byValueKey('top_rated_heading'));
      await driver.waitFor(find.byValueKey('top_rated_list'));

      final topRatedPageTitle = find.text('Top Rated Movies');

      expect(await driver.getText(topRatedPageTitle), 'Top Rated Movies');
    });

    test('add movie watchlist test', () async {
      await driver.tap(find.pageBack());
      await driver.tap(find.byValueKey('drawer_button'));
      await driver.tap(find.byValueKey('watchlist_button'));

      final watchlistPageTitle = find.text('Watchlist');
      final emptyWatchlistMessage = find.text('Empty Movie Watchlist');

      expect(await driver.getText(watchlistPageTitle), 'Watchlist');
      expect(
          await driver.getText(emptyWatchlistMessage), 'Empty Movie Watchlist');

      await driver.tap(find.pageBack());
      await driver.tap(find.byValueKey('movies_button'));
      await driver.tap(find.byValueKey('now_playing_0'));
      await driver.tap(find.byValueKey('watchlist_button'));

      final successMessage = find.text('Added to Watchlist');

      await driver.waitFor(successMessage);

      expect(await driver.getText(successMessage), 'Added to Watchlist');

      await driver.tap(find.byValueKey('back_button'));
      await driver.tap(find.byValueKey('drawer_button'));
      await driver.tap(find.byValueKey('watchlist_button'));
      await driver.waitFor(find.byValueKey('movie_watchlist_listview'));
    });

    test('remove movie watchlist test', () async {
      await driver.tap(find.byValueKey('movie_0'));
      await driver.tap(find.byValueKey('watchlist_button'));

      final successMessage = find.text('Removed from Watchlist');

      await driver.waitFor(successMessage);

      expect(await driver.getText(successMessage), 'Removed from Watchlist');

      await driver.tap(find.byValueKey('back_button'));

      final watchlistPageTitle = find.text('Watchlist');
      final emptyWatchlistMessage = find.text('Empty Movie Watchlist');

      expect(await driver.getText(watchlistPageTitle), 'Watchlist');
      expect(
          await driver.getText(emptyWatchlistMessage), 'Empty Movie Watchlist');
    });

    test('back to home', () async {
      await driver.tap(find.pageBack());
      await driver.tap(find.byValueKey('movies_button'));
    });
  });

  group('Tv Series Test', () {
    test('home tv series page test', () async {
      await driver.tap(find.byValueKey('drawer_button'));
      await driver.tap(find.byValueKey('tv_series_button'));

      final appBarTitle = find.text('Ditonton TV Series');
      final nowPlayingTitle = find.text('Now Playing');
      final popularTitle = find.text('Popular');
      final topRatedTitle = find.text('Top Rated');

      await driver.waitFor(appBarTitle);
      await driver.waitFor(nowPlayingTitle);
      await driver.waitFor(popularTitle);
      await driver.waitFor(topRatedTitle);

      expect(await driver.getText(appBarTitle), 'Ditonton TV Series');
      expect(await driver.getText(nowPlayingTitle), 'Now Playing');
      expect(await driver.getText(popularTitle), 'Popular');
      expect(await driver.getText(topRatedTitle), 'Top Rated');
    });

    test('popular tv series page test', () async {
      await driver.tap(find.byValueKey('popular_heading'));
      await driver.waitFor(find.byValueKey('popular_list'));

      final popularPageTitle = find.text('Popular TV Series');

      expect(await driver.getText(popularPageTitle), 'Popular TV Series');
    });

    test('top rated tv series page test', () async {
      await driver.tap(find.pageBack());
      await driver.tap(find.byValueKey('top_rated_heading'));
      await driver.waitFor(find.byValueKey('top_rated_list'));

      final topRatedPageTitle = find.text('Top Rated TV Series');

      expect(await driver.getText(topRatedPageTitle), 'Top Rated TV Series');
    });

    test('add tv watchlist test', () async {
      await driver.tap(find.pageBack());
      await driver.tap(find.byValueKey('drawer_button'));
      await driver.tap(find.byValueKey('watchlist_button'));

      final watchlistPageTitle = find.text('Watchlist');
      final emptyWatchlistMessage = find.text('Empty TV Watchlist');

      expect(await driver.getText(watchlistPageTitle), 'Watchlist');

      await driver.tap(find.byValueKey('tv_tab'));

      expect(
          await driver.getText(emptyWatchlistMessage), 'Empty TV Watchlist');

      await driver.tap(find.pageBack());
      await driver.tap(find.byValueKey('tv_series_button'));
      await driver.tap(find.byValueKey('now_playing_0'));
      await driver.tap(find.byValueKey('watchlist_button'));

      final successMessage = find.text('Added to Watchlist');

      await driver.waitFor(successMessage);

      expect(await driver.getText(successMessage), 'Added to Watchlist');

      await driver.tap(find.byValueKey('back_button'));
      await driver.tap(find.byValueKey('drawer_button'));
      await driver.tap(find.byValueKey('watchlist_button'));
      await driver.tap(find.byValueKey('tv_tab'));
      await driver.waitFor(find.byValueKey('tv_watchlist_listview'));
    });

    test('remove movie watchlist test', () async {
      await driver.tap(find.byValueKey('tv_0'));
      await driver.tap(find.byValueKey('watchlist_button'));

      final successMessage = find.text('Removed from Watchlist');

      await driver.waitFor(successMessage);

      expect(await driver.getText(successMessage), 'Removed from Watchlist');

      await driver.tap(find.byValueKey('back_button'));

      final watchlistPageTitle = find.text('Watchlist');
      final emptyWatchlistMessage = find.text('Empty TV Watchlist');

      expect(await driver.getText(watchlistPageTitle), 'Watchlist');
      expect(
          await driver.getText(emptyWatchlistMessage), 'Empty TV Watchlist');
    });

    test('back to home', () async {
      await driver.tap(find.pageBack());
      await driver.tap(find.byValueKey('tv_series_button'));
    });

    test('season detail test', () async {
      await driver.tap(find.byValueKey('popular_0'));

      final detailScrollable = find.byValueKey('detail_scrollable');
      final seasonButton = find.byValueKey('season_button_0');

      await driver.scrollUntilVisible(detailScrollable, seasonButton, dyScroll: -500);
      await driver.tap(seasonButton);
      await driver.waitFor(find.byValueKey('season_name'));
    });
  });
}

import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/provider/zoom_drawer_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  Widget _buildDrawer({
    required BuildContext context,
  }) {
    return Container(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/dicodingacademy/assets/main/flutter_expert_academy/dicoding-icon.png',
              ),
            ),
            accountName: Text('Ditonton'),
            accountEmail: Text('ditonton@dicoding.com'),
          ),
          ListTile(
            onTap: () {
              Provider.of<ZoomDrawerNotifier>(context, listen: false)
                  .switchMainScreen(mainScreen: HomeMoviePage());
            },
            leading: Icon(Icons.movie),
            title: Text('Movies'),
          ),
          ListTile(
            onTap: () {
              Provider.of<ZoomDrawerNotifier>(context, listen: false)
                  .switchMainScreen(mainScreen: HomeTvPage());
            },
            leading: Icon(Icons.tv),
            title: Text('TV Series'),
          ),
          ListTile(
            leading: Icon(Icons.save_alt),
            title: Text('Watchlist'),
            onTap: () {
              Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
            },
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
            },
            leading: Icon(Icons.info_outline),
            title: Text('About'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ZoomDrawerNotifier>(
      builder: (context, data, child) => ZoomDrawer(
        controller: data.zoomDrawerController,
        menuScreen: _buildDrawer(context: context),
        mainScreen: data.mainScreen,
        showShadow: true,
        angle: 0,
        menuBackgroundColor: Color(0xFF151E30),
      ),
    );
  }
}

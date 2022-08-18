import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _buildDrawer({
    required BuildContext context,
  }) {
    return Column(
      children: [
        const UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://raw.githubusercontent.com/dicodingacademy/certificates/main/flutter_expert_academy/dicoding-icon.png',
            ),
          ),
          accountName: Text('Ditonton'),
          accountEmail: Text('ditonton@dicoding.com'),
        ),
        ListTile(
          key: const Key('movies_button'),
          onTap: () {
            BlocProvider.of<ZoomDrawerBloc>(context).add(ToHomeMoviePage());
          },
          leading: const Icon(Icons.movie),
          title: const Text('Movies'),
        ),
        ListTile(
          key: const Key('tv_series_button'),
          onTap: () {
            BlocProvider.of<ZoomDrawerBloc>(context).add(ToHomeTvPage());
          },
          leading: const Icon(Icons.tv),
          title: const Text('TV Series'),
        ),
        ListTile(
          key: const Key('watchlist_button'),
          leading: const Icon(Icons.save_alt),
          title: const Text('Watchlist'),
          onTap: () {
            Navigator.pushNamed(context, watchListRoute);
          },
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, aboutRoute);
          },
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZoomDrawerBloc, ZoomDrawerState>(
      builder: (context, state) => ZoomDrawer(
        controller: context.read<ZoomDrawerBloc>().controller,
        menuScreen: _buildDrawer(context: context),
        mainScreen: state.mainScreen,
        showShadow: true,
        angle: 0,
        menuBackgroundColor: const Color(0xFF151E30),
      ),
    );
  }
}

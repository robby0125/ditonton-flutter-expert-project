import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/tv_episode.dart';
import 'package:ditonton/domain/entities/tv_season_detail.dart';
import 'package:ditonton/presentation/provider/tv_season_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvSeasonDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-season-detail';

  final int tvId;
  final int seasonNumber;

  TvSeasonDetailPage({
    required this.tvId,
    required this.seasonNumber,
  });

  @override
  _TvSeasonDetailPageState createState() => _TvSeasonDetailPageState();
}

class _TvSeasonDetailPageState extends State<TvSeasonDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TvSeasonDetailNotifier>(context, listen: false)
          .fetchTvSeasonDetail(widget.tvId, widget.seasonNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Consumer<TvSeasonDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.requestState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.requestState == RequestState.Loaded) {
            final _tv = provider.tvDetail;
            final _season = provider.tvSeasonDetail;

            return SafeArea(
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: '$BASE_IMAGE_URL${_season.posterPath}',
                    width: screenWidth,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 48 + 8),
                    child: DraggableScrollableSheet(
                      builder: (context, scrollController) {
                        return Container(
                          decoration: BoxDecoration(
                            color: kRichBlack,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 16,
                            right: 16,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _tv.name,
                                        style: kSubtitle,
                                      ),
                                      Text(
                                        _season.name,
                                        style: kHeading5,
                                      ),
                                      Text(
                                        '(${_season.airDate.year})',
                                        style: kSubtitle.copyWith(
                                          color: kDavysGrey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Overview',
                                        style: kHeading6,
                                      ),
                                      Text(
                                        _season.overview.isNotEmpty
                                            ? _season.overview
                                            : 'No overview',
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Episodes',
                                        style: kHeading6,
                                      ),
                                      SizedBox(height: 8),
                                      _buildEpisodeList(
                                        season: _season,
                                        seasonProvider: provider,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  color: Colors.white,
                                  height: 4,
                                  width: 48,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      // initialChildSize: 0.5,
                      minChildSize: 0.25,
                      // maxChildSize: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: kRichBlack,
                      foregroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Text(provider.message);
          }
        },
      ),
    );
  }

  ExpansionPanelList _buildEpisodeList({
    required TvSeasonDetail season,
    required TvSeasonDetailNotifier seasonProvider,
  }) {
    return ExpansionPanelList(
      children: List.generate(
        season.episodes.length,
        (index) {
          final _episode = season.episodes[index];

          return _buildEpisodePanel(
            numEpisode: index + 1,
            episode: _episode,
            isExpanded: seasonProvider.curEpisodeExpanded == index,
          );
        },
      ),
      animationDuration: Duration(milliseconds: 500),
      expansionCallback: (index, isOpen) {
        seasonProvider.expandEpisodePanel(isOpen ? -1 : index);
      },
    );
  }

  ExpansionPanel _buildEpisodePanel({
    required int numEpisode,
    required TvEpisode episode,
    required bool isExpanded,
  }) {
    return ExpansionPanel(
      headerBuilder: (_, __) {
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Episode $numEpisode',
            ),
          ),
        );
      },
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Builder(
          builder: (_) {
            if (episode.airDate != null && episode.overview.isNotEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: '$BASE_IMAGE_URL${episode.stillPath}',
                        placeholder: (_, __) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              episode.name,
                              style: kSubtitle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(showDuration(episode.runtime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: episode.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text(episode.voteAverage.toString())
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Overview',
                    style: kHeading6,
                  ),
                  Text(
                    episode.overview,
                    style: kBodyText,
                  ),
                ],
              );
            } else {
              return Container(
                height: 100,
                alignment: Alignment.center,
                child: Text(
                  'Coming Soon!',
                  style: kSubtitle,
                ),
              );
            }
          },
        ),
      ),
      canTapOnHeader: true,
      isExpanded: isExpanded,
      backgroundColor: kGrey,
    );
  }
}

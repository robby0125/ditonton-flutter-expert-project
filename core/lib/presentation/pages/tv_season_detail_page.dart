import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv_episode.dart';
import 'package:core/presentation/provider/tv_season_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvSeasonDetailPage extends StatefulWidget {
  final int tvId;
  final int seasonNumber;

  const TvSeasonDetailPage({
    Key? key,
    required this.tvId,
    required this.seasonNumber,
  }) : super(key: key);

  @override
  State<TvSeasonDetailPage> createState() => _TvSeasonDetailPageState();
}

class _TvSeasonDetailPageState extends State<TvSeasonDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TvSeasonDetailNotifier>(context, listen: false)
        ..fetchTvSeasonDetail(widget.tvId, widget.seasonNumber)
        ..expandEpisodePanel(-1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Consumer<TvSeasonDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.requestState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.requestState == RequestState.Loaded) {
            final season = provider.tvSeasonDetail;

            return SafeArea(
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: '$baseImageUrl${season.posterPath}',
                    width: screenWidth,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 48 + 8),
                    child: DraggableScrollableSheet(
                      builder: (context, scrollController) {
                        return Container(
                          decoration: const BoxDecoration(
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
                              Builder(builder: (_) {
                                if (season.airDate == null) {
                                  return const Center(
                                    child: Text('Coming Soon!'),
                                  );
                                } else {
                                  return _buildSeasonInfo(
                                    scrollController: scrollController,
                                  );
                                }
                              }),
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
                        icon: const Icon(Icons.arrow_back),
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

  Widget _buildSeasonInfo({
    required ScrollController scrollController,
  }) {
    return Consumer<TvSeasonDetailNotifier>(
        builder: (context, provider, child) {
      final tv = provider.tvDetail;
      final season = provider.tvSeasonDetail;

      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tv.name,
                style: kSubtitle,
              ),
              Text(
                season.name,
                style: kHeading5,
                key: const Key('season_name'),
              ),
              Text(
                '(${season.airDate!.year})',
                style: kSubtitle.copyWith(
                  color: kDavysGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Overview',
                style: kHeading6,
              ),
              Text(
                season.overview.isNotEmpty ? season.overview : 'No overview',
              ),
              const SizedBox(height: 16),
              Text(
                'Episodes',
                style: kHeading6,
              ),
              const SizedBox(height: 8),
              _buildEpisodeList(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEpisodeList() {
    return Consumer<TvSeasonDetailNotifier>(
        builder: (context, provider, child) {
      return ExpansionPanelList(
        children: List.generate(
          provider.tvSeasonDetail.episodes.length,
          (index) {
            final episode = provider.tvSeasonDetail.episodes[index];

            return _buildEpisodePanel(
              numEpisode: index + 1,
              episode: episode,
              isExpanded: provider.curEpisodeExpanded == index,
            );
          },
        ),
        animationDuration: const Duration(milliseconds: 500),
        expansionCallback: (index, isOpen) {
          provider.expandEpisodePanel(isOpen ? -1 : index);
        },
      );
    });
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
              key: Key('episode_panel_$numEpisode'),
            ),
          ),
        );
      },
      body: Container(
        margin: const EdgeInsets.symmetric(
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
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: '$baseImageUrl${episode.stillPath}',
                      placeholder: (_, __) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    episode.name,
                    style: kSubtitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    key: const Key('episode_name'),
                  ),
                  Text(showDuration(episode.runtime)),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: episode.voteAverage / 2,
                        itemCount: 5,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: kMikadoYellow,
                        ),
                        itemSize: 24,
                      ),
                      Text(episode.voteAverage.toString())
                    ],
                  ),
                  const SizedBox(height: 16),
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

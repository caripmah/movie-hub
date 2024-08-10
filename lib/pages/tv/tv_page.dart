import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviehub/constant/color_constant.dart';
import 'package:moviehub/constant/text_style_constant.dart';
import 'package:moviehub/controller/dahboard_controller.dart';
import 'package:moviehub/controller/tv_controller.dart';
import 'package:moviehub/pages/ai_chatboot/ai_chatbot_service.dart';
import 'package:moviehub/pages/dashbord/searh_result_page.dart';
import 'package:moviehub/pages/detail_screen/header_detail.dart';
import 'package:moviehub/pages/detail_screen/header_detail_tv_page.dart';
import 'package:moviehub/pages/tv/searh_result_tvpage.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class TvPage extends StatefulWidget {
  final ScrollController controller;
  const TvPage({super.key, required this.controller});

  @override
  State<TvPage> createState() => _TvPageState();
}

class _TvPageState extends State<TvPage> {
  final TvController tvController = Get.put(TvController());
  final TextEditingController searchController = TextEditingController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    onInit();
  }

  onInit() {
    tvController.fetchNowAiringTv();
    tvController.fetchPopularTv();
    tvController.fetchTopratedMovies();
    tvController.fetchOntheAir();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dx = screenSize.width - 75;
    final dy = screenSize.height - 150;

    return FloatingDraggableWidget(
      isDraggable: true,
      floatingWidget: FloatingActionButton(
        backgroundColor: ColorConstant.bgColors,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ChatbotService()));
        },
        child: const Icon(
          Icons.chat,
          size: 30,
          color: Colors.white,
        ),
      ),
      floatingWidgetHeight: 50,
      floatingWidgetWidth: 50,
      dx: dx,
      dy: dy,
      deleteWidgetDecoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white12, Colors.grey],
          begin: Alignment.topCenter,
          end: Alignment.center,
          stops: [.0, 1],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      deleteWidget: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: Colors.black87),
        ),
        child: const Icon(Icons.close, color: Colors.black87),
      ),
      onDeleteWidget: () {
        debugPrint('Widget deleted');
      },
      mainScreenWidget: Scaffold(
        backgroundColor: ColorConstant.bgColors,
        appBar: AppBarWithSearchSwitch(
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          theme: ThemeData.dark(),
          searchInputDecoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
          ),
          closeOnClearTwice: false,
          customTextEditingController: searchController,
          backgroundColor: ColorConstant.bgColors,
          appBarBuilder: (context) {
            return appbarWithSearch();
          },
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              if (searchController.text.isNotEmpty) {
                tvController.searchMovies(searchController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchResultsTvPage(query: searchController.text),
                  ),
                );
              }
            }
          },
          closeOnSubmit: true,
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          scrollController: widget.controller,
          onLoading: () {},
          onRefresh: () {
            onInit();
            Future.delayed(
              const Duration(seconds: 1),
              () {
                return _refreshController.refreshCompleted();
              },
            );
          },
          child: Obx(() {
            if (tvController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  contentWidget("Now Playing", tvController.AiringTvgList),
                  const SizedBox(height: 20),
                  contentWidget("Popular", tvController.OntheAirTvList),
                  const SizedBox(height: 20),
                  contentWidget("Top Rated", tvController.PopularTvList),
                  const SizedBox(height: 20),
                  contentWidget("Upcoming", tvController.TopratedTVList),
                  const SizedBox(height: 100),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  AppBar appbarWithSearch() {
    return AppBar(
      backgroundColor: ColorConstant.bgColors,
      title: const Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Movie', style: TextStyle(color: Colors.white)),
            TextSpan(
              text: 'HUB',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
      ),
      actions: const [
        AppBarSearchButton(
          searchIcon: Icons.search,
        )
      ],
    );
  }

  Widget contentWidget(String title, List<dynamic> movieList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 10),
          child: Text(
            title,
            style: TextStyleCollection.captionBold
                .copyWith(color: Colors.white, fontSize: 15),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            itemCount: movieList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final movie = movieList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HeaderDetailTv(
                                title: movie['original_name'],
                                overview: movie['overview'],
                                imageBanner: movie['backdrop_path'],
                                releaseDate: movie['first_air_date'],
                                rating: 5,
                                id: movie['id'],
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.hardEdge,
                        alignment: Alignment.centerLeft,
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w400${movie['poster_path']}',
                          errorBuilder: (context, error, stackTrace) {
                            return const CircularProgressIndicator();
                          },
                          fit: BoxFit.fill,
                          height: 180,
                          width: 130,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      Container(
                        width: 130,
                        child: Text(
                          movie['name'],
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        movie['first_air_date'] ?? 'Unknown',
                        style: TextStyleCollection.captionMedium.copyWith(
                            color: Colors.grey.shade400, fontSize: 10),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

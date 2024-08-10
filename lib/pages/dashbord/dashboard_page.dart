import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviehub/constant/color_constant.dart';
import 'package:moviehub/constant/text_style_constant.dart';
import 'package:moviehub/controller/dahboard_controller.dart';
import 'package:moviehub/pages/dashbord/searh_result_page.dart';
import 'package:moviehub/routes/app_routesname.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:carousel_slider/carousel_controller.dart' as carousel_slider;



class DashboardPage extends StatefulWidget {
  final ScrollController controller;
  const DashboardPage({super.key, required this.controller});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final MovieController movieController = Get.put(MovieController());
  final TextEditingController searchController = TextEditingController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  // Use aliases in the code
  var controller = carousel_slider.CarouselController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dx = screenSize.width - 75;
    final dy = screenSize.height - 175;

    return FloatingDraggableWidget(
      isDraggable: true,
      floatingWidget: FloatingActionButton(
        backgroundColor: ColorConstant.bgColors,
        onPressed: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => const ChatbotService()));
          Get.toNamed(AppRoutesname.chatBot);
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
                movieController.searchMovies(searchController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchResultsPage(query: searchController.text),
                  ),
                );
              }
            }
          },
          closeOnSubmit: true,
        ),
        body: SmartRefresher(
          controller: _refreshController,
          scrollController: widget.controller,
          enablePullDown: true,
          onLoading: () {},
          onRefresh: () {
            MovieController().onInit();
            return _refreshController.refreshCompleted();
          },
          child: Obx(() {
            if (movieController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  contentWidget("Now Playing", movieController.nowPlayingList,
                      isCarousel: true),
                  const SizedBox(height: 20),
                  contentWidget("Popular", movieController.popularList),
                  const SizedBox(height: 20),
                  contentWidget("Top Rated", movieController.TopratedList),
                  const SizedBox(height: 20),
                  contentWidget("Upcoming", movieController.UpcomingList),
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

  Widget contentWidget(String title, List<dynamic> movieList,
      {bool isCarousel = false}) {
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
          child: isCarousel
              ? CarouselSlider (
                carouselController: controller,
                  options: CarouselOptions(
                    height: 225.0,
                    autoPlay: true,
                    aspectRatio: 16 / 7,
                    viewportFraction: 0.99,
                  ),
                  items: movieList.map((movie) {
                    return Builder(
                      builder: (BuildContext context) {
                        return InkWell(
                          onTap: () {
                            Get.toNamed(
                              AppRoutesname.detailScreen,
                              arguments: {
                                'title': movie['original_title'],
                                'overview': movie['overview'],
                                'imageBanner': movie['backdrop_path'],
                                'releaseDate': movie['release_date'],
                                'rating':
                                    6, // Sesuaikan jika rating bukan angka tetap
                                'isMovie': true,
                                'movieId': movie['id'],
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
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
                                    fit: BoxFit.none,
                                    height: 180,
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                                Container(
                                  width: isCarousel ? double.infinity : 130,
                                  child: Text(
                                    movie['title'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isCarousel ? 18 : 12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Text(
                                  movie['release_date'] ?? 'Unknown',
                                  style: TextStyleCollection.captionMedium
                                      .copyWith(
                                          color: Colors.grey.shade400,
                                          fontSize: 10),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              : ListView.builder(
                  itemCount: movieList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final movie = movieList[index];
                    return InkWell(
                      onTap: () {
                        Get.toNamed(
                          AppRoutesname.detailScreen,
                          arguments: {
                            'title': movie['original_title'],
                            'overview': movie['overview'],
                            'imageBanner': movie['backdrop_path'],
                            'releaseDate': movie['release_date'],
                            'rating':
                                5, // Sesuaikan jika rating bukan angka tetap
                            'isMovie': true,
                            'movieId': movie['id'],
                          },
                        );
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
                                'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
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
                                movie['title'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Text(
                              movie['release_date'] ?? 'Unknown',
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
        ),
      ],
    );
  }
}

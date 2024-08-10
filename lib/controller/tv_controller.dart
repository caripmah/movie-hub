import 'package:get/get.dart';
import 'package:moviehub/services/tv_service.dart';

class TvController extends GetxController {
  var movieList = [].obs;
  var AiringTvgList = <dynamic>[].obs;
  var OntheAirTvList = <dynamic>[].obs;
  var PopularTvList = <dynamic>[].obs;
  var TopratedTVList = <dynamic>[].obs;

  var isLoading = false.obs;
  var currentPage = 1;
  var totalPages = 1;

  void searchMovies(String query) async {
    isLoading(true);
    // Reset pagination
    currentPage = 1;
    final results = await Tvservice.searchMovies(query, currentPage);
    movieList.assignAll(results['movies']);
    totalPages = results['total_pages'];
    isLoading(false);
  }

  void loadMoreMovies(String query) async {
    if (currentPage < totalPages && !isLoading.value) {
      isLoading(true);
      currentPage++;
      final results = await Tvservice.searchMovies(query, currentPage);
      movieList.addAll(results['movies']);
      isLoading(false);
    }
  }

  void fetchNowAiringTv() async {
    isLoading(true);
    final results = await Tvservice.fetchNowAiringTv(currentPage);
    AiringTvgList.assignAll(results['movies']);
    totalPages = results['total_pages'];
    isLoading(false);
  }

  void fetchPopularTv() async {
    isLoading(true);
    final results = await Tvservice.fetchPopularMovies(currentPage);
    PopularTvList.assignAll(results['movies']);
    totalPages = results['total_pages'];
    isLoading(false);
  }

  void fetchTopratedMovies() async {
    isLoading(true);
    final results = await Tvservice.fetcTopratedMovies(currentPage);
    TopratedTVList.assignAll(results['movies']);
    totalPages = results['total_pages'];
    isLoading(false);
  }

  void fetchOntheAir() async {
    isLoading(true);
    final results = await Tvservice.fetchOntheairTv(currentPage);
    OntheAirTvList.assignAll(results['movies']);
    totalPages = results['total_pages'];
    isLoading(false);
  }
}

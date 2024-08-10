import 'package:get/get.dart';
import 'package:moviehub/services/movie_service.dart';

class MovieController extends GetxController {
  var movieList = [].obs;
  var nowPlayingList = <dynamic>[].obs;
  var popularList = <dynamic>[].obs;
  var TopratedList = <dynamic>[].obs;
  var UpcomingList = <dynamic>[].obs;

  var isLoading = false.obs;
  var currentPage = 1;
  var totalPages = 1;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    callInit();
  }

  void callInit() {
    fetchNowPlayingMovies();
    fetchPopularMovies();
    fetchTopratedMovies();
    fetchUpcomingMovies();
  }

  void searchMovies(String query) async {
    isLoading(true);
    // Reset pagination
    currentPage = 1;
    final results = await MovieService.searchMovies(query, currentPage);
    movieList.assignAll(results['movies']);
    totalPages = results['total_pages'];
    isLoading(false);
  }

  void loadMoreMovies(String query) async {
    if (currentPage < totalPages && !isLoading.value) {
      isLoading(true);
      currentPage++;
      final results = await MovieService.searchMovies(query, currentPage);
      movieList.addAll(results['movies']);
      isLoading(false);
    }
  }

  void fetchNowPlayingMovies() async {
    isLoading(true);
    final results = await MovieService.fetchNowPlayingMovies(currentPage);
    nowPlayingList.assignAll(results['movies']);
    totalPages = results['total_pages'];
    isLoading(false);
  }

  void fetchPopularMovies() async {
    isLoading(true);
    final results = await MovieService.fetchPopularMovies(currentPage);
    popularList.assignAll(results['movies']);
    totalPages = results['total_pages'];
    isLoading(false);
  }

  void fetchTopratedMovies() async {
    isLoading(true);
    final results = await MovieService.fetcTopratedMovies(currentPage);
    TopratedList.assignAll(results['movies']);
    totalPages = results['total_pages'];
    isLoading(false);
  }

  void fetchUpcomingMovies() async {
    isLoading(true);
    final results = await MovieService.fetcUpcomingMovies(currentPage);
    UpcomingList.assignAll(results['movies']);
    totalPages = results['total_pages'];
    isLoading(false);
  }
}

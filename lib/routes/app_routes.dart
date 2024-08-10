import 'package:get/get.dart';
import 'package:moviehub/main_screen.dart';
import 'package:moviehub/pages/ai_chatboot/ai_chatbot_service.dart';
import 'package:moviehub/pages/detail_screen/header_detail.dart';
import 'package:moviehub/pages/login/login_page.dart';
import 'package:moviehub/pages/register/register_screen.dart';
import 'package:moviehub/pages/splash_page/splash_page.dart';
import 'package:moviehub/routes/app_routesname.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: AppRoutesname.pageLogin, page: () => const LoginPage()),
    GetPage(name: AppRoutesname.pageRegister, page: () => const RegisterPage()),
    GetPage(name: AppRoutesname.pageHome, page: () => MainScreenPage()),
    GetPage(
      name: AppRoutesname.detailScreen,
      page: () {
        final arguments = Get.arguments;
        final title = arguments['title'] ?? 'No Title';
        final overview = arguments['overview'] ?? 'No Overview';
        final imageBanner = arguments['imageBanner'] ?? 'No Image';
        final releaseDate = arguments['releaseDate'] ?? 'No Release Date';
        final rating = (arguments['rating'] is num
            ? (arguments['rating'] as num).toDouble()
            : 0.0);
        final isMovie = arguments['isMovie'] ?? false;
        final movieId = arguments['movieId'] ?? 'No Movie ID';

        return HeaderDetail(
          title: title,
          overview: overview,
          imageBanner: imageBanner,
          releaseDate: releaseDate,
          rating: rating,
          isMovie: isMovie,
          movieId: movieId,
        );
      },
    ),
    // Tambahkan rute lain sesuai kebutuhan
    GetPage(name: AppRoutesname.chatBot, page: () => const ChatbotService()),
    // splash
    GetPage(name: AppRoutesname.chatBot, page: () => const SplashPage()),
  ];
}

# 🎬 Movie Hub

Movie Hub is a modern, AI-powered movie and TV series discovery application built with Flutter. It provides users with a seamless way to explore the latest trending movies, watch trailers, and get personalized recommendations through an integrated AI chatbot.

## ✨ Features

🔍 **Smart Movie Discovery** – Browse through "Now Playing", "Popular", "Top Rated", and "Upcoming" movies and TV series powered by the TMDB API.

🤖 **AI-Powered Assistant** – Integrated Gemini AI chatbot to help you find the perfect movie based on your mood or preferences.

🎥 **Trailers & Details** – Watch high-quality YouTube trailers and view detailed information including cast, ratings, and release dates.

🔐 **Secure Authentication** – Seamless login and registration process using Firebase Authentication, including Google Sign-In support.

📱 **Interactive UI/UX** – Experience smooth animations with Rive, interactive floating buttons, and a beautiful floating bottom navigation bar.

🔔 **Push Notifications** – Stay updated with the latest releases and news through Firebase Cloud Messaging.

## 🚀 Tech Stack

- **Frontend:** [Flutter](https://flutter.dev) (Cross-platform mobile development)
- **State Management:** [GetX](https://pub.dev/packages/get)
- **Backend:** [Firebase](https://firebase.google.com) (Authentication, Firestore, Cloud Messaging)
- **AI Integration:** [Google Gemini AI](https://deepmind.google/technologies/gemini/) (via `flutter_gemini`)
- **API:** [TMDB API](https://www.themoviedb.org/documentation/api) (The Movie Database)
- **Networking:** [Dio](https://pub.dev/packages/dio) & [HTTP](https://pub.dev/packages/http)
- **Animations:** [Rive](https://rive.app) & [Flutter Animate](https://pub.dev/packages/flutter_animate)

## 📱 How It Works

1.  **Login/Register** – Create an account or sign in using Google to personalize your experience.
2.  **Explore** – Browse the latest movies and TV shows on the dashboard or use the search feature.
3.  **Interact with AI** – Click the floating chat icon to talk with the Gemini AI for personalized recommendations.
4.  **Watch & Learn** – View movie details, check ratings, and watch trailers directly within the app.

## 🛠️ Installation (For Developers)

```bash
# Clone the repository
git clone https://github.com/your-username/movie-hub.git

# Navigate into the project
cd movie-hub

# Install dependencies
flutter pub get

# Setup Environment Variables
# Create a .env file and add your TMDB bearer token and other keys
# bearer=YOUR_TMDB_BEARER_TOKEN

# Run the app
flutter run
```

## 📖 Roadmap

- [ ] Add "Watchlist" feature for users to save movies.
- [ ] Implement offline mode using local database.
- [ ] Add multi-language support.
- [ ] Integrate social sharing for movie recommendations.

## 🤝 Contributing

We welcome contributions from the community!
Feel free to fork this repo, create a branch, and submit a pull request.

## 📄 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

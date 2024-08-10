import 'package:get/get.dart';
import 'package:moviehub/services/auth_firebase.dart';

class ProfileController extends GetxController {
  var userData = {}.obs;
  final AuthMethod _authMethod = AuthMethod();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    Map<String, dynamic>? data = await _authMethod.getCurrentUser();
    if (data != null) {
      userData.value = data;
    }
  }
}

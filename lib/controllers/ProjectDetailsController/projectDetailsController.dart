import 'package:bug_tracker/views/dialogs/dialogs.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class ProjectDetailsController extends GetxController {
  RxBool isSaving = false.obs;

  Future<void> saveProjectDetails(String projectName, String projectDetails,
      List<String> selectedContributors) async {
    try {
      isSaving.value = true;
    } catch (error) {
      throw Dialogs.GENERIC_ERROR_MESSAGE;
    }
  }
}

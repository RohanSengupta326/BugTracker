import 'package:bug_tracker/models/usersDetails/usersDetails.dart';

class ProjectDetailModel {
  var projectName;
  var projectDetails;
  List<UsersDetails> selectedContributors;
  var projectId;
  ProjectDetailModel(
      {this.projectName,
      this.projectDetails,
      required this.selectedContributors,
      this.projectId});
}

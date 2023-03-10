import 'package:bug_tracker/models/ticketDetails/ticketDetails.dart';
import 'package:bug_tracker/models/usersDetails/usersDetails.dart';

class ProjectDetailModel {
  var projectName;
  var projectDetails;
  List<UsersDetails> selectedContributors;
  List<TicketDetails> ticketDetails;
  var projectId;

  ProjectDetailModel(
      {this.projectName,
      this.projectDetails,
      required this.selectedContributors,
      required this.ticketDetails,
      this.projectId});
}

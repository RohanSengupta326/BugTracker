import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailTab extends StatelessWidget {
  final projectName;
  final projectDetails;
  ProjectDetailTab({this.projectName, this.projectDetails});

  Future<void> _launchUrl(String uri) async {
    final Uri url = Uri.parse(uri);

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
      // to open in youtube
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.all(ConstValues.MARGIN),
              padding: const EdgeInsets.all(ConstValues.PADDING),
              child: Text(
                projectName,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: MarkdownBody(
                
                data: projectDetails,
                onTapLink: (text, href, title) => _launchUrl(href ?? ''),
              ),
            ),
          )
        ],
      ),
    );
  }
}

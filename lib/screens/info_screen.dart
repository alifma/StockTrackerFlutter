import 'package:bloc_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.largeMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 64,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              backgroundImage:
                  const NetworkImage('https://github.com/alifma.png'),
            ),
            const SizedBox(height: AppSizes.mediumMargin),
            const Text(
              'Hello, I am Alif Maulana',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.title,
              ),
            ),
            const Text(
              'Software Engineer',
              style: TextStyle(
                fontSize: AppFontSizes.body,
              ),
            ),
            const SizedBox(height: AppSizes.largeMargin),
            const Text(
              'This app is built with ❤️ in Flutter',
              style: TextStyle(
                fontSize: AppFontSizes.bodyLarge,
              ),
            ),
            const SizedBox(height: AppSizes.smallMargin),
            const Text(
              'Credits to data from EOD Historical Data',
              style: TextStyle(
                fontSize: AppFontSizes.bodyLarge,
              ),
            ),
            const SizedBox(height: AppSizes.mediumMargin),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: "GitHub",
                  icon: const Icon(Icons.folder),
                  onPressed: () {
                    _launchURL('https://github.com/alifma');
                  },
                ),
                IconButton(
                  tooltip: "Profile",
                  icon: const Icon(Icons.face),
                  onPressed: () {
                    _launchURL('https://alifma.github.io');
                  },
                ),
                IconButton(
                  tooltip: "LinkedIn",
                  icon: const Icon(Icons.business),
                  onPressed: () {
                    _launchURL('https://linkedin.com/in/alifma');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

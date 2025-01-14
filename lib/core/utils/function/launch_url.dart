import 'package:url_launcher/url_launcher.dart';

import 'custom_snack_bar.dart';

Future<void> launchCustomUr(context, String? url) async {
  if (url != null) {
    Uri uri = Uri.parse(url);

    try {
      await launchUrl(uri);
    } catch (e) {
      print("Error launching URL: $e");
      customSnackBar(context, 'Cannot launch $url');
    }
  }
}

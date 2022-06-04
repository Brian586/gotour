// ignore_for_file: file_names

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart';

class ShareAssistant {
  static Future<void> createAndShareUrl(
      {String urlParam,
      String title,
      String description,
      String imageUrl}) async {
    //final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String uriPrefix = "https://gotourapp.page.link";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix,
      link: Uri.parse('https://example.com/$urlParam'),
      // androidParameters: AndroidParameters(
      //   packageName: packageInfo.packageName,
      //   minimumVersion: 125,
      // ),
      // iosParameters: IosParameters(
      //   bundleId: packageInfo.packageName,
      //   minimumVersion: packageInfo.version,
      //   appStoreId: '123456789',
      // ),
      // googleAnalyticsParameters: GoogleAnalyticsParameters(
      //   campaign: 'example-promo',
      //   medium: 'social',
      //   source: 'orkut',
      // ),
      // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
      //   providerToken: '123456',
      //   campaignToken: 'example-promo',
      // ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: title,
          description: description,
          imageUrl: Uri.parse(imageUrl)),
    );

    final Uri dynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;

    print(shortUrl);

    Share.share(shortUrl.toString());
  }
}

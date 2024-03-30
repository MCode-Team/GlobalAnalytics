library global_analytics;

import 'dart:io';

import 'package:flutter/foundation.dart';
// import 'package:universal_io/io.dart'; // instead of 'dart:io';
import 'dart:convert';

import 'package:r_get_ip/r_get_ip.dart';

/// Plausible class. Use the constructor to set the parameters.
class GlobalAnalytics {
  /// The url of your plausible server e.g. https://analytics.api-globalhouse.com
  String serverUrl = "https://analytics.api-globalhouse.com";
  String apiKey = "";
  String userAgent;
  String domain;
  String screenPage;
  String userID;
  String sessionID;
  bool enabled = true;

  /// Constructor
  GlobalAnalytics(this.serverUrl, this.domain, this.apiKey,
      {this.userAgent = "",
      this.screenPage = "",
      this.userID = "",
      this.sessionID = ""});

  /// Post event to plausible
  Future<int> globalEvent(
      {String name = "pageview",
      String referrer = "",
      String page = "",
      Map<String, String> props = const {}}) async {
    if (!enabled) {
      return 0;
    }
    if (apiKey == "") {
      return 0;
    }

    // Post-edit parameters
    int lastCharIndex = serverUrl.length - 1;
    if (serverUrl.toString()[lastCharIndex] == '/') {
      // Remove trailing slash '/'
      serverUrl = serverUrl.substring(0, lastCharIndex);
    }
    page = "app://localhost/$page";
    referrer = "app://localhost/$referrer";

    // Get and set device infos
    String version = Platform.operatingSystemVersion.replaceAll('"', '');

    if (userAgent == "") {
      userAgent = "Mozilla/5.0 ($version; rv:53.0) Gecko/20100101 Chrome/53.0";
    }

    // Http Post request see https://plausible.io/docs/events-api
    try {
      String? external = await RGetIp.externalIP;
      String? network = await RGetIp.networkType;

      HttpClient client = HttpClient();
      HttpClientRequest request =
          await client.postUrl(Uri.parse('$serverUrl/api/event'));
      request.headers.set('Api-Key', apiKey);
      request.headers.set('User-Agent', userAgent);
      request.headers.set('User-ID', userID);
      request.headers.set('Session-ID', sessionID);
      request.headers.set('User-IP', '$external,$network');
      request.headers.set('Content-Type', 'application/json; charset=utf-8');
      request.headers.set('X-Forwarded-For', '127.0.0.1');

      Object body = {
        "domain": domain,
        "name": name,
        "url": page,
        "referrer": referrer,
        "screenPage": screenPage,
        "props": props,
      };
      request.write(json.encode(body));
      final HttpClientResponse response = await request.close();
      client.close();
      return response.statusCode;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return 1;
  }

  Future<int> globalScreen(
      {required String? screenName,
      String screenClassOverride = 'Flutter'}) async {
    if (apiKey == "") {
      return 0;
    }
    // Post-edit parameters
    int lastCharIndex = serverUrl.length - 1;
    if (serverUrl.toString()[lastCharIndex] == '/') {
      // Remove trailing slash '/'
      serverUrl = serverUrl.substring(0, lastCharIndex);
    }
    // Get and set device infos
    String version = Platform.operatingSystemVersion.replaceAll('"', '');

    if (userAgent == "") {
      userAgent = "Mozilla/5.0 ($version; rv:53.0) Gecko/20100101 Chrome/53.0";
    }

    try {
      String? external = await RGetIp.externalIP;
      String? network = await RGetIp.networkType;

      HttpClient client = HttpClient();
      HttpClientRequest request =
          await client.getUrl(Uri.parse('$serverUrl/api/screen-view'));
      request.headers.set('Api-Key', apiKey);
      request.headers.set('User-Agent', userAgent);
      request.headers.set('User-ID', userID);
      request.headers.set('Session-ID', sessionID);
      request.headers.set('User-IP', '$external,$network');
      request.headers.set('Content-Type', 'application/json; charset=utf-8');
      request.headers.set('X-Forwarded-For', '127.0.0.1');

      final HttpClientResponse response = await request.close();
      client.close();
      return response.statusCode;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return 1;
  }
}

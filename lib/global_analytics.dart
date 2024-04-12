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
  String userID = "";
  String sessionID = "";
  String userAgent = "";
  String domain = "";
  String userBranch = "";
  String userLatLong = "";

  bool enabled = true;

  /// Constructor
  GlobalAnalytics(this.serverUrl, this.domain, this.apiKey, this.userID,
      this.sessionID, this.userAgent, this.userBranch, this.userLatLong);

  Future<int> globalUsers({String? branch, dynamic location = const []}) async {
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
      userAgent = version;
    }

    try {
      String? external = await RGetIp.externalIP;
      String? network = await RGetIp.networkType;

      HttpClient client = HttpClient();
      HttpClientRequest request =
          await client.postUrl(Uri.parse('$serverUrl/api/screen-view'));
      request.headers.set('Api-Key', apiKey);
      request.headers.set('User-Agent', userAgent);
      request.headers.set('User-ID', userID);
      request.headers.set('Session-ID', sessionID);
      request.headers.set('User-IP', '$external,$network');
      request.headers.set('User-Branch', userBranch);
      request.headers.set('User-Location', userLatLong);
      request.headers.set('Content-Type', 'application/json; charset=utf-8');
      // request.headers.set('X-Forwarded-For', '127.0.0.1');

      Object body = {"branch": branch, "location": location};
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

  /// Post event to plausible
  Future<int> globalEvent(
      {String name = "pageview",
      String referrer = "",
      String page = "",
      dynamic parameters = const {}}) async {
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
      userAgent = version;
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
      request.headers.set('User-Branch', userBranch);
      request.headers.set('User-Location', userLatLong);
      request.headers.set('Content-Type', 'application/json; charset=utf-8');
      // request.headers.set('X-Forwarded-For', '127.0.0.1');

      Object body = {
        "domain": domain,
        "name": name,
        "url": page,
        "referrer": referrer,
        "parameters": parameters,
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
      {required String? screenName, dynamic parameters = const {}}) async {
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
      userAgent = version;
    }

    try {
      String? external = await RGetIp.externalIP;
      String? network = await RGetIp.networkType;

      HttpClient client = HttpClient();
      HttpClientRequest request =
          await client.postUrl(Uri.parse('$serverUrl/api/screen-view'));
      request.headers.set('Api-Key', apiKey);
      request.headers.set('User-Agent', userAgent);
      request.headers.set('User-ID', userID);
      request.headers.set('Session-ID', sessionID);
      request.headers.set('User-IP', '$external,$network');
      request.headers.set('User-Branch', userBranch);
      request.headers.set('User-Location', userLatLong);
      request.headers.set('Content-Type', 'application/json; charset=utf-8');
      // request.headers.set('X-Forwarded-For', '127.0.0.1');

      Object body = {"screenName": screenName, "parameters": parameters};
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
}

import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'color_resource.dart';

class AppUtils {
  /// Showing toast without context message
  static void showToast(
    String text, {
    Color color = Colors.green,
    ToastGravity toastGravity,
    String webColor,
  }) {
    if (text == null) return;
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: toastGravity ?? ToastGravity.BOTTOM,
      backgroundColor: color,
      textColor: Colors.white,
      webBgColor: webColor,
      webPosition: "center",
      timeInSecForIosWeb: 3,
      fontSize: 14.0,
    );
  }

  static void showSnackBar(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '$text',
        style: const TextStyle(
          color: AppColorResource.Color_FFF,
        ),
      ),
    ));
  }

  static void enableFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    debugPrint('Entering full screen mode');
  }

  static Future<void> exitFullScreenMode() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    debugPrint('Exiting full screen mode');
  }

  //Find the MB of the file
  static double getFileMB(File file) {
    final bytes = file.readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;
    return mb;
  }

  /// generate a random string
  static String getRandomString({int length = 15}) {
    final rand = Random();
    final codeUnits = List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });

    return String.fromCharCodes(codeUnits);
  }

  /// Remove focus
  static void removeFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  ////Copy text to clipboard
  static void copyToClipBoard(String text) {
    Clipboard.setData(ClipboardData(text: text ?? ""));
    AppUtils.showToast("Copied to Clipboard");
  }

  ///Return true if it's latest app
  static bool shouldUpdateApp(String apiVersion, String currentVersion) {
    final List<String> apiVersionSplitted = apiVersion.split('.');
    final List<String> currentVersionSplitted = currentVersion.split('.');

    for (int i = 0; i < 3; i++) {
      if (int.parse(currentVersionSplitted[i]) <
          int.parse(apiVersionSplitted[i])) {
        return true;
      }
      if (int.parse(currentVersionSplitted[i]) >
          int.parse(apiVersionSplitted[i])) {
        return false;
      }
    }

    return false;
  }

  static bool isUserAlreadyCreated(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.message) {
        case 'The email address is already in use by another account.':
          return true;
        default:
          return false;
      }
    } else {
      return false;
    }
  }
}

class DebugMode {
  DebugMode._(_);
  static bool get isInDebugMode {
    const bool inDebugMode = true;
    return inDebugMode;
  }
}

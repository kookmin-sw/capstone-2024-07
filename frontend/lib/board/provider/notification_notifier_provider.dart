import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/board/provider/payload_state_notifier_provider.dart';
import 'package:frontend/common/const/data.dart';
import 'package:frontend/common/provider/secure_storage_provider.dart';
import 'package:flutter_local_notifications/src/platform_specifics/android/enums.dart'
    as noti;

class NotificationNotifier extends StateNotifier<SSEModel> {
  NotificationNotifier(this.ref, this.storage)
      : super(SSEModel(id: "", data: "", event: ""));

  final Ref ref;
  final FlutterSecureStorage storage;
  final FlutterLocalNotificationsPlugin notification =
      FlutterLocalNotificationsPlugin();

  void initNotification() async {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings =
        InitializationSettings(android: android, iOS: ios);
    await notification.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          // TODO : Add payload State Notifier
          ref.read(payloadNotifier.notifier).add(details.payload!);
        }
      },
    );
  }

  void requestNotificationPermission() {
    notification
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void sendNotification(String title, String body, int postId) {
    NotificationDetails details = const NotificationDetails(
      iOS: DarwinNotificationDetails(
        badgeNumber: 1,
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails(
        "1",
        "test",
        importance: Importance.max,
        priority: noti.Priority.high,
      ),
    );

    notification.show(0, title, body, details, payload: "$postId");
    // TODO : Add 'payload : router path'
  }

  Future<void> listen() async {
    initNotification();
    requestNotificationPermission();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: "http://$ip/api/notifications/subscribe",
        header: {
          "Authorization": "Bearer $accessToken",
          "Accept": "text/event-stream"
        }).listen((event) {
      debugPrint("SSE : ${event.event}, ${event.data}");
      String e = event.data ?? "";
      if (e != "" && !e.contains("EventStream Created.")) {
        Map<String, dynamic> response = jsonDecode(e);
        sendNotification(
            response["type"], response["content"], response["postId"]);
      }

      state = event;
    }).onError((e) {
      debugPrint("SSE-Error : ${e.toString()}");
    });
  }
}

final notificationStateProvider =
    StateNotifierProvider<NotificationNotifier, SSEModel>((ref) {
  return NotificationNotifier(ref, ref.watch(secureStorageProvider));
});

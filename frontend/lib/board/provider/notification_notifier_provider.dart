import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/common/const/data.dart';
import 'package:frontend/common/provider/secure_storage_provider.dart';

class NotificationNotifier extends StateNotifier<SSEModel> {
  NotificationNotifier(this.ref, this.storage)
      : super(SSEModel(id: "", data: "", event: ""));

  final Ref ref;
  final FlutterSecureStorage storage;

  Future<void> listen() async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: "http://$ip/api/notifications/subscribe",
        header: {
          "Authorization": "Bearer $accessToken",
          "Accept": "text/event-stream"
        }).listen((event) {
      debugPrint("SSE : ${event.data}");
      state = event;
    });
  }
}

final notificationStateProvider =
    StateNotifierProvider<NotificationNotifier, SSEModel>((ref) {
  return NotificationNotifier(ref, ref.watch(secureStorageProvider));
});

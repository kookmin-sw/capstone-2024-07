import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/data.dart';

class NotificationNotifier extends StateNotifier<SSEModel> {
  NotificationNotifier(this.ref) : super(SSEModel(id: "", data: "", event: ""));

  final Ref ref;

  Future<void> listen() async {
    SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: 'http://$ip/api/notifications/subscribe',
        header: {"accessToken": "true"}).listen((event) {
      debugPrint('subscribe! ${event.id} | ${event.event} | ${event.data}');
      state = event;
    }).onError((error) {
      debugPrint('Subscribe Error : $error');
    });
  }
}

final notificationStateProvider =
    StateNotifierProvider<NotificationNotifier, SSEModel>((ref) {
  return NotificationNotifier(ref);
});

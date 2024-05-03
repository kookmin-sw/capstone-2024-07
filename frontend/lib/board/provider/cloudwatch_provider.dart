import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aws_cloudwatch/aws_cloudwatch.dart';
import 'package:frontend/common/const/ip_list.dart';
import 'package:intl/intl.dart';

class CloudWatchNotifier extends StateNotifier<String> {
  CloudWatchNotifier(this.ref) : super("");

  final Ref ref;
  CloudWatchHandler logging = CloudWatchHandler(
    awsAccessKey: awsAccessKeyId,
    awsSecretKey: awsSecretAccessKey,
    region: "ap-northeast-2",
    delay: const Duration(milliseconds: 200),
  );

  Future<void> add(String logString) async {
    String logStreamName = DateFormat('yyyy-MM-dd HH-mm-ss').format(
      DateTime.now().toUtc(),
    );
    logging.log(
      message: logString,
      logGroupName: "Error",
      logStreamName: logStreamName,
    );

    state = logString;
  }

  Future<void> clear() async {
    state = "";
  }
}

final cloudWatchStateProvider =
    StateNotifierProvider<CloudWatchNotifier, String>((ref) {
  return CloudWatchNotifier(ref);
});

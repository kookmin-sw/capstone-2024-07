class NotificationModel {
  DateTime lastHeartbeat;
  int retryCount;
  NotificationModel(this.lastHeartbeat, this.retryCount);
}

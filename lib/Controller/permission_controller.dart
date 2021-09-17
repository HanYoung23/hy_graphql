Future<bool> checkNotificationPermission() async {
  bool permitted = true;
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus != AuthorizationStatus.authorized)
    permitted = false;
  return permitted;
}

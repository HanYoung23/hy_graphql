// import 'package:notification_permissions/notification_permissions.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkNotificationPermission() async {
  bool permitted = true;
  var status;
  await Permission.notification.request().then((value) => status = value);
  if (status != PermissionStatus.granted) permitted = false;
  return permitted;
}

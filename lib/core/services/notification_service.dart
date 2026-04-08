import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Обработчик фоновых сообщений — обязательно top-level функция
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'wishlist_channel';
  static const _channelName = 'Wishlist';

  static Future<void> initialize() async {
    await _requestPermission();
    await _setupLocalNotifications();
    await _saveToken();

    // Обновление токена (например, после переустановки)
    _messaging.onTokenRefresh.listen(_saveTokenString);

    // Уведомления когда приложение открыто
    FirebaseMessaging.onMessage.listen(_showLocalNotification);
  }

  static Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> _setupLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(initSettings);

    // Канал уведомлений для Android 8+
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Напоминания о днях рождения и событиях',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _saveToken() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final token = await _messaging.getToken();
    if (token != null) await _saveTokenString(token);
  }

  static Future<void> _saveTokenString(String token) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    await Supabase.instance.client
        .from('users_info')
        .update({'fcm_token': token}).eq('uuid', user.id);
  }

  static void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  /// Вызвать после входа пользователя, чтобы сохранить токен
  static Future<void> onUserLoggedIn() => _saveToken();
}

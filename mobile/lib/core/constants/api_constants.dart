class ApiConstants {
  static const String baseUrl = 'http://api.aidatpanel.com:2773';
  static const String apiVersion = '/api/v1';

  // Auth endpoints
  static const String register = '$apiVersion/auth/register';
  static const String login = '$apiVersion/auth/login';
  static const String refresh = '$apiVersion/auth/refresh';
  static const String logout = '$apiVersion/auth/logout';
  static const String join = '$apiVersion/auth/join';
  static const String forgotPassword = '$apiVersion/auth/forgot-password';
  static const String resetPassword = '$apiVersion/auth/reset-password';

  // Buildings endpoints
  static const String buildings = '$apiVersion/buildings';
  static const String buildingDetail = '$apiVersion/buildings';

  // Apartments endpoints
  static const String apartments = '$apiVersion/buildings';
  static const String inviteCode = '$apiVersion/apartments';

  // Dues endpoints
  static const String dues = '$apiVersion/buildings';
  static const String myDues = '$apiVersion/me/dues';

  // Expenses endpoints
  static const String expenses = '$apiVersion/buildings';

  // Tickets endpoints
  static const String tickets = '$apiVersion/buildings';
  static const String myTickets = '$apiVersion/me/tickets';

  // Notifications endpoints
  static const String notifications = '$apiVersion/notifications';
  static const String fcmToken = '$apiVersion/me/fcm-token';

  // Profile endpoints
  static const String profile = '$apiVersion/me';
  static const String changePassword = '$apiVersion/me/password';
  static const String changeLanguage = '$apiVersion/me/language';

  // Subscription endpoints
  static const String subscription = '$apiVersion/me/subscription';
  static const String revenuecatWebhook = '$apiVersion/subscription/webhook/revenuecat';

  // Reports endpoints
  static const String reports = '$apiVersion/buildings';
}

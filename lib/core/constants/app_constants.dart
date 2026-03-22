class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'StreamXtream';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String serverUrlKey = 'server_url';
  static const String usernameKey = 'username';
  static const String passwordKey = 'password';
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String profilesBoxKey = 'profiles_box';
  static const String watchProgressBoxKey = 'watch_progress_box';
  static const String favoritesBoxKey = 'favorites_box';
  static const String settingsBoxKey = 'settings_box';
  static const String activeProfileKey = 'active_profile';
  
  // Profile defaults
  static const int maxProfiles = 5;
  static const List<String> defaultAvatars = [
    'avatar_1',
    'avatar_2', 
    'avatar_3',
    'avatar_4',
    'avatar_5',
  ];
  
  // Video quality options
  static const List<String> qualityOptions = [
    'Auto',
    '4K',
    '1080p',
    '720p',
    '480p',
    '360p',
  ];
  
  // Cache settings
  static const int defaultCacheSize = 500; // MB
  static const int maxCacheAge = 7; // days
  
  // UI constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  
  // Image sizes
  static const double posterWidth = 150;
  static const double posterHeight = 225;
  static const double backdropWidth = 300;
  static const double backdropHeight = 170;
  static const double thumbnailWidth = 200;
  static const double thumbnailHeight = 112;
  
  // Player constants
  static const int seekIncrement = 10; // seconds
  static const int volumeIncrement = 5; // percent
  static const double defaultPlaybackSpeed = 1.0;
}

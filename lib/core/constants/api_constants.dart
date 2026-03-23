class ApiConstants {
  ApiConstants._();

  // Default Xtream API endpoints
  static const String defaultApiPath = '/player_api.php';
  
  // Authentication endpoints
  static const String authEndpoint = '';
  static const String loginAction = 'login';
  
  // Content endpoints
  static const String getSeriesAction = 'get_series';
  static const String getSeriesCategoriesAction = 'get_series_categories';
  static const String getMoviesAction = 'get_vod_categories';
  static const String getMoviesListAction = 'get_vod_streams';
  static const String getLiveCategoriesAction = 'get_live_categories';
  static const String getLiveStreamsAction = 'get_live_streams';
  static const String getMovieInfoAction = 'get_vod_info';
  static const String getSeriesInfoAction = 'get_series_info';
  static const String getShortEpgAction = 'get_short_epg';
  static const String getFullEpgAction = 'get_epg';
  
  // Stream parameters
  static const String streamProtocol = 'stream';
  static const String movieStreamPath = '/movie';
  static const String seriesStreamPath = '/series';
  static const String liveStreamPath = '/live';
  
  // API response keys
  static const String userInfoKey = 'user_info';
  static const String categoriesKey = 'categories';
  static const String moviesKey = 'movies';
  static const String seriesKey = 'series';
  static const String streamsKey = 'streams';
  static const String epgKey = 'epg_listings';
  static const String seasonKey = 'seasons';
  static const String episodesKey = 'episodes';
  
  // Auth keys
  static const String usernameKey = 'username';
  static const String passwordKey = 'password';
  static const String authKey = 'auth';
  static const String statusKey = 'status';
  static const String userDataKey = 'user';
  static const String expireDateKey = 'exp_date';
  static const String isTrialKey = 'is_trial';
  static const String activeConsKey = 'active_cons';
  
  // Error codes
  static const int errorInvalidCredentials = 2;
  static const int errorAccountExpired = 3;
  static const int errorNoAccess = 4;
  static const int errorServerError = 5;
}

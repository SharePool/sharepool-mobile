class Constants {
  static const String BASE_SERVER_REST_URL = "http://geanik.ddns.net:8080";
  static const String BASE_ANALYTICS_REST_URL = "http://geanik.ddns.nets:8081";

  static const String SETTINGS_USER_TOKEN = "userToken";
  static const String SETTINGS_USER_ID = "userId";
  static const String SETTINGS_LOGGED_IN_USER = "loggedInUser";
  static const String SETTINGS_HOME_PAGE = "homePage";

  static RegExp EMAIL_REG_EXP = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  static RegExp PASSWORD_REG_EXP = new RegExp(
      r"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\S+$).*$");
}

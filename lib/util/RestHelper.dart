class RestHelper {
  static bool statusOk(int code) {
    return code >= 200 && code < 300;
  }
}

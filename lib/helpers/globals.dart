class Globals {
  static bool _isDevelop = false;
  static bool _isProduction = false;
  static bool _isWpl = true;

  static String getBaseUrl() {
    if (_isProduction) {
      return 'findmyfun-c0acc-default-rtdb.firebaseio.com';
    } else if (_isDevelop) {
      return 'findmyfun-dev-default-rtdb.firebaseio.com';
    } else {
      return 'findmyfun-wpl-default-rtdb.firebaseio.com';
    }
  }
}

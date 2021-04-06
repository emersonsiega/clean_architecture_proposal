abstract class Navigation {
  Future<T> pushNamed<T>(String path, {dynamic arguments});

  Future<T> pushReplacementNamed<T>(String path, {dynamic arguments});

  dynamic pop({dynamic response});

  bool canPop();
}

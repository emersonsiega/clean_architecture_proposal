abstract class DependencyManager {
  void put<T>(T instance);

  void lazyPut<T>(T instanceBuilder());

  T get<T>();

  void delete<T>();
}

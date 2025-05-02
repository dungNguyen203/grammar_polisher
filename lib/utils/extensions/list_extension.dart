extension ListExtension<E> on List<E> {
  Iterable<E> mapIndexed(E Function(int index, E e) f) {
    return asMap().entries.map((entry) => f(entry.key, entry.value));
  }

  E? firstWhereOrNull(bool Function(E element) test) {
    final index = indexWhere(test);
    return index == -1 ? null : this[index];
  }
}
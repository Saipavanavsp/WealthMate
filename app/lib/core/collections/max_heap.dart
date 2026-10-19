/// Binary max-heap backed by a growable list.
///
/// push and pop are O(log n), peek is O(1). [compare] must return a positive
/// number when its first argument should be closer to the top.
class MaxHeap<T> {
  MaxHeap(this.compare);

  final int Function(T a, T b) compare;
  final List<T> _items = [];

  int get length => _items.length;
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  T get peek {
    if (_items.isEmpty) throw StateError('Heap is empty');
    return _items.first;
  }

  void push(T item) {
    _items.add(item);
    var child = _items.length - 1;
    while (child > 0) {
      final parent = (child - 1) >> 1;
      if (compare(_items[child], _items[parent]) <= 0) break;
      _swap(child, parent);
      child = parent;
    }
  }

  T pop() {
    if (_items.isEmpty) throw StateError('Heap is empty');
    final top = _items.first;
    final last = _items.removeLast();
    if (_items.isNotEmpty) {
      _items[0] = last;
      _siftDown(0);
    }
    return top;
  }

  void _siftDown(int index) {
    var parent = index;
    while (true) {
      final left = 2 * parent + 1;
      final right = left + 1;
      var largest = parent;
      if (left < _items.length && compare(_items[left], _items[largest]) > 0) largest = left;
      if (right < _items.length && compare(_items[right], _items[largest]) > 0) largest = right;
      if (largest == parent) return;
      _swap(parent, largest);
      parent = largest;
    }
  }

  void _swap(int a, int b) {
    final tmp = _items[a];
    _items[a] = _items[b];
    _items[b] = tmp;
  }
}

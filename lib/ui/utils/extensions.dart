extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element) id, bool inplace = true]) {
    final ids = Set();
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

extension DateTimeExtension on DateTime {
  String toOnlyDate() {
    DateTime fecha = this; //.add(Duration(hours: 25));
    return (this == null)
        ? null
        : "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }
}

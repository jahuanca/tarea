List<String> listaEncabezados(Map<String, dynamic> json) {
  List<String> items = [];
  json.keys.forEach((element) {
    items.add(element.toString());
  });
  return items;
}

List<String> listaItem(Map<String, dynamic> json) {
  List<String> items = [];
  json.values.forEach((element) {
    items.add(element.toString());
  });
  return items;
}

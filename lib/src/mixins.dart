mixin class SelectableX {
  bool check = false;
}

mixin class PageDataX {
  int page = 1;
  int limit = 5;

  void resetPageX() {
    page = 1;
    limit = 5;
  }

  Map<String, dynamic> toPageDataMap() {
    return {
      "page": page,
      "limit": limit,
    };
  }

}
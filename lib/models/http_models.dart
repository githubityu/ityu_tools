class PageModel {
  static const int defaultPageStart = 1;
  static const int defaultPageSize = 10;

  final int page;
  final int pageSize;
  final bool hasMore;

  const PageModel({
    this.page = defaultPageStart,
    this.pageSize = defaultPageSize,
    this.hasMore = true,
  });

  /// 标准的 copyWith 模式，方便更新状态
  PageModel copyWith({
    int? page,
    int? pageSize,
    bool? hasMore,
  }) {
    return PageModel(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  /// 重置分页到第一页
  PageModel reset() => copyWith(page: defaultPageStart, hasMore: true);

  /// 进入下一页
  PageModel next() => copyWith(page: page + 1);

  @override
  String toString() => 'PageModel(page: $page, pageSize: $pageSize, hasMore: $hasMore)';
}


class PagedList<T> {
  final List<T> list;
  final bool hasMore;

  const PagedList({
    this.list = const [],
    this.hasMore = false,
  });

  factory PagedList.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) {
    final items = json['list'] as List<dynamic>? ?? [];
    return PagedList<T>(
      list: items.map((e) => fromJsonT(e)).toList(),
      hasMore: json['has_more'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => {
    'list': list.map((e) => toJsonT(e)).toList(),
    'has_more': hasMore,
  };
}
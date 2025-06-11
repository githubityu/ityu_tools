import 'package:ityu_tools/local/local_exports.dart';

const int cPageStart = 1;
const int cPageSize = 10;

class ResponseBodyMt {
  String? code;
  String? msg;

  // @JsonKey(includeFromJson: false, includeToJson: false)
  dynamic data;

  ResponseBodyMt({
    String? code,
    String? msg,
    dynamic data,
  });

  ResponseBodyMt.fromJson(Map<String, dynamic> json1) {
    code = '${json1['code']}';
    msg = '${json1['msg']}';
    data = json1['data'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'msg': msg,
        'data': data,
      };
}

class PageModel {
  PageModel(
      {this.page = cPageStart,
      this.pageSize = cPageSize,
      this.hasMore = true});

  int page;
  int pageSize;
  bool? hasMore;

  PageModel copyWith() {
    return PageModel(pageSize: pageSize, page: page);
  }

  PageModel resetPage({int oldPage = cPageStart}) {
    page = oldPage;
    return this;
  }

  @override
  String toString() {
    return 'PageModel{page: $page, pageSize: $pageSize,  hasMore: $hasMore}';
  }
}

class HasMoreListData<T> {
  HasMoreListData(this.list, {this.hasMore});

  List<T>? list;
  bool? hasMore;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list;
    data['has_more'] = hasMore;
    return data;
  }
}

class ResponseBodyRpc {
  String? jsonrpc;
  dynamic result;
  dynamic error;

  ResponseBodyRpc({
    String? jsonrpc,
    dynamic result,
    dynamic error,
  });

  ResponseBodyRpc.fromJson(Map<String, Object?> json) {
    jsonrpc = '${json['jsonrpc']}';
    result = json['result'];
    error = json['error'];
  }

  @override
  List<Object?> get props => [result, jsonrpc, error];
}

import 'package:flutter/material.dart';
import 'package:ityu_tools/exports.dart';

typedef ListExpansionTile<T> = List<T> Function(T);
typedef ModelToMap<T> = Map<String, dynamic> Function(T);
typedef ButtonsByT<T> = Widget? Function(T);

class TreeUtils {
  static List<Widget> generateRows<T>(List<T> items,
      {int depth = 0,
      required ListExpansionTile<T> listExpansionTile,
      required ModelToMap<T> modelToMap,
      ButtonsByT<T>? btnS}) {
    final list = items
        .map((e) => listExpansionTile(e).isNotEmpty == true
            ? ExpansionTile(
                controlAffinity: ListTileControlAffinity.leading,
                tilePadding: EdgeInsets.only(left: (depth) * 15),
                title: ItemExpansionTile(
                  dept: depth,
                  item: modelToMap(e),
                  btnS: btnS?.call(e),
                ),
                children: generateRows(listExpansionTile(e),
                    listExpansionTile: listExpansionTile,
                    depth: depth + 1,
                    btnS: btnS,
                    modelToMap: modelToMap),
              )
            : Padding(
                padding: EdgeInsets.only(left: (depth * 20.0) + 30),
                child: ItemExpansionTile(
                  item: modelToMap(e),
                  dept: depth,
                  btnS: btnS?.call(e),
                ),
              ))
        .toList();
    return list;
  }
}

class ItemExpansionTileHeader extends StatelessWidget {
  final List<String> headers;
  final double width;

  const ItemExpansionTileHeader(
      {super.key, required this.headers, this.width = 150});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 40 + width,
          height: 60,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Text(headers.first),
          )),
        ),
        ...headers.skip(1).map((e) => Expanded(child: Center(child: Text(e))))
      ],
    );
  }
}

class ItemExpansionTile extends StatelessWidget {
  final int dept;
  final Map<String, dynamic> item;
  final Widget? btnS;

  const ItemExpansionTile(
      {super.key, required this.item, this.dept = 0, this.btnS});

  @override
  Widget build(BuildContext context) {
    const space = 20.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 150 - space * dept,
          child: Text(
            item[item.keys.first] ?? "",
            style: TextStyle(color: context.colorScheme.primary),
          ),
        ),
        ...item.keys.skip(1).map((e) => Expanded(
            child: Center(child: Text(Utils.getStringForDefault(item[e]))))),
        if (btnS != null) Expanded(child: Center(child: btnS!)),
      ],
    );
  }
}

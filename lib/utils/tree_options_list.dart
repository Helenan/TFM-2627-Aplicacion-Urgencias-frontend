import 'package:flutter/material.dart';

class TreeOptionsList<T> extends StatefulWidget {
  final Iterable<T> items;
  final List<T> Function(T item) childrenOf;
  final String Function(T item) displayItem;
  final void Function(T item) onSelected;
  final double indent;

  const TreeOptionsList({
    super.key,
    required this.items,
    required this.childrenOf,
    required this.displayItem,
    required this.onSelected,
    this.indent = 24,
  });

  @override
  State<TreeOptionsList<T>> createState() => _TreeOptionsListState<T>();
}

typedef _TreeNode<T> = ({T item, int depth, String path});

class _TreeOptionsListState<T> extends State<TreeOptionsList<T>> {
  final Set<String> _openPaths = {};

  @override
  void didUpdateWidget(TreeOptionsList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!identical(oldWidget.items, widget.items)) {
      _openPaths.clear();
    }
  }

  void _toggle(String path) {
    setState(() {
      if (!_openPaths.remove(path)) {
        _openPaths.add(path);
      }
    });
  }

  List<_TreeNode<T>> _visibleNodes(
    Iterable<T> items, [
    int depth = 0,
    String parentPath = '',
  ]) {
    final nodes = <_TreeNode<T>>[];

    for (final (index, item) in items.indexed) {
      final path = '$parentPath/$index';
      nodes.add((item: item, depth: depth, path: path));

      if (_openPaths.contains(path)) {
        nodes.addAll(_visibleNodes(widget.childrenOf(item), depth + 1, path));
      }
    }

    return nodes;
  }

  @override
  Widget build(BuildContext context) {
    final nodes = _visibleNodes(widget.items);

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        final node = nodes[index];
        final isOpen = _openPaths.contains(node.path);

        return ListTile(
          contentPadding: EdgeInsets.only(
            left: 16 + widget.indent * node.depth,
            right: 8,
          ),
          title: Text(widget.displayItem(node.item)),
          onTap: () => widget.onSelected(node.item),
          trailing: widget.childrenOf(node.item).isEmpty
              ? null
              : IconButton(
                  icon: Icon(isOpen ? Icons.expand_less : Icons.expand_more),
                  tooltip: isOpen ? 'Contraer' : 'Desplegar',
                  onPressed: () => _toggle(node.path),
                ),
        );
      },
    );
  }
}

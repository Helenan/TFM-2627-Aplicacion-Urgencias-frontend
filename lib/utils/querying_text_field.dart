import 'dart:async';

import 'package:flutter/material.dart';

import 'tree_options_list.dart';

String? _defaultValidator(String? value) => null;

class QueryingTextField<T extends Object> extends StatefulWidget {
  final TextEditingController controller;
  final Future<List<T>> Function(String value) queryMethod;
  final String Function(T item) displayItem;
  final String Function(T item)? selectedText;
  final void Function(T item) onSelected;
  final void Function(String value) onChanged;
  final String hintText;
  final Duration timerDuration;
  final int minQueryLength;
  final String? Function(String? value) validator;
   final List<T> Function(T item)? childrenOf;
  final double optionsMaxHeight;

  const QueryingTextField({
    super.key,
    required this.controller,
    required this.queryMethod,
    required this.displayItem,
    this.selectedText,
    required this.onSelected,
    required this.onChanged,
    this.hintText = "",
    this.timerDuration = const Duration(milliseconds: 350),
    this.minQueryLength = 3,
    String? Function(String? value)? validator,
    this.childrenOf,
    this.optionsMaxHeight = 150,
  }) : validator = validator ?? _defaultValidator;

  @override
  State<StatefulWidget> createState() => _QueryingTextFieldState<T>();
}

class _QueryingTextFieldState<T extends Object>
    extends State<QueryingTextField<T>> {
  Timer? _patientQueryTimer;
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  Completer<Iterable<T>>? _currentRequest;

  @override
  void dispose() {
    _patientQueryTimer?.cancel();
    _isLoading.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      displayStringForOption: widget.selectedText ?? widget.displayItem,
      optionsBuilder: (textEditingValue) async {
        _patientQueryTimer?.cancel();

        final queryValue = textEditingValue.text.trim();
        if (queryValue.length < widget.minQueryLength) {
          _currentRequest = null;
          _isLoading.value = false;
          return [];
        }

        final completer = Completer<Iterable<T>>();
        _currentRequest = completer;
        _isLoading.value = true;

        _patientQueryTimer = Timer(widget.timerDuration, () async {
          try {
            final results = await widget.queryMethod(queryValue);
            completer.complete(results);
          } catch (e, stackTrace) {
            completer.completeError(e, stackTrace);
          } finally {
            if (identical(_currentRequest, completer)) {
              _isLoading.value = false;
            }
          }
        });

        return await completer.future;
      },
      onSelected: widget.onSelected,
      optionsViewOpenDirection: OptionsViewOpenDirection.mostSpace,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isLoading,
          builder: (context, isLoading, _) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              validator: widget.validator,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                suffixIcon: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
            );
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          heightFactor: 1,
          child: Material(
            elevation: 4,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: widget.optionsMaxHeight),
              child: _buildOptions(onSelected, options),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptions(
    AutocompleteOnSelected<T> onSelected,
    Iterable<T> options,
  ) {
    final childrenOf = widget.childrenOf;

    if (childrenOf != null) {
      return TreeOptionsList<T>(
        items: options,
        childrenOf: childrenOf,
        displayItem: widget.displayItem,
        onSelected: onSelected,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options.elementAt(index);

        return ListTile(
          title: Text(widget.displayItem(option)),
          onTap: () => onSelected(option),
        );
      },
    );
  }
}

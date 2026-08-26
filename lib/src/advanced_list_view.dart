import 'package:flutter/material.dart';

import 'advanced_scroll_controller.dart';

class AdvancedListView extends StatefulWidget {
  const AdvancedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.onRefresh,
    this.onLoadMore,
    this.hasMore = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.onRetry,
    this.emptyWidget,
    this.errorWidget,
    this.loadingWidget,
    this.loadingMoreWidget,
    this.physics,
    this.padding,
    this.paginationThreshold = 300,
    this.enableFastScroll = false,
    this.shrinkWrap = false,
    this.primary,
    this.reverse = false,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
  });

  final int itemCount;

  final IndexedWidgetBuilder itemBuilder;

  final AdvancedScrollController? controller;

  final Future<void> Function()? onRefresh;

  final Future<void> Function()? onLoadMore;

  final bool hasMore;

  final bool isLoading;

  final bool isLoadingMore;

  final bool hasError;

  final VoidCallback? onRetry;

  final Widget? emptyWidget;

  final Widget? errorWidget;

  final Widget? loadingWidget;

  final Widget? loadingMoreWidget;

  final ScrollPhysics? physics;

  final EdgeInsetsGeometry? padding;

  final double paginationThreshold;

  final bool enableFastScroll;

  final bool shrinkWrap;

  final bool? primary;

  final bool reverse;

  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  State<AdvancedListView> createState() => _AdvancedListViewState();
}

class _AdvancedListViewState extends State<AdvancedListView> {
  late final ScrollController _internalController;

  ScrollController get _scrollController =>
      widget.controller?.scrollController ?? _internalController;

  bool _paginationRunning = false;

  @override
  void initState() {
    super.initState();

    _internalController = ScrollController();

    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant AdvancedListView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.scrollController.removeListener(_onScroll);

      _scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (!widget.hasMore) return;
    if (widget.onLoadMore == null) return;
    if (widget.isLoadingMore) return;
    if (_paginationRunning) return;

    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    final remaining = position.maxScrollExtent - position.pixels;

    if (remaining <= widget.paginationThreshold) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_paginationRunning) return;

    _paginationRunning = true;

    try {
      await widget.onLoadMore?.call();
    } finally {
      _paginationRunning = false;
    }
  }

  Widget _buildLoading() {
    return widget.loadingWidget ??
        const Center(child: CircularProgressIndicator());
  }

  Widget _buildEmpty() {
    return widget.emptyWidget ?? const Center(child: Text('No data available'));
  }

  Widget _buildError() {
    return widget.errorWidget ??
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Something went wrong'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: widget.onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
  }

  Widget _buildList() {
    return ListView.builder(
      controller: _scrollController,
      physics: widget.physics ?? const BouncingScrollPhysics(),
      padding: widget.padding,
      itemCount: widget.itemCount + (widget.isLoadingMore ? 1 : 0),
      shrinkWrap: widget.shrinkWrap,
      primary: widget.primary,
      reverse: widget.reverse,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      itemBuilder: (context, index) {
        if (index >= widget.itemCount) {
          return widget.loadingMoreWidget ??
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
        }

        return widget.itemBuilder(context, index);
      },
    );
  }

  Widget _buildContent() {
    if (widget.isLoading && widget.itemCount == 0) {
      return _buildLoading();
    }

    if (widget.hasError && widget.itemCount == 0) {
      return _buildError();
    }

    if (widget.itemCount == 0) {
      return _buildEmpty();
    }

    return _buildList();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _buildContent();

    if (widget.onRefresh != null && widget.itemCount > 0) {
      child = RefreshIndicator(onRefresh: widget.onRefresh!, child: child);
    }

    if (widget.enableFastScroll) {
      child = Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        interactive: true,
        child: child,
      );
    }

    return child;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);

    if (widget.controller == null) {
      _internalController.dispose();
    }

    super.dispose();
  }
}

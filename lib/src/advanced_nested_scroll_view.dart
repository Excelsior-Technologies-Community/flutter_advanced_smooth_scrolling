import 'package:flutter/material.dart';

class AdvancedNestedScrollView extends StatelessWidget {
  const AdvancedNestedScrollView({
    super.key,
    required this.headerSliverBuilder,
    required this.body,
    this.controller,
    this.physics,
    this.floatHeaderSlivers = false,
  });

  final NestedScrollViewHeaderSliversBuilder headerSliverBuilder;

  final Widget body;

  final ScrollController? controller;

  final ScrollPhysics? physics;

  final bool floatHeaderSlivers;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: controller,
      physics: physics ?? const BouncingScrollPhysics(),
      floatHeaderSlivers: floatHeaderSlivers,
      headerSliverBuilder: headerSliverBuilder,
      body: body,
    );
  }
}

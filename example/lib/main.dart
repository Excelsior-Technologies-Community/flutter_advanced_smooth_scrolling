import 'package:flutter/material.dart';
import 'package:flutter_advanced_smooth_scrolling/flutter_advanced_smooth_scrolling.dart';

void main() {
  runApp(const AdvancedSmoothScrollingExample());
}

class AdvancedSmoothScrollingExample extends StatelessWidget {
  const AdvancedSmoothScrollingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Smooth Scrolling',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Smooth Scrolling'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DemoCard(
            icon: Icons.list,
            title: 'Smooth List',
            subtitle: 'Basic smooth ListView',
            onTap: () {
              _open(
                context,
                const SmoothListScreen(),
              );
            },
          ),
          _DemoCard(
            icon: Icons.grid_view,
            title: 'Smooth Grid',
            subtitle: 'GridView with pagination',
            onTap: () {
              _open(
                context,
                const SmoothGridScreen(),
              );
            },
          ),
          _DemoCard(
            icon: Icons.refresh,
            title: 'Pagination & Refresh',
            subtitle: 'Load more and pull to refresh',
            onTap: () {
              _open(
                context,
                const PaginationScreen(),
              );
            },
          ),
          _DemoCard(
            icon: Icons.swap_vert,
            title: 'Fast Scroll',
            subtitle: 'Quickly navigate large lists',
            onTap: () {
              _open(
                context,
                const FastScrollScreen(),
              );
            },
          ),
          _DemoCard(
            icon: Icons.vertical_split,
            title: 'Nested Scroll',
            subtitle: 'NestedScrollView with header',
            onTap: () {
              _open(
                context,
                const NestedScrollScreen(),
              );
            },
          ),
          _DemoCard(
            icon: Icons.keyboard_double_arrow_up,
            title: 'Scroll Controller',
            subtitle: 'Top, bottom and index navigation',
            onTap: () {
              _open(
                context,
                const ControllerScreen(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SmoothListScreen extends StatelessWidget {
  const SmoothListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smooth List'),
      ),
      body: AdvancedListView(
        itemCount: 100,
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text('$index'),
            ),
            title: Text('List Item $index'),
            subtitle: const Text(
              'Smooth scrolling example',
            ),
          );
        },
      ),
    );
  }
}

class SmoothGridScreen extends StatelessWidget {
  const SmoothGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smooth Grid'),
      ),
      body: AdvancedGridView(
        itemCount: 100,
        crossAxisCount: 2,
        padding: const EdgeInsets.all(12),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            child: Center(
              child: Text(
                'Item $index',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PaginationScreen extends StatefulWidget {
  const PaginationScreen({super.key});

  @override
  State<PaginationScreen> createState() =>
      _PaginationScreenState();
}

class _PaginationScreenState
    extends State<PaginationScreen> {
  final List<int> items = [];

  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    setState(() {
      items.addAll(
        List.generate(20, (index) => index),
      );

      isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    if (isLoadingMore || !hasMore) return;

    setState(() {
      isLoadingMore = true;
    });

    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    final start = items.length;

    setState(() {
      items.addAll(
        List.generate(
          20,
              (index) => start + index,
        ),
      );

      isLoadingMore = false;

      if (items.length >= 100) {
        hasMore = false;
      }
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    setState(() {
      items
        ..clear()
        ..addAll(
          List.generate(20, (index) => index),
        );

      hasMore = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination'),
      ),
      body: AdvancedListView(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text('${items[index]}'),
            ),
            title: Text(
              'Product ${items[index]}',
            ),
          );
        },
        isLoading: isLoading,
        isLoadingMore: isLoadingMore,
        hasMore: hasMore,
        onLoadMore: _loadMore,
        onRefresh: _refresh,
        paginationThreshold: 300,
      ),
    );
  }
}
class FastScrollScreen extends StatelessWidget {
  const FastScrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fast Scroll'),
      ),
      body: AdvancedListView(
        itemCount: 500,
        enableFastScroll: true,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text('$index'),
            ),
            title: Text('Item $index'),
            subtitle: const Text(
              'Drag the scrollbar to move quickly',
            ),
          );
        },
      ),
    );
  }
}

class NestedScrollScreen extends StatelessWidget {
  const NestedScrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdvancedNestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder:
            (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              floating: true,
              title: const Text('Nested Scroll'),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  alignment: Alignment.center,
                  child: const Text(
                    'Advanced Scrolling',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: AdvancedListView(
          itemCount: 100,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                'Nested Item $index',
              ),
            );
          },
        ),
      ),
    );
  }
}

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({super.key});

  @override
  State<ControllerScreen> createState() =>
      _ControllerScreenState();
}

class _ControllerScreenState
    extends State<ControllerScreen> {
  late final AdvancedScrollController controller;

  @override
  void initState() {
    super.initState();

    controller = AdvancedScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scroll Controller'),
      ),
      body: AdvancedListView(
        controller: controller,
        itemCount: 200,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'top',
            onPressed: () {
              controller.scrollToTop();
            },
            child: const Icon(
              Icons.keyboard_arrow_up,
            ),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'index',
            onPressed: () {
              controller.scrollToIndex(
                100,
                itemExtent: 56,
              );
            },
            child: const Icon(
              Icons.my_location,
            ),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'bottom',
            onPressed: () {
              controller.scrollToBottom();
            },
            child: const Icon(
              Icons.keyboard_arrow_down,
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: onTap,
      ),
    );
  }
}
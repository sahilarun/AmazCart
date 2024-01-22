import 'package:flutter/material.dart';

class SliverAppBarTitleWidget extends StatefulWidget {
  final Widget child;

  const SliverAppBarTitleWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _SliverAppBarTitileWidgetState createState() {
    return new _SliverAppBarTitileWidgetState();
  }
}

class _SliverAppBarTitileWidgetState extends State<SliverAppBarTitleWidget> {
  ScrollPosition? _position;
  bool? _visible;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context).position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    FlexibleSpaceBarSettings? settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      child: Visibility(
        visible: _visible!,
        child: widget.child,
      ),
    );
  }
}

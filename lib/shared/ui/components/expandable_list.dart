import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///
/// Widget that uses ScrollNotification and ScrollController to expand or
/// collapse the scrollable area. The collapse will respect the [minSize].
///
/// When scroll ends, ensures the scrollable area stay with two possible sizes:
/// Totally expanded or totally collapsed. Sizes between these boundaries are
/// not allowed.
///
/// [builder] method should build a Widget that contains a scrollable area and
/// attach the provided [ScrollController] to that Widget.
///
class ExpandableList extends StatefulWidget {
  final Widget Function(ScrollController controller) builder;
  final double minSize;
  final Color indicatorColor;
  final ValueChanged<bool> onCollapse;

  const ExpandableList({
    Key key,
    @required this.builder,
    @required this.minSize,
    this.onCollapse,
    this.indicatorColor: Colors.blue,
  }) : super(key: key);

  @override
  _ExpandableListState createState() => _ExpandableListState();
}

class _ExpandableListState extends State<ExpandableList> {
  ScrollController _controller;
  double _childSize;
  double _maxSize;
  bool _shouldClose = false;
  bool _isCollapsed = true;
  bool _firstInteraction = true;

  @override
  void initState() {
    super.initState();

    _childSize = widget.minSize;
    _controller = ScrollController();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _firstInteraction = false;

      _onScrollStart(notification);
    }

    if (notification is OverscrollNotification) {
      _onAndroidScrollUpdate(notification);
    }

    if (notification is ScrollUpdateNotification) {
      _onScrollUpdate(notification);
    }

    if (notification is ScrollEndNotification) {
      _firstInteraction = true;

      _onScrollEnd();
    }

    return true;
  }

  void _onScrollStart(ScrollStartNotification notification) {
    if (notification.metrics.axisDirection == AxisDirection.down &&
        _childSize == _maxSize &&
        notification.metrics.extentBefore <= 0) {
      _shouldClose = true;
    } else {
      _shouldClose = false;
    }
  }

  void _onChangeSize(double newSize) {
    bool isCollapsed = newSize == widget.minSize;

    if (isCollapsed != _isCollapsed) {
      if (widget.onCollapse != null) {
        widget.onCollapse(isCollapsed);
      }

      _firstInteraction = true;
    }

    setState(() {
      _childSize = newSize;
      _isCollapsed = isCollapsed;
    });
  }

  void _onAndroidScrollUpdate(OverscrollNotification notification) {
    if ((_shouldClose || _firstInteraction) && notification.overscroll < 0) {
      var newChildSize = _childSize + notification.overscroll;
      newChildSize = min(newChildSize, _maxSize);
      newChildSize = max(newChildSize, widget.minSize);

      _onChangeSize(newChildSize);
    }
  }

  void _onScrollUpdate(ScrollUpdateNotification notification) {
    double newChildSize;

    if ((_shouldClose || _firstInteraction) && _controller.offset < 0) {
      newChildSize = _childSize + _controller.offset;
    } else {
      newChildSize = _childSize + max(0, _controller.offset);
    }

    newChildSize = min(newChildSize, _maxSize);
    newChildSize = max(newChildSize, widget.minSize);

    _onChangeSize(newChildSize);
  }

  bool get _isScrollingDown =>
      _controller.position.userScrollDirection == ScrollDirection.reverse;

  void _onScrollEnd() {
    if (_isScrollingDown && _childSize != _maxSize) {
      _onChangeSize(_maxSize);
    } else if (!_isScrollingDown &&
        _childSize != widget.minSize &&
        _childSize != _maxSize) {
      _onChangeSize(widget.minSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _maxSize = constraints.maxHeight;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
              width: 6,
              height: _childSize - 80,
              decoration: BoxDecoration(
                color: widget.indicatorColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.ease,
                color: Theme.of(context).canvasColor,
                height: _childSize,
                child: NotificationListener<ScrollNotification>(
                  onNotification: _onScroll,
                  child: Builder(
                    builder: (BuildContext context) {
                      return widget.builder(_controller);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

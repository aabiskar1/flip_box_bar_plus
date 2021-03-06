library flip_box_bar;

import 'package:flip_box_bar/src/flip_bar_element.dart';
import 'package:flip_box_bar/src/flip_bar_item.dart';
import 'package:flutter/material.dart';

/// Top level widget for BottomNavigationBar.
class FlipBoxBarPlus extends StatefulWidget {
  /// The items to be displayed in the BottomNavBar.
  final List<FlipBarItem> items;

  /// The duration of the animation of the box flip.
  final Duration animationDuration;

  /// Callback for getting value of item selection.
  final ValueChanged<int> onIndexChanged;

  /// The selected index of the bar
  final int selectedIndex;

  /// The height of the BottomNavBar.
  final double navBarHeight;

  /// The flip box bar is set as vertical(column) when the bool is true
  final bool isVerticalBar;

  /// The width of the bar when the bar is in vertical position
  final double navBarWidth;

  FlipBoxBarPlus({
    @required this.items,
    this.animationDuration = const Duration(seconds: 1),
    @required this.onIndexChanged,
    @required this.selectedIndex,
    this.navBarHeight = 100.0,
    this.isVerticalBar = false,
    this.navBarWidth = 40,
  });

  @override
  _FlipBoxBarPlusState createState() => _FlipBoxBarPlusState();
}

class _FlipBoxBarPlusState extends State<FlipBoxBarPlus>
    with TickerProviderStateMixin {
  /// Hosts all the controllers controlling the boxes.
  List<AnimationController> _controllers = [];

  @override
  void initState() {
    super.initState();

    // Initialise all animation controllers.
    for (int i = 0; i < widget.items.length; i++) {
      _controllers.add(
        AnimationController(
          vsync: this,
          duration: widget.animationDuration,
        ),
      );
    }

    // Start animation for initially selected controller.
    _controllers[widget.selectedIndex].forward();
  }

  @override
  Widget build(BuildContext context) {
    _changeValue();
    return Container(
      height: (widget.isVerticalBar == false) ? 100 : double.infinity,
      width: (widget.isVerticalBar == false) ? double.infinity : 40,
      child: (widget.isVerticalBar == false)
          ? Row(
              children: widget.items.map((item) {
                int index = widget.items.indexOf(item);
                // Create the boxes in the NavBar.
                return Expanded(
                  child: FlipBarElement(
                    item.icon,
                    item.text,
                    item.frontColor,
                    item.backColor,
                    _controllers[index],
                    (index) {
                      _changeValue();
                      widget.onIndexChanged(index);
                    },
                    index,
                    widget.navBarHeight,
                  ),
                );
              }).toList(),
            )
          : Column(
              children: widget.items.map((item) {
                int index = widget.items.indexOf(item);
                // Create the boxes in the NavBar.
                return Expanded(
                  child: FlipBarElement(
                    item.icon,
                    item.text,
                    item.frontColor,
                    item.backColor,
                    _controllers[index],
                    (index) {
                      _changeValue();
                      widget.onIndexChanged(index);
                    },
                    index,
                    widget.navBarHeight,
                  ),
                );
              }).toList(),
            ),
    );
  }

  void _changeValue() {
    _controllers.forEach((controller) => controller.reverse());
    _controllers[widget.selectedIndex].forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((controller) => controller.dispose());
  }
}

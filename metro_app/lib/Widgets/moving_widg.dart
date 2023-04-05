import 'package:flutter/material.dart';

class MovingWidg extends StatefulWidget {
  final int? duration;
  final double? offsetX;
  final double? offsetY;
  final Curve? curve;

  const MovingWidg({
    Key? key,
    this.duration,
    this.offsetX,
    this.offsetY,
    this.curve,
  }) : super(key: key);

  @override
  State<MovingWidg> createState() => MovingWidgState();
}

class MovingWidgState extends State<MovingWidg>
    with SingleTickerProviderStateMixin {
  bool isMovedUp = false;

  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: widget.duration ?? 350),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: Offset(widget.offsetX ?? 0, widget.offsetY ?? 0),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.easeInOut,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: const Icon(
        Icons.chevron_right,
        size: 64,
      ),
    );
  }

  void playWidgetAnimation() {
    if (isMovedUp) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      isMovedUp = !isMovedUp;
    });
  }
}
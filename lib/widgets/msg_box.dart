import 'package:flutter/material.dart';

class MessageBox extends StatefulWidget {
  final Function(AnimationController) onClick;

  const MessageBox({Key key, this.onClick}) : super(key: key);

  @override
  _MessageBoxState createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  AnimatedIconData iconData = AnimatedIcons.play_pause;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    _animationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (_animationController.isCompleted) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
          widget.onClick(_animationController);
        },
        child: AnimatedIcon(
            progress: _animationController, icon: iconData, size: 32));
  }
}

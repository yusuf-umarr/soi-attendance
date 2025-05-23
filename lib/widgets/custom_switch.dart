// ignore_for_file: use_late_for_private_fields_and_variables

import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;

  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
   
  }) : super(key: key);

  @override
  CustomSwitchState createState() => CustomSwitchState();
}

class CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 60),);
    _circleAnimation = AlignmentTween(
            begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight,)
        .animate(CurvedAnimation(
            parent: _animationController!, curve: Curves.linear,),);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Stack(
            children: [
              Container(
                width: 60.0,
                height: 28.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: _circleAnimation!.value == Alignment.centerLeft
                      ? Colors.purple
                      : Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 2.0, bottom: 2.0, right: 2.0, left: 2.0,),
                  child: Container(
                    alignment: widget.value
                        ? ((Directionality.of(context) == TextDirection.rtl)
                            ? Alignment.centerRight
                            : Alignment.centerLeft)
                        : ((Directionality.of(context) == TextDirection.rtl)
                            ? Alignment.centerLeft
                            : Alignment.centerRight),
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white,),
                    ),
                  ),
                ),
              ),
              const Positioned(
                  top: 0,
                  bottom: 0,
                  child: SizedBox(
                    width: 60,
                    child: Align(
                      // alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "",
                            
                            ),
                            Text(
                              "",
                            
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),),
            ],
          ),
        );
      },
    );
  }
}

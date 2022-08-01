import 'package:flutter/material.dart';

///rounded icon button
class RoundButton extends StatelessWidget {
  ///constructer of the button
  const RoundButton({
    required this.width,
    required this.color,
    required this.icon,
    Key? key,
    this.isLoading = false,
    this.onPressed,
  }) : super(key: key);

  ///width of the button
  final double width;

  ///color of the button
  final Color color;

  ///icon of the button
  final IconData icon;

  /// onpress callback
  final void Function()? onPressed;

  /// true is button is loading
  final bool isLoading;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          onPressed!();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isLoading ? width - 6 : width,
          height: isLoading ? width - 6 : width,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(width / 2)),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(
                    icon,
                    color: Colors.white,
                    size: 18,
                  ),
          ),
        ),
      );
}

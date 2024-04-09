
import 'package:flutter/material.dart';
import 'package:running_app/utils/common_widgets/main_button.dart';
import 'package:running_app/utils/common_widgets/wrapper.dart';
import 'package:running_app/utils/constants.dart';

class BottomStickButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? changePasswordButtonState;
  const BottomStickButton({
    required this.text,
    this.onPressed,
    this.changePasswordButtonState,
    super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Wrapper(
        child: Container(
          margin: EdgeInsets.fromLTRB(media.width * 0.025, 15, media.width * 0.025, media.width * 0.04),
          child: CustomMainButton(
            horizontalPadding: 0,
            verticalPadding: 20,
            background: changePasswordButtonState,
            onPressed: (changePasswordButtonState == TColor.BUTTON_DISABLED) ? null : (onPressed ?? () {
              Navigator.pushNamed(context, '/home');
            }),
            child: Text(
              text,
              style: TxtStyle.headSection
            ),
          ),
        )
    );
  }
}

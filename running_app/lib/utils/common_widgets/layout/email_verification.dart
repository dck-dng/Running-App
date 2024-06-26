import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:running_app/utils/common_widgets/layout/header.dart';
import 'package:running_app/utils/common_widgets/form/input_decoration.dart';
import 'package:running_app/utils/common_widgets/button/main_button.dart';
import 'package:running_app/utils/common_widgets/layout/main_wrapper.dart';
import 'package:running_app/utils/common_widgets/layout/default_background_layout.dart';
import 'package:running_app/utils/common_widgets/form/text_form_field.dart';
import 'package:running_app/utils/constants.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: DefaultBackgroundLayout(
        child: Stack(
          children: [
            MainWrapper(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Header(title: "", noIcon: true,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/img/util/mailbox_envelop.svg",
                      ),
                      SizedBox(height: media.height * 0.015,),
                      Text(
                        "Verify your email",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TColor.PRIMARY_TEXT,
                          fontSize: FontSize.LARGE,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      SizedBox(height: media.height * 0.015,),
                      SizedBox(
                        width: media.width * 0.85,
                        child: Text(
                          "Enter the email associated with your account we’ll send email with password to verify",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.DESCRIPTION,
                              fontSize: FontSize.SMALL,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      SizedBox(height: media.height * 0.02,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for(int i = 0; i < 4; i++)...[
                            SizedBox(
                              width: media.width * 0.16,
                              height: media.height * 0.1,
                              child: CustomTextFormField(
                                decoration: CustomInputDecoration(
                                  fillColor: TColor.SECONDARY_BACKGROUND,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 26,
                                    vertical: 20
                                  )
                                ),
                                inputTextStyle: TextStyle(
                                  color: TColor.PRIMARY_TEXT,
                                  fontSize: FontSize.LARGE,
                                  fontWeight: FontWeight.w900
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                              ),
                            ),
                            if(i != 3) SizedBox(width: media.width * 0.03,)
                          ]
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CustomMainButton(
                        horizontalPadding: media.width * 0.32,
                        onPressed: () {},
                        child: Text(
                          "Verify Email",
                          style: TextStyle(
                              color: TColor.PRIMARY_TEXT,
                              fontSize: FontSize.LARGE,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      SizedBox(height: media.height * 0.02,),
                      CustomMainButton(
                        horizontalPadding: media.width * 0.29,
                        onPressed: () {},
                        background: Colors.transparent,
                        borderWidth: 2,
                        borderWidthColor: TColor.PRIMARY,
                        borderRadius: 16,
                        child: Text(
                          "Open mail app",
                          style: TextStyle(
                              color: TColor.PRIMARY,
                              fontSize: FontSize.LARGE,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

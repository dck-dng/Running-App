import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:running_app/utils/common_widgets/main_wrapper.dart';

import '../../utils/constants.dart';
import '../../utils/common_widgets/back_button.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  List guidelineArr = [
    {
      "title": "Run",
      "description": 'Lorem ipsum dolor sit, '
          'amet consectetur adipisicing elit. '
          'Illum nesciunt necessitatibus sapiente doloribus aut, '
          'similique eius. Accusamus laboriosam perferendis alias?',
    },
    {
      "title": "Health",
      "description": "Lorem ipsum dolor sit amet consectetur adipisicing elit. Assumenda, deserunt molestiae rem deleniti exercitationem ex beatae laborum minus possimus architecto."
    },
    {
      "title": "Community",
      "description": "Lorem ipsum dolor sit amet consectetur adipisicing elit. Perferendis blanditiis ex qui harum eveniet odit!"
    }
  ];

  int _currentIndex = 0;

  void _nextSlide() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % guidelineArr.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.PRIMARY_BACKGROUND,
      body: Stack(children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, media.height * 1 / 5, 0, 0),
          child: SvgPicture.asset(
              'assets/img/login/on_board_bg.svg',
              width: media.width,
              fit: BoxFit.contain
          ),
        ),

        MainWrapper(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(context: context),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/sign_in');
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )
                  )
                ]
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: guidelineArr.map((guideline) {
                      return Expanded(
                        child: Container(
                          width: media.width * 0.9,
                          height: media.height * 0.2,
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: TColor.SECONDARY_BACKGROUND,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guideline['title'],
                                style: TextStyle(
                                  color: TColor.PRIMARY_TEXT,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                guideline['description'],
                                style: TextStyle(
                                  color: TColor.DESCRIPTION,
                                  fontSize: 16,
                                ),
                                maxLines: 2, // Restrict maximum number of lines
                                overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: media.width * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: TColor.DESCRIPTION,
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign_in');
                        },
                        child: Text(
                          'Sign in',
                            style: TextStyle(
                              color: TColor.PRIMARY,
                              fontSize: FontSize.NORMAL,
                              fontWeight: FontWeight.w500,
                            )
                        )
                      )
                    ],
                  )
                ]
              ),
            ]
          )
        )
      ],)
    );
  }
}
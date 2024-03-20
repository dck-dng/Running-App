import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:running_app/models/activity/club.dart';
import 'package:running_app/services/api_service.dart';
import 'package:running_app/utils/common_widgets/app_bar.dart';
import 'package:running_app/utils/common_widgets/athlete_table.dart';
import 'package:running_app/utils/common_widgets/default_background_layout.dart';
import 'package:running_app/utils/common_widgets/header.dart';
import 'package:running_app/utils/common_widgets/icon_button.dart';
import 'package:running_app/utils/common_widgets/main_wrapper.dart';
import 'package:running_app/utils/common_widgets/progress_bar.dart';
import 'package:running_app/utils/common_widgets/scroll_synchronized.dart';
import 'package:running_app/utils/common_widgets/separate_bar.dart';
import 'package:running_app/utils/common_widgets/text_button.dart';
import 'package:running_app/utils/constants.dart';
import 'package:running_app/utils/providers/token_provider.dart';

class EventGroupDetailView extends StatefulWidget {
  const EventGroupDetailView({super.key});

  @override
  State<EventGroupDetailView> createState() => _EventGroupDetailViewState();
}

class _EventGroupDetailViewState extends State<EventGroupDetailView> {
  DetailClub? club;
  String clubId = "c97fbc66-6b4a-4e02-95a3-9dc1f554a595";
  String token = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      token = Provider.of<TokenProvider>(context).token;
    });
    api();
    super.didChangeDependencies();
  }

  Future<void> api() async {
    try {
      final data = await callRetrieveAPI(
          'activity/club', "c97fbc66-6b4a-4e02-95a3-9dc1f554a595", null, DetailClub.fromJson, token);
      setState(() {
        club = data;
      });
    }
    catch(e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    ScrollController childScrollController = ScrollController();
    ScrollController parentScrollController = ScrollController();
    print('$club $clubId $token');
    List statsList = [
      {
        "icon": "assets/img/activity/distance_icon.svg",
        "figure": '4813123,7',
        "type": "Km"
      },
      {
        "icon": "assets/img/community/people.svg",
        "figure": '178',
        "type": "Members"
      },
      {
        "icon": "assets/img/community/ranking.svg",
        "figure": '1',
        "type": "Rank"
      }
    ];

    var media = MediaQuery.sizeOf(context);
    return Scaffold(
        body: SingleChildScrollView(
          controller: parentScrollController,
          child: DefaultBackgroundLayout(
            child: Stack(
                children: [
                  Stack(
                    children: [
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.6),
                          BlendMode.darken,
                        ),
                        child: Image.asset(
                          "assets/img/community/ptit_background.jpg",
                          width: media.width,
                          height: media.height * 0.2,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: media.width * 0.025,
                            top: media.height * 0.14
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            "assets/img/community/ptit_logo.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  MainWrapper(
                    topMargin: media.height * 0.05,
                    leftMargin: 0,
                    rightMargin: 0,
                    child: const Header(title: "", iconButtons: [
                      {
                        "icon": Icons.more_vert_rounded,
                      }
                    ],),
                  ),
                  MainWrapper(
                    child: Column(
                      children: [
                        SizedBox(height: media.height * 0.2,),

                        // Main section
                        Container(
                          margin: EdgeInsets.only(left: media.width * 0.25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.flag_circle_rounded,
                                    color: TColor.PRIMARY_TEXT,
                                  ),
                                  SizedBox(width: media.width * 0.01,),
                                  Text(
                                    "Running group",
                                    style: TextStyle(
                                        color: TColor.PRIMARY_TEXT,
                                        fontSize: FontSize.NORMAL,
                                        fontWeight: FontWeight.w800
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: media.height * 0.01,),
                              Row(
                                children: [
                                  Icon(
                                    Icons.shield_outlined,
                                    color: TColor.PRIMARY_TEXT,
                                  ),
                                  SizedBox(width: media.width * 0.01,),
                                  Text(
                                    "Dang Minh Duc",
                                    style: TextStyle(
                                        color: TColor.DESCRIPTION,
                                        fontSize: FontSize.NORMAL,
                                        fontWeight: FontWeight.w800
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: media.height * 0.005,),
                              CustomTextButton(
                                onPressed: () {},
                                child: Container(
                                  width: media.width * 0.33,
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: TColor.SECONDARY_BACKGROUND,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: TColor.BORDER_COLOR,
                                        width: 2
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.people_alt_rounded,
                                        color: TColor.PRIMARY_TEXT,
                                      ),
                                      Text(
                                        "Joined",
                                        style: TextStyle(
                                            color: TColor.PRIMARY_TEXT,
                                            fontSize: FontSize.NORMAL,
                                            fontWeight: FontWeight.w800
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: TColor.PRIMARY_TEXT,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: media.height * 0.02,),

                        // Event target section
                        Container(
                          margin: EdgeInsets.only(
                            // left: media.width * 0.03
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                          decoration: BoxDecoration(
                            color: TColor.PRIMARY,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.flag_circle_rounded,
                                    color: TColor.PRIMARY_TEXT,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Target: ",
                                    style: TextStyle(
                                        color: TColor.DESCRIPTION,
                                        fontSize: FontSize.SMALL,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "25000.0 km",
                                    style: TextStyle(
                                        color: TColor.PRIMARY_TEXT,
                                        fontSize: FontSize.LARGE,
                                        fontWeight: FontWeight.w800),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: media.height * 0.01,
                              ),
                              ProgressBar(
                                totalSteps: 10,
                                currentStep: 8,
                                width: media.width,
                              ),
                              SizedBox(
                                height: media.height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "0 days left",
                                    style: TextStyle(
                                        color: TColor.DESCRIPTION,
                                        fontSize: FontSize.SMALL,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: TColor.PRIMARY_TEXT,
                                            fontSize: FontSize.SMALL,
                                            fontWeight: FontWeight.w500),
                                        children: const [
                                          TextSpan(
                                            text: "208416.86",
                                            style: TextStyle(
                                              color: Color(0xff6cb64f),
                                            ),
                                          ),
                                          TextSpan(text: "/25000.0km")
                                        ]),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: media.height * 0.02,),

                        // Stats section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for(var stats in statsList)...[
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    stats["icon"],
                                    width: media.width * 0.08,
                                    height: media.width * 0.08,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(height: media.height * 0.008,),
                                  Text(
                                    "${stats["figure"]}",
                                    style: TextStyle(
                                        color: TColor.PRIMARY_TEXT,
                                        fontSize: FontSize.SMALL,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.6
                                    ),
                                  ),
                                  Text(
                                      "${stats["type"]}",
                                      style: TextStyle(
                                          color: TColor.DESCRIPTION,
                                          fontSize: FontSize.NORMAL,
                                          fontWeight: FontWeight.w500
                                      )
                                  ),
                                ],
                              ),
                              if(statsList.indexOf(stats) != 2) SeparateBar(width: 2, height: media.height * 0.07)
                            ]
                          ],
                        ),
                        SizedBox(height: media.height * 0.02,),

                        // Description section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description",
                              style: TxtStyle.headSection,
                            ),
                            SizedBox(height: media.height * 0.01,),
                            Text(
                              "DescriptionDescription DescriptionDescriptionDescriptionDescription",
                              style: TxtStyle.descSection,
                            )
                          ],
                        ),
                        SizedBox(height: media.height * 0.02,),

                        // Group ranking
                        Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "Weekly statistics",
                                      style: TxtStyle.headSection
                                  ),
                                  CustomIconButton(
                                    icon: Icon(
                                      Icons.filter_list_rounded,
                                      color: TColor.PRIMARY_TEXT,
                                    ),
                                    onPressed: () {},
                                  )
                                ]
                            ),
                            SizedBox(height: media.height * 0.01,),
                            ScrollSynchronized(
                              parentScrollController: parentScrollController,
                              child: AthleteTable(participants: club?.participants, tableHeight: media.height - media.height * 0.15, controller: childScrollController,),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ]
            ),
          ),
        )
    );
  }
}
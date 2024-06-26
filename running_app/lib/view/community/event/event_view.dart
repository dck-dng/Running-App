import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:running_app/models/account/activity.dart';
import 'package:running_app/models/account/user.dart';
import 'package:running_app/models/activity/user_participation.dart';
import 'package:running_app/models/activity/user_participation.dart';
import 'package:running_app/utils/common_widgets/layout/loading.dart';
import 'package:running_app/utils/common_widgets/layout/main_wrapper.dart';
import 'package:running_app/utils/common_widgets/show_modal_bottom/show_filter.dart';
import 'package:running_app/utils/function.dart';
import 'package:running_app/utils/providers/user_provider.dart';
import 'package:running_app/view/community/event/utils/common_widgets/event_box.dart';
import 'package:provider/provider.dart';
import 'package:running_app/models/activity/event.dart';
import 'package:running_app/services/api_service.dart';

import 'package:running_app/utils/common_widgets/form/search_filter.dart';
import 'package:running_app/utils/common_widgets/button/text_button.dart';
import 'package:running_app/utils/providers/token_provider.dart';
import 'package:running_app/utils/constants.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  List<dynamic> popularEvents = [];
  List<dynamic> allEvents = [];
  String token = "";
  DetailUser? user;
  Activity? userActivity;
  bool isLoading = true, isLoading2 = false;
  bool showClearButton = false;
  bool checkJoin = false;
  TextEditingController searchTextController = TextEditingController();


  void getProviderData() {
    setState(() {
      token = Provider.of<TokenProvider>(context).token;
      user = Provider.of<UserProvider>(context).user;
    });
  }

  Future<void> initUserActivity() async {
    final activity = await callRetrieveAPI(
        null, null,
        user?.activity,
        Activity.fromJson,
        token,
        queryParams: "?fields=_"
    );
    setState(() {
      userActivity = activity;
    });
  }

  Future<void> initEvents() async{
    final data1 = await callListAPI('activity/event', Event.fromJson, token, queryParams: "?sort=-participants&limit=10");
    final data2 = await callListAPI('activity/event', Event.fromJson, token, queryParams: "?limit=20");
    setState(() {
      // popularEvents.addAll(data1.map((e) {
      //   return {
      //     "event": e as dynamic,
      //     "joinButtonState": checkUserInEvent(e.id)
      //   };
      // }).toList() ?? []);
      //
      // allEvents.addAll(data2.map((e) {
      //   return {
      //     "event": e as dynamic,
      //     "joinButtonState":
      //   };
      // }).toList() ?? []);
      //
      popularEvents = data1.map((e) {
        return {
          "event": e as dynamic,
          "joinButtonState": (e.checkUserJoin == null)
              ? false : true,
        };
      }).toList();

      allEvents = data2.map((e) {
        return {
          "event": e as dynamic,
          "joinButtonState": (e.checkUserJoin == null)
              ? false : true,
        };
      }).toList();
    });
  }

  void delayedInit ({
    bool reload = false,
    bool reload2 = false,
    bool initSide = false,
    int? milliseconds,
  }) async {
    if(reload) {
      setState(() {
        isLoading = true;
      });
    }
    if(reload2) {
      setState(() {
        isLoading2 = true;
      });
    }

    if(initSide) {
      await initUserActivity();
    }

    await initEvents();
    await Future.delayed(Duration(milliseconds: milliseconds ?? 500));

    setState(() {
      isLoading = false;
      isLoading2 = false;
    });
  }

  void handleSearch() {
    if(searchTextController.text != "") {
      Navigator.pushNamed(context, '/event_filter', arguments: {
        "searchText": searchTextController.text
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getProviderData();
    delayedInit(initSide: true);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    List text = ["Joined: ${userActivity?.totalEventJoined}", "Ended: ${userActivity?.totalEndedEventJoined}"];
    return (isLoading == false) ? Column(
      children: [
        // Search events section
        MainWrapper(
            topMargin: 0,
            bottomMargin: 0,
            child: SearchFilter(
                controller: searchTextController,
                hintText: "Search events",
                filterOnPressed: () async {
                  Map<String, String?> filterArgument = await showFilter(
                      context,
                      [
                        {
                          "title": "State",
                          "list": ["All ", "Upcoming", "Ongoing", "Ended"]
                        },
                        {
                          "title": "Event mode",
                          "list": ["Public", "Private"]
                        },
                        {
                          "title": "Competition",
                          "list": ["Group", "Individual"]
                        },
                      ],
                      buttonClicked: ["", "", ""]
                  );
                  Navigator.pushNamed(context, '/event_filter', arguments: {
                    "filterArgument": filterArgument
                  });

                },
                onPrefixPressed: handleSearch,
                onFieldSubmitted: (_) => handleSearch(),
                onClearChanged: () {
                  searchTextController.clear();
                },
                showClearButton: showClearButton,
            )),
        SizedBox(height: media.height * 0.01,),

        // Your event section
        MainWrapper(
          topMargin: 0,
          bottomMargin: 0,
          child: CustomTextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/your_event_list');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                  color: TColor.SECONDARY_BACKGROUND,
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                children: [
                  Transform.rotate(
                    angle: 270,
                    child: SvgPicture.asset(
                      "assets/img/community/calendar.svg",
                      width: media.width * 0.1,
                      height: media.height *  0.1,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: media.width * 0.01,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your events",
                        style: TextStyle(
                            color: TColor.PRIMARY_TEXT,
                            fontSize: FontSize.NORMAL,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        "View your events here",
                        style: TextStyle(
                            color: TColor.DESCRIPTION,
                            fontSize: FontSize.SMALL,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(height: media.height * 0.01,),
                      Row(
                        children: [
                          for(var x in text)...[
                            Container(
                              width: media.width * 0.3,
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                  color: TColor.PRIMARY.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              child: Text(
                                x,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: TColor.PRIMARY_TEXT,
                                    fontSize: FontSize.SMALL,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                            ),
                            SizedBox(width: media.width * 0.015,),
                          ]
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: media.height * 0.03,),

        SizedBox(
          height: media.height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Popular Events
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainWrapper(
                      topMargin: 0,
                      bottomMargin: 0,
                      child: Text(
                        "Popular events",
                        style: TxtStyle.headSectionExtra,
                      ),
                    ),
                    SizedBox(height: media.height * 0.01,),
                    SizedBox(
                      height: media.height * 0.45,
                      child: CarouselSlider(
                        options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 4),
                            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                            viewportFraction: 0.9,
                            initialPage: 0,
                            aspectRatio: 1.1,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.16,
                            enableInfiniteScroll: false
                        ),

                        items: [
                          for(var event in popularEvents ?? [])...[
                            Container(
                                margin: const EdgeInsets.only(right: 15),
                                child: EventBox(
                                  eventDetailOnPressed: () async {
                                    Map<String, dynamic> result = await Navigator.pushNamed(context, '/event_detail', arguments: {
                                      "id": event["event"]?.id,
                                      "userInEvent": event["joinButtonState"],
                                    }) as Map<String, dynamic>;
                                    setState(() {
                                      checkJoin = result["checkJoin"];
                                    });
                                    if(checkJoin) {
                                      print("CHECK JOIN $checkJoin");
                                      delayedInit(reload: true);
                                    }
                                  },
                                  event: event["event"],
                                  joined: event["joinButtonState"],
                                  joinOnPressed: (value) async {
                                    if(!event["joinButtonState"]) {
                                      UserParticipationEvent userParticipationClub = UserParticipationEvent(
                                          userId: getUrlId(user?.activity ?? ""),
                                          eventId: event["event"].id,
                                      );
                                      final data = await callCreateAPI(
                                          'activity/user-participation-event',
                                          userParticipationClub.toJson(),
                                          token
                                      );
                                      delayedInit(milliseconds: 0);
                                      event["event"].checkUserJoin = data["id"];
                                    }
                                    else {
                                      // await callDestroyAPI(
                                      //     'activity/user-participation-event',
                                      //     event["event"].checkUserJoin,
                                      //     token
                                      // );
                                      // delayedInit(milliseconds: 0);
                                      Map<String, dynamic> result = await Navigator.pushNamed(context, '/event_detail', arguments: {
                                        "id": event["event"]?.id,
                                        "userInEvent": event["joinButtonState"],
                                      }) as Map<String, dynamic>;
                                      setState(() {
                                        checkJoin = result["checkJoin"];
                                      });
                                      if(checkJoin) {
                                        print("CHECK JOIN $checkJoin");
                                        delayedInit(reload: true);
                                      }
                                    }
                                    setState(() {
                                      event["joinButtonState"] = value;
                                      print("CHANGE: ${event["event"].name} 2 ${event["joinButtonState"]}");
                                    });
                                  },
                                )
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.height * 0.02,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainWrapper(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "All events",
                                style: TxtStyle.headSectionExtra
                            ),
                            CustomTextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/event_list');
                              },
                              child: Text(
                                  "See all",
                                  style: TextStyle(
                                    color: TColor.PRIMARY,
                                    fontSize: FontSize.LARGE,
                                    fontWeight: FontWeight.w500,
                                  )
                              ),
                            )
                          ]
                      ),
                    ),
                    SizedBox(height: media.height * 0.01,),
                    SizedBox(
                      height: media.height * 0.36,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 10),

                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for(var event in allEvents ?? [])...[
                              IntrinsicHeight(
                                  child: EventBox(
                                    eventDetailOnPressed: () async {
                                      Map<String, dynamic> result = await Navigator.pushNamed(context, '/event_detail', arguments: {
                                        "id": event["event"]?.id,
                                        "userInEvent": event["joinButtonState"],
                                      }) as Map<String, dynamic>;
                                      setState(() {
                                        checkJoin = result["checkJoin"];
                                      });
                                      if(checkJoin) {
                                        print("CHECK JOIN $checkJoin");
                                        delayedInit(reload: true);
                                      }
                                    },
                                    joined: event["joinButtonState"],
                                    event: event["event"], width: 200,
                                    buttonMargin: const EdgeInsets.fromLTRB(12, 0, 12, 12), small: true,
                                    joinOnPressed: (value) async {
                                      if(!event["joinButtonState"]) {
                                        UserParticipationEvent userParticipationClub = UserParticipationEvent(
                                          userId: getUrlId(user?.activity ?? ""),
                                          eventId: event["event"].id,
                                        );
                                        final data = await callCreateAPI(
                                            'activity/user-participation-event',
                                            userParticipationClub.toJson(),
                                            token
                                        );
                                        delayedInit(milliseconds: 0);
                                        event["event"].checkUserJoin = data["id"];
                                      }
                                      else {
                                        // await callDestroyAPI(
                                        //     'activity/user-participation-event',
                                        //     event["event"].checkUserJoin,
                                        //     token
                                        // );
                                        // delayedInit(milliseconds: 0);
                                        Map<String, dynamic> result = await Navigator.pushNamed(context, '/event_detail', arguments: {
                                          "id": event["event"]?.id,
                                          "userInEvent": event["joinButtonState"],
                                        }) as Map<String, dynamic>;
                                        setState(() {
                                          checkJoin = result["checkJoin"];
                                        });
                                        if(checkJoin) {
                                          print("CHECK JOIN $checkJoin");
                                          delayedInit(reload: true);
                                        }
                                      }
                                      setState(() {
                                        event["joinButtonState"] = value;
                                      });
                                    },
                                  )
                              ),
                              const SizedBox(width: 10,)
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    ) : Loading(
      marginTop: media.height * 0.35,
      backgroundColor: Colors.transparent,
    );

  }
}

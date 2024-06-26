import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:running_app/models/account/activity.dart';
import 'package:running_app/models/account/user.dart';
import 'package:running_app/models/activity/event.dart';
import 'package:running_app/services/api_service.dart';
import 'package:running_app/utils/common_widgets/layout/app_bar.dart';
import 'package:running_app/utils/common_widgets/layout/default_background_layout.dart';
import 'package:running_app/utils/common_widgets/layout/header.dart';
import 'package:running_app/utils/common_widgets/form/input_decoration.dart';
import 'package:running_app/utils/common_widgets/layout/loading.dart';
import 'package:running_app/utils/common_widgets/layout/main_wrapper.dart';
import 'package:running_app/utils/common_widgets/form/search_filter.dart';
import 'package:running_app/utils/common_widgets/show_modal_bottom/show_filter.dart';
import 'package:running_app/utils/common_widgets/button/text_button.dart';
import 'package:running_app/utils/common_widgets/form/text_form_field.dart';
import 'package:running_app/utils/constants.dart';
import 'package:running_app/utils/providers/token_provider.dart';
import 'package:running_app/utils/providers/user_provider.dart';
import 'package:running_app/view/community/event/utils/common_widgets/event_list.dart';

class EventFilterView extends StatefulWidget {
  const EventFilterView({super.key});

  @override
  State<EventFilterView> createState() => _EventFilterViewState();
}

class _EventFilterViewState extends State<EventFilterView> {
  DetailUser? user;
  Activity? userActivity;
  bool isLoading = true, isLoading2 = false;
  String eventType = "Ongoing";
  List<dynamic> events = [];
  String token = "";
  bool showClearButton = false;
  String stateFilter = "All";
  String eventModeFilter = "";
  String competitionFilter = "";
  bool allowInitByArgument = true, checkJoin = false;
  TextEditingController searchTextController = TextEditingController();

  void getData() {
    setState(() {
      Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      token = Provider.of<TokenProvider>(context).token;
      user = Provider.of<UserProvider>(context).user;
      if(allowInitByArgument) {
        searchTextController.text = arguments?["searchText"] ?? "";
        Map<String, String?>? filterArgument = arguments?["filterArgument"];
        if(filterArgument != null) {
          stateFilter = (filterArgument["State"] == "") ? stateFilter : filterArgument["State"] ?? "";
          eventModeFilter = filterArgument["Event mode"]!;
          competitionFilter = filterArgument["Competition"]!;
        }
      }
      allowInitByArgument = false;
    });
  }

  Future<void> initUserActivity() async {
    final data = await callRetrieveAPI(
        null, null,
        user?.activity,
        Activity.fromJson,
        token,
        queryParams: "?fields=events"
    );
    setState(() {
      userActivity = data;
    });
  }

  Future<void> initEvents() async {
    final data = await callListAPI(
        'activity/event',
        Event.fromJson,
        token,
        queryParams: "?"
            "state=${(stateFilter != "All") ? stateFilter : ""}&"
            "name=${searchTextController.text}&"
            "mode=${eventModeFilter}&"
            "competition=${competitionFilter}"
    );
    setState(() {
      // events.addAll(data.map((e) {
      //   return {
      //     "event": e as dynamic,
      //     "joined": checkUserInEvent(e.id)
      //   };
      // }).toList() ?? []);
      // events = data.map((e) {
      //   return {
      //     "event": e as dynamic,
      //     "joined": (e.checkUserJoin == null) ? false : true,
      //   };
      // }).toList();
      events = data.map((e) {
        return {
          "event": e as dynamic,
          "joinButtonState": (e.checkUserJoin == null)
              ? false : true,
        };
      }).toList();
    });
  }

  Future<void> delayedInit({
    bool reload = false,
    bool reload2 = false,
    bool initSide = false
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
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isLoading = false;
      isLoading2 = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getData();
    delayedInit(initSide: true);
    // filter();
  }

  void filter() async {
    Map<String, String?> result = await showFilter(
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
        buttonClicked: [stateFilter, eventModeFilter, competitionFilter]
    );

    setState(() {
      stateFilter = result["State"] ?? "";
      eventModeFilter = result["Event mode"] ?? "";
      competitionFilter = result["Competition"] ?? "";
      delayedInit(reload: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("?state=${(stateFilter != "All events") ? stateFilter : ""}&"
        "name=${searchTextController.text}&"
        "mode=${eventModeFilter}&"
        "competition=${competitionFilter}");
    print("Events length: ${events?.length}");
    var media = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: const Header(title: "Filters", noIcon: true,),
        backgroundImage: TImage.PRIMARY_BACKGROUND_IMAGE,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: DefaultBackgroundLayout(
          child: Stack(
            children: [
              MainWrapper(
                bottomMargin: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search
                    SearchFilter(
                        hintText: "Search events",
                        controller: searchTextController,
                        showClearButton: showClearButton,
                        onClearChanged: () {
                          searchTextController.clear();
                          setState(() {
                            showClearButton = false;
                          });
                          delayedInit(reload: true);
                        },
                        onFieldSubmitted: (String x) {
                          delayedInit(reload: true);
                        },
                        onPrefixPressed: () {
                          delayedInit(reload: true);
                        },
                        filterOnPressed: () async {
                          Map<String, String?> result =await showFilter(
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
                              buttonClicked: [stateFilter, eventModeFilter, competitionFilter]
                          );

                          setState(() {
                            stateFilter = result["State"] ?? "";
                            eventModeFilter = result["Event mode"] ?? "";
                            competitionFilter = result["Competition"] ?? "";
                            delayedInit(reload: true);
                          });
                        }
                    ),
                    SizedBox(height: media.height * 0.015,),
                    if(isLoading == false)...[
                      EventList(
                        scrollHeight: media.height * 0.75,
                        eventType: "$stateFilter events",
                        events: events,
                        token: token,
                        user: user,
                        reload: delayedInit,
                        checkJoin: checkJoin,
                        checkJoinChange: (value) {
                          setState(() {
                            checkJoin = value;
                          });
                        },
                      )
                    ]
                    else...[
                      Loading(
                        backgroundColor: Colors.transparent,
                      )
                    ]
                  ],
                ),
              ),
              if(isLoading2)...[
                Loading(
                  backgroundColor: Colors.transparent,
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}


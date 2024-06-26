import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:running_app/models/account/user.dart';
import 'package:running_app/models/account/activity.dart';
import 'package:running_app/models/activity/event.dart';
import 'package:running_app/services/api_service.dart';
import 'package:running_app/utils/common_widgets/button/main_button.dart';
import 'package:running_app/utils/common_widgets/button/text_button.dart';
import 'package:running_app/utils/constants.dart';
import 'package:running_app/utils/providers/token_provider.dart';
import 'package:running_app/utils/providers/user_provider.dart';

class EventBox extends StatefulWidget {
  final EdgeInsets? buttonMargin;
  final double? width;
  final String? buttonText;
  final Event? event;
  final bool? small;
  final bool joined;
  final ValueChanged<bool>? joinOnPressed;
  final VoidCallback? eventDetailOnPressed;

  const EventBox({
    this.buttonMargin,
    this.width,
    this.buttonText,
    this.event,
    this.small = false,
    required this.joined,
    this.joinOnPressed,
    this.eventDetailOnPressed,
    super.key
  });

  @override
  State<EventBox> createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {
  // String token = "";
  // DetailUser? user;
  // Activity? userActivity;
  // bool userInEvent = false;
  // bool _disposed = false;
  //
  // @override
  // void dispose() {
  //   _disposed = true;
  //   super.dispose();
  // }
  //
  // void initToken() {
  //   if (!_disposed) {
  //     setState(() {
  //       token = Provider.of<TokenProvider>(context).token;
  //     });
  //   }
  // }
  //
  // void initUser() {
  //   if (!_disposed) {
  //     setState(() {
  //       user = Provider.of<UserProvider>(context).user;
  //     });
  //   }
  // }
  //
  // void initUserActivity() async {
  //   if (!_disposed) {
  //     final data = await callRetrieveAPI(
  //         null,
  //         null,
  //         user?.activity,
  //         Activity.fromJson,
  //         token
  //     );
  //     setState(() {
  //       userActivity = data;
  //       userInEvent = checkUserInEvent();
  //     });
  //   }
  // }
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   initToken();
  //   initUser();
  //   initUserActivity();
  // }
  //
  // bool checkUserInEvent() {
  //   return (userActivity?.events ?? []).where((e) => e.id == widget.event?.id).toList().length != 0;
  // }

  @override
  Widget build(BuildContext context) {
    if(widget.event?.name == "Graves LLC") {
      print("CHANGE: ${widget.event?.name}: ${widget.joined}");
    }
    var media = MediaQuery.sizeOf(context);
    return CustomTextButton(
      onPressed: widget.eventDetailOnPressed,
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: TColor.SECONDARY_BACKGROUND,
          boxShadow: [
            BShadow.customBoxShadow
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)
                  ),
                  child: Image.asset(
                    "assets/img/community/ptit_background.jpg",
                    width: media.width,
                    height: media.height * 0.15,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: media.height * 0.01,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Text(
                    widget.event?.name ?? "",
                    style: TextStyle(
                        color: TColor.PRIMARY_TEXT,
                        fontSize: FontSize.NORMAL,
                        fontWeight: FontWeight.w700
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  // vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: media.height * 0.01,),
                    for(var x in [
                      {
                        "icon": Icons.calendar_today_rounded,
                        "text": "Ends in: ${widget.event?.daysRemain}",
                      },
                      {
                        "icon": Icons.people_alt_outlined,
                        "text": "Join: ${widget.event?.totalParticipants}"
                      },
                      (widget.small == false) ?{
                        "icon": Icons.directions_run_rounded,
                        "text": "Competition: ${widget.event?.competition}"
                      } : null
                    ])...[
                      if(x != null)...[
                        Row(
                          children: [
                            Icon(
                              x["icon"] as IconData,
                              color: TColor.DESCRIPTION,
                            ),
                            SizedBox(width: media.width * 0.02,),
                            Text(
                              x["text"] as String,
                              style: TextStyle(
                                color: TColor.DESCRIPTION,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: media.height * 0.01,),
                      ]
                    ],
                  ],
                )
            ),
            Container(
              width: media.width,
              margin: widget.buttonMargin ?? const EdgeInsets.fromLTRB(12, 0, 12, 20),
              child: CustomMainButton(
                background: widget.joined ? TColor.BUTTON_DISABLED : TColor.PRIMARY,
                horizontalPadding: 0,
                verticalPadding: 12,
                onPressed:
                // joined ? null : () {
                //   Navigator.pushNamed(context, '/event_detail', arguments: {
                //     "id": widget.event?.id,
                //   });
                // },
                 () {
                  // widget.joinOnPressed(joined);
                   widget.joinOnPressed?.call(!widget.joined);
                },
                child: Text(
                  (widget.joined ? "Joined" : "Join now"),
                  style: TextStyle(
                      color: TColor.PRIMARY_TEXT,
                      fontSize: FontSize.LARGE,
                      fontWeight: FontWeight.w800
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

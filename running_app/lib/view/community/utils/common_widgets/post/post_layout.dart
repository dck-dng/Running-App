import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:running_app/models/account/user.dart';
import 'package:running_app/models/activity/activity_record.dart';
import 'package:running_app/models/social/post.dart';
import 'package:running_app/services/api_service.dart';
import 'package:running_app/utils/common_widgets/default_background_layout.dart';
import 'package:running_app/utils/common_widgets/empty_list_notification.dart';
import 'package:running_app/utils/common_widgets/loading.dart';
import 'package:running_app/utils/common_widgets/main_wrapper.dart';
import 'package:running_app/utils/common_widgets/separate_bar.dart';
import 'package:running_app/utils/common_widgets/text_button.dart';
import 'package:running_app/utils/constants.dart';
import 'package:running_app/utils/providers/token_provider.dart';
import 'package:running_app/utils/providers/user_provider.dart';
import 'package:running_app/view/community/feed/utils/common_widget/activity_record_post.dart';
import 'package:running_app/view/community/utils/common_widgets/post/post.dart';
import 'package:running_app/view/community/utils/common_widgets/post/post_create_button.dart';

class PostLayout extends StatefulWidget {
  List<dynamic>? posts;
  bool isLoading;
  String postType;

  PostLayout({
    required this.posts,
    required this.isLoading,
    required this.postType,
    super.key
  });

  @override
  State<PostLayout> createState() => _PostLayoutState();
}

class _PostLayoutState extends State<PostLayout> {
  String token = "";
  DetailUser? user;

  ScrollController childScrollController = ScrollController();

  void getProviderData() {
    setState(() {
      token = Provider.of<TokenProvider>(context).token;
      user = Provider.of<UserProvider>(context).user;
    });
  }

  Future<void> handleRefresh() async {

  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    print(widget.posts);
    // print('Activity Record: ${posts?.length}');
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: DefaultBackgroundLayout(
        child: Stack(
          children: [
            Column(
              children: [
                if(widget.postType == "club")...[
                  PostWriteButton(),
                ],
                if(widget.isLoading)...[
                  Loading(
                    marginTop: media.height * 0.2,
                    backgroundColor: Colors.transparent,
                  )
                ]
                else...[
                  RefreshIndicator(
                    onRefresh: handleRefresh,
                    child: SizedBox(
                      height: media.height * ((widget.postType == "club") ? 0.71 : 0.8),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if(widget.postType == "event")...[
                              PostWriteButton()
                            ],
                            if(widget.posts == null)...[
                              EmptyListNotification(
                                marginTop: media.height * 0.12,
                                title: "There's no post yet",
                                image: "assets/img/community/post.png",
                                imageWidget: Image.asset(
                                  "assets/img/community/post.png",
                                  width: 175,
                                  height: 175,
                                ),
                              )
                            ]
                            else...[
                              for (var post in widget.posts ?? []) ...[
                                PostWidget(
                                  token: token,
                                  post: post,
                                  checkRequestUser: user?.id == post?.user?.id,
                                  postType: widget.postType,
                                ),
                              ]
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ],
        )
      ),
    );
  }
}

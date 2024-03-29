import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:running_app/models/product/product.dart';
import 'package:running_app/services/api_service.dart';
import 'package:running_app/utils/common_widgets/app_bar.dart';
import 'package:running_app/utils/common_widgets/header.dart';
import 'package:running_app/utils/common_widgets/main_wrapper.dart';
import 'package:running_app/utils/common_widgets/menu.dart';
import 'package:running_app/utils/common_widgets/default_background_layout.dart';
import 'package:running_app/utils/common_widgets/text_button.dart';
import 'package:running_app/utils/constants.dart';
import 'package:running_app/utils/providers/token_provider.dart';

class StoreView extends StatefulWidget {
  const StoreView({super.key});

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  List<dynamic>? productList;
  String token = "";

  void initToken() {
    setState(() {
      token = Provider.of<TokenProvider>(context).token;
    });
  }

  void initProduct() async {
    final data = await callListAPI('product/product', Product.fromJson, token);
    setState(() {
      productList = data;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initToken();
    initProduct();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    List brands = [
      [
        {
          "name": "Puma",
          "logo": "assets/img/store/brand/puma_logo.svg",
        },
        {
          "name": "Reebok",
          "logo": "assets/img/store/brand/reebok_logo.svg",
        },
        {
          "name": "Nike",
          "logo": "assets/img/store/brand/nike_logo.svg",
        },
        {
          "name": "adidas",
          "logo": "assets/img/store/brand/adidas_logo.svg",
        }
      ],
      [
        {
          "name": "UA",
          "logo": "assets/img/store/brand/ua_logo.svg",
        },
        {
          "name": "Reebok",
          "logo": "assets/img/store/brand/reebok_logo.svg",
        },
        {
          "name": "Nike",
          "logo": "assets/img/store/brand/nike_logo.svg",
        },
        {
          "name": "See All",
          "logo": "assets/img/store/brand/nike_logo.svg",
        }
      ]
    ];
    return Scaffold(
        appBar: CustomAppBar(
          title: const Header(title: "Store", backButton: false,),
          backgroundImage: TImage.PRIMARY_BACKGROUND_IMAGE,
        ),
      body: SingleChildScrollView(
        child:
          DefaultBackgroundLayout(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    MainWrapper(
                        topMargin: 0,
                        child: Column(
                          children: [
                            // Header
                            // const ,
                            SizedBox(height: media.height * 0.02,),
                            // Banner
                            CustomTextButton(
                              onPressed: () {

                              },
                              child: SvgPicture.asset(
                                'assets/img/home/event_banner.svg',
                                width: media.width * 0.95,
                                fit: BoxFit.contain,
                              ), // Replace 'my_image.png' with your image asset path
                            ),
                            SizedBox(height: media.height * 0.02,),
                            // Brand
                            Column(children: [
                              for(var row in brands)
                                Column(
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      for(var brand in row)
                                        CustomTextButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              minimumSize: MaterialStateProperty.all<Size>(
                                                Size(media.width * 0.22, media.height * 0.1),
                                              ),
                                              backgroundColor: MaterialStateProperty.all<Color?>(TColor.SECONDARY_BACKGROUND),
                                              // padding: MaterialStateProperty.all<EdgeInsets>(
                                              //   EdgeInsets.symmetric(
                                              //       vertical: media.height * 0.01,
                                              //       horizontal: media.width * 0.03
                                              //   ),
                                              // ),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(16.0),
                                                ),
                                              ),
                                              side: MaterialStateProperty.all<BorderSide>(
                                                const BorderSide(color: Color(0xff495466), width: 2.0),
                                              ),
                                            ),
                                            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                              SvgPicture.asset(
                                                brand["logo"],
                                                width: media.width * 0.03,
                                                height: media.height * 0.03,
                                                fit: BoxFit.contain,
                                              ),
                                              Text(
                                                brand["name"],
                                                style: TextStyle(
                                                  color: TColor.DESCRIPTION,
                                                  fontSize: FontSize.SMALL,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            ])
                                        )
                                    ]),
                                    SizedBox(height: media.height * 0.01),
                                  ],
                                )
                            ],),

                            // Popular
                            Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Popular",
                                          style: TextStyle(
                                            color: TColor.PRIMARY_TEXT,
                                            fontSize: FontSize.NORMAL,
                                            fontWeight: FontWeight.w600,
                                          )
                                      ),
                                      CustomTextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/product');
                                        },
                                        child: Text(
                                            "See all",
                                            style: TextStyle(
                                              color: TColor.PRIMARY,
                                              fontSize: FontSize.NORMAL,
                                              fontWeight: FontWeight.w500,
                                            )
                                        ),
                                      )
                                    ]
                                ),
                                SizedBox(
                                  height: media.height, // Set a specific height
                                  child: GridView.count(
                                      padding: const EdgeInsets.all(0),
                                      crossAxisCount: 2,
                                      crossAxisSpacing: media.width * 0.05,
                                      mainAxisSpacing: media.height * 0.025,
                                      children: [
                                        for(var product in productList ?? [])
                                          CustomTextButton(
                                            onPressed: () {},
                                            child: Container(
                                              padding: EdgeInsets.all(media.width * 0.025),
                                              // width: media.width * 0.45,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12.0),
                                                color: TColor.SECONDARY_BACKGROUND,
                                                border: Border.all(
                                                  color: const Color(0xff495466),
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12.0),
                                                        ),
                                                        child: Image.asset(
                                                          "assets/img/store/product/air_force_1.png",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 5,
                                                        right: 5,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(12.0),
                                                                color: TColor.SECONDARY_BACKGROUND.withOpacity(0.7),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  SvgPicture.asset(
                                                                    "assets/img/home/coin_icon.svg",
                                                                    width: 16,
                                                                    height: 16,
                                                                    fit: BoxFit.contain,
                                                                  ),
                                                                  Text(
                                                                    product.price.toString() ?? "",
                                                                    style: TextStyle(
                                                                      color: TColor.PRIMARY_TEXT,
                                                                      fontSize: FontSize.NORMAL,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: media.height * 0.01),
                                                  Text(
                                                    product.brand.name ?? "",
                                                    style: TextStyle(
                                                      color: TColor.DESCRIPTION,
                                                      fontSize: FontSize.SMALL,
                                                    ),
                                                  ),
                                                  // SizedBox(height: media.height * 0.005),
                                                  Text(
                                                    product.name ?? "",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: TColor.PRIMARY_TEXT,
                                                      fontSize: FontSize.SMALL,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                      ]
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ],
            ),
          ),
      ),
      bottomNavigationBar: const Menu()
    );
  }
}

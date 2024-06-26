import "dart:convert";
import "dart:math";

import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:intl/intl.dart';
import "package:running_app/models/account/login.dart";
import 'package:shared_preferences/shared_preferences.dart';

import "package:running_app/models/account/user.dart";
import "package:running_app/models/account/profile.dart";
import "package:running_app/services/api_service.dart";
import "package:running_app/utils/common_widgets/layout/app_bar.dart";
import "package:running_app/utils/common_widgets/layout/header.dart";
import "package:running_app/utils/common_widgets/form/input_decoration.dart";
import "package:running_app/utils/common_widgets/layout/loading.dart";
import "package:running_app/utils/common_widgets/button/main_button.dart";
import "package:running_app/utils/common_widgets/layout/main_wrapper.dart";
import "package:running_app/utils/common_widgets/layout/default_background_layout.dart";
import "package:running_app/utils/common_widgets/show_modal_bottom/show_date_picker.dart";
import "package:running_app/utils/common_widgets/show_modal_bottom/show_month_year.dart";
import "package:running_app/utils/common_widgets/show_modal_bottom/show_notification.dart";
import "package:running_app/utils/common_widgets/button/text_button.dart";
import "package:running_app/utils/common_widgets/form/text_form_field.dart";
import "package:running_app/utils/common_widgets/layout/wrapper.dart";
import "package:running_app/utils/constants.dart";
import "package:running_app/utils/function.dart";
import "package:running_app/utils/providers/token_provider.dart";
import "package:running_app/utils/providers/user_provider.dart";

class ProfileCreateView extends StatefulWidget {
  const ProfileCreateView({super.key});

  @override
  State<ProfileCreateView> createState() => _ProfileCreateViewState();
}

class _ProfileCreateViewState extends State<ProfileCreateView> {
  // bool isLoading = true;
  String? gender = "male";
  String selectedValue = "";
  String token = "";
  DetailUser? user;
  DetailProfile? userProfile;
  String? nation, city, shirtSize, trouserSize;
  Color createProfileButtonState = TColor.BUTTON_DISABLED;
  bool nameClearButton = false;

  String? userId;
  String? email;
  String? phoneNumber;
  String? username;
  String? password;

  void getProviderData() {
    setState(() {
      token = Provider.of<TokenProvider>(context).token;
    });
  }

  void getArguments() {
    setState(() {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      userId = arguments["id"];
      email = arguments["email"];
      phoneNumber = arguments["phoneNumber"];
      username = arguments["username"];
      password = arguments["password"];
    });
  }

  Future<void> initUserProfile() async {
    final data = await callRetrieveAPI(null, null, user?.profile, DetailProfile.fromJson, token);
    setState(() {
      userProfile = data;
    });
  }

  void delayedInit() async {
    getArguments();
    initFields();
    setState(() {
      // isLoading = false;
    });
  }

  Future<void> signIn() async {
    Login login = Login(
      username: username,
      password: password,
    );
    print(login);

    final tokenResponse = await callCreateAPI(
        'account/login',
        login.toJson(), "");
    var token = tokenResponse["token"];
    Provider.of<TokenProvider>(context, listen: false).setToken(token);

    List<dynamic> users = await callListAPI('account/user', User.fromJson, token);
    final userId = users.firstWhere((element) => element.username == username).id;

    DetailUser user = await callRetrieveAPI('account/user', userId, null, DetailUser.fromJson, token);

    Provider.of<UserProvider>(context, listen: false).setUser(user,);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(user.toJson()));
    print("CHECK:");
    print(user);
    print(token);
    Navigator.pushNamed(context, '/home', arguments: {
      'token': token
    });
  }

  // void initFields() {
  //   setState(() {
  //     fields[0]["controller"].text = user?.name;
  //     fields[1]["controller"].text = user?.email;
  //     fields[4]["controller"].text = userProfile?.dateOfBirth ?? "";
  //     fields[5]["controller"].text = userProfile?.height?.toString() ?? "";
  //     fields[6]["controller"].text = userProfile?.weight?.toString() ?? "";
  //     fields[7]["controller"].text = user?.phoneNumber ?? "";
  //     fields[8]["controller"].text = userProfile?.shoeSize?.toString() ?? "";
  //     fields[2]["value"] = userProfile?.country ?? "";
  //     fields[3]["value"] = userProfile?.city ?? "";
  //     gender = userProfile?.gender?.toLowerCase();
  //     fields[9]["value"] = userProfile?.shirtSize ?? "";
  //     fields[10]["value"] = userProfile?.trouserSize ?? "";
  //   });
  // }

  void initFields() {
    setState(() {
      fields[1]["controller"].text = email ?? "";
      fields[2]["value"] = nation ?? "";
      fields[3]["value"] = city ?? "";
      fields[7]["controller"].text = phoneNumber ?? "";
    });
  }

  @override
  void didChangeDependencies() {
    delayedInit();
    super.didChangeDependencies();
  }

  final List<String> provinces = [
    'An Giang', 'Bà Rịa-Vũng Tàu', 'Bắc Giang',
    'Bắc Kạn', 'Bạc Liêu', 'Bắc Ninh',
    'Bến Tre', 'Bình Định', 'Bình Dương',
    'Bình Phước', 'Bình Thuận', 'Cà Mau',
    'Cao Bằng', 'Đắk Lắk', 'Đắk Nông',
    'Điện Biên', 'Đồng Nai', 'Đồng Tháp',
    'Gia Lai', 'Hà Giang', 'Hà Nam',
    'Hà Tĩnh', 'Hải Dương', 'Hậu Giang',
    'Hòa Bình', 'Hưng Yên', 'Khánh Hòa',
    'Kiên Giang', 'Kon Tum', 'Lai Châu',
    'Lâm Đồng', 'Lạng Sơn', 'Lào Cai',
    'Long An', 'Nam Định', 'Nghệ An',
    'Ninh Bình', 'Ninh Thuận', 'Phú Thọ',
    'Phú Yên', 'Quảng Bình', 'Quảng Nam',
    'Quảng Ngãi', 'Quảng Ninh', 'Quảng Trị',
    'Sóc Trăng', 'Sơn La', 'Tây Ninh',
    'Thái Bình', 'Thái Nguyên', 'Thanh Hóa',
    'Thừa Thiên-Huế', 'Tiền Giang', 'Trà Vinh',
    'Tuyên Quang', 'Vĩnh Long', 'Vĩnh Phúc',
    'Yên Bái', 'Phú Thọ', 'Hà Nội', 'Hồ Chí Minh City',
    'Hải Phòng', 'Đà Nẵng'
  ];

  List fields = [
    {
      "hintText": "Name*",
      "value": "",
      "controller": TextEditingController() // Name controller
    },
    {
      "hintText": "Email*",
      "value": "",
      "controller": TextEditingController() // Name controller
    },
    {
      "hintText": "Nation (Option)",
      "value": "",
    },
    {
      "hintText": "City (Option)",
      "value": "",
    },
    {
      "hintText": "Birthday*",
      "value": "",
      "controller": TextEditingController(), // Height controller
    },
    {
      "hintText": "Height (cm) (Option)",
      "value": "",
      "controller": TextEditingController(), // Height controller
    },
    {
      "hintText": "Weight (kg) (Option)",
      "value": "",
      "controller": TextEditingController(), // Weight controller
    },
    {
      "hintText": "Phone number",
      "value": "",
      "controller": TextEditingController(), // Phone number controller
    },
    {
      "hintText": "Shoe size (Option)",
      "value": "",
      "controller": TextEditingController(), // Shoe size controller
    },
    {
      "hintText": "Shirt size (Option)",
      "value": "",
    },
    {
      "hintText": "Trouser size (Option)",
      "value": "",
    },
  ];

  void checkFormData() {
    setState(() {
      createProfileButtonState =
      (fields[0]['controller'].text != "" &&
        fields[4]['value'] != ""
      )
          ? TColor.PRIMARY : TColor.BUTTON_DISABLED;
    });
  }

  void createAccountInformation() async {
    Random random = Random();
    final profile = CreateUpdateProfile(
      user_id: userId,
      name: fields[0]["controller"].text,
      country: fields[2]["value"] ?? "",
      city: fields[3]["value"] ?? "",
      gender: gender?.toUpperCase(),
      dateOfBirth: fields[4]["value"],
      height: (fields[5]["controller"].text != "") ? int.parse(fields[5]["controller"].text) : null,
      weight: (fields[6]["controller"].text != "") ? int.parse(fields[6]["controller"].text) : null,
      shoeSize: (fields[8]["controller"].text != "") ? int.parse(fields[8]["controller"].text) : null,
      shirtSize: fields[9]["value"],
      trouserSize: fields[10]["value"],
    );
    print(profile);

    final data = await callCreateAPI('account/profile', profile.toJson(), "");
    print(data);
    // showNotification(context, 'Notice', "Successfully created",
    //     onPressed: () async {
    //       await signIn();
    //     }
    // );
    await signIn();
  }
  @override
  Widget build(BuildContext context) {
    print(createProfileButtonState);
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: const Header(title: "Create Profile", noIcon: true, backButton: false,),
        backgroundImage: TImage.PRIMARY_BACKGROUND_IMAGE,
      ),
      body: SingleChildScrollView(
        child: DefaultBackgroundLayout(
          child: Stack(
            children: [
              // if(isLoading == false)...[
                MainWrapper(
                  child: Column(
                    children: [
                      CustomTextButton(
                        onPressed: () {},
                        child: Stack(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/img/community/ptit_logo.png",
                                  width: 100,
                                  height: 100,
                                )
                            ),
                            const SizedBox(
                              height: 120,
                              width: 100,
                            ),
                            Positioned(
                              bottom: 10,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: TColor.PRIMARY
                                ),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: TColor.PRIMARY_TEXT,
                                  size: 25,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: media.height * 0.015,),

                      // Information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Information",
                            style: TextStyle(
                                color: TColor.PRIMARY_TEXT,
                                fontSize: FontSize.LARGE,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                          SizedBox(height: media.height * 0.02),
                          Column(
                            children: [
                                CustomTextFormField(
                                  onChanged: (_) => checkFormData(),
                                  controller: fields[0]["controller"],
                                  // initialValue: fields[0]["controller"].text ?? fields[0]["value"],
                                  decoration: CustomInputDecoration(
                                    // hintText: fields[0]["hintText"],
                                    label: Text(
                                      fields[0]["hintText"],
                                      style: TextStyle(
                                        color: TColor.DESCRIPTION,
                                        fontSize: FontSize.NORMAL,
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  ),
                                  keyboardType: TextInputType.text,
                                  showClearButton: nameClearButton,
                                  onClearChanged: () {
                                    fields[0]["controller"].clear();
                                    setState(() {
                                      nameClearButton = false;
                                      createProfileButtonState = TColor.BUTTON_DISABLED;
                                    });
                                  },
                                ),
                                SizedBox(height: media.height * 0.015,),

                              CustomTextFormField(
                                controller: fields[1]["controller"],
                                // initialValue: fields[1]["controller"].text ?? fields[1]["value"],
                                decoration: CustomInputDecoration(
                                  // hintText: fields[1]["hintText"],
                                  label: Text(
                                    fields[1]["hintText"],
                                    style: TextStyle(
                                      color: TColor.DESCRIPTION,
                                      fontSize: FontSize.NORMAL,
                                    ),
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                ),
                                keyboardType: TextInputType.text,
                                noneEditable: true,
                              ),
                              SizedBox(height: media.height * 0.015,),

                              for(int i = 2; i < 4; i++)...[
                                CustomMainButton(
                                  verticalPadding: 22,
                                  borderWidth: 2,
                                  borderWidthColor: TColor.BORDER_COLOR,
                                  background: Colors.transparent,
                                  horizontalPadding: 25,
                                  onPressed: () async {
                                    String result = "";
                                    if(i == 2) {
                                      result = await showChoiceList(context, ["Viet Nam"]);
                                    }
                                    else {
                                      result = await showChoiceList(context, provinces);
                                    }
                                    setState(() {
                                      fields[i]["value"] = result;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${fields[i]["value"] == "" ?  fields[i]["hintText"] : fields[i]["value"]}",
                                        style: TxtStyle.largeTextDesc,
                                      ),
                                      Transform.rotate(
                                        angle: -90 * 3.14 / 180,
                                        child: Icon(
                                          Icons.arrow_back_ios_rounded,
                                          color: TColor.DESCRIPTION,
                                          size: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                if(i == 2) SizedBox(height: media.height * 0.02,),
                              ],

                            ],
                          )
                        ],
                      ),
                      SizedBox(height: media.height * 0.02,),

                      // Health Information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Health Information",
                            style: TextStyle(
                                color: TColor.PRIMARY_TEXT,
                                fontSize: FontSize.LARGE,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                          SizedBox(height: media.height * 0.02,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for(var x in ["male", "female"])...[
                                Container(
                                  height: 60,
                                  width: media.width * 0.46,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: TColor.BORDER_COLOR,
                                          width: 2
                                      )
                                  ),
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: x,
                                        groupValue: gender,
                                        onChanged: (value) {
                                          setState(() {
                                            gender = value;
                                          });
                                        },
                                        fillColor: MaterialStateProperty.all<Color>(
                                          const Color(0xffcdcdcd),
                                        ),
                                      ),
                                      Text(
                                        x[0].toUpperCase() + x.substring(1),
                                        style: const TextStyle(
                                            color: Color(0xffcdcdcd),
                                            fontSize: FontSize.NORMAL
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            ],
                          ),
                          SizedBox(height: media.height * 0.015,),
                          CustomMainButton(
                            verticalPadding: 22,
                            borderWidth: 2,
                            borderWidthColor: TColor.BORDER_COLOR,
                            background: Colors.transparent,
                            horizontalPadding: 25,
                            onPressed: () async {
                              DateTime? result = await showDatePickerCustom(
                                  context,
                                  DateTime(1960, 1, 1),
                                  DateTime(2015, 1, 1)
                              );
                              setState(() {
                                fields[4]["value"] = formatDate(result!);
                                createProfileButtonState = (fields[4]["value"] != "") ? TColor.PRIMARY : TColor.BUTTON_DISABLED;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${fields[4]["value"] == "" ? fields[4]["hintText"] : fields[4]["value"]}",
                                  style: TxtStyle.largeTextDesc,
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: TColor.DESCRIPTION,
                                  // size: 15,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: media.height * 0.015,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: media.width * 0.46,
                                child: CustomTextFormField(
                                  controller: fields[5]["controller"],
                                  // initialValue: fields[5]["value"],
                                  decoration: CustomInputDecoration(
                                    // hintText: fields[5]["hintText"],
                                      label: Text(
                                        fields[5]["hintText"],
                                        style: TextStyle(
                                          color: TColor.DESCRIPTION,
                                          fontSize: FontSize.NORMAL,
                                        ),
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.auto
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(
                                width: media.width * 0.46,
                                child: CustomTextFormField(
                                  controller: fields[6]["controller"],
                                  // initialValue: fields[6]["value"],
                                  decoration: CustomInputDecoration(
                                    // hintText: fields[6]["hintText"],
                                      label: Text(
                                        fields[6]["hintText"],
                                        style: TextStyle(
                                          color: TColor.DESCRIPTION,
                                          fontSize: FontSize.NORMAL,
                                        ),
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.auto
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: media.height * 0.02,),

                      // Additional information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Additional Information",
                            style: TextStyle(
                                color: TColor.PRIMARY_TEXT,
                                fontSize: FontSize.LARGE,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                          SizedBox(height: media.height * 0.02,),
                          for(int i = 7; i < 9; i++)...[
                            CustomTextFormField(
                              controller: fields[i]["controller"],
                              // initialValue: fields[i]["value"],
                              decoration: CustomInputDecoration(
                                // hintText: fields[i]["hintText"],
                                  label: Text(
                                    fields[i]["hintText"],
                                    style: TextStyle(
                                      color: TColor.DESCRIPTION,
                                      fontSize: FontSize.NORMAL,
                                    ),
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.auto
                              ),
                              noneEditable: (i == 7) ? true : false,
                              keyboardType: (i == 7) ? TextInputType.text : TextInputType.number,
                            ),
                            SizedBox(height: media.height * 0.015,),
                          ],
                          for(int i = 9; i < 11; i++)...[
                            CustomMainButton(
                              verticalPadding: 22,
                              borderWidth: 2,
                              borderWidthColor: TColor.BORDER_COLOR,
                              background: Colors.transparent,
                              horizontalPadding: 25,
                              onPressed: () async {
                                String result = await showChoiceList(context, [
                                  "XS", "S", "M", "L", "XL", "XXL"
                                ]);
                                setState(() {
                                  fields[i]["value"] = result;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${fields[i]["value"] == "" ? fields[i]["hintText"] : fields[i]["value"]}",
                                    style: TxtStyle.largeTextDesc,
                                  ),
                                  Transform.rotate(
                                    angle: -90 * 3.14 / 180,
                                    child: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: TColor.DESCRIPTION,
                                      size: 15,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: media.height * 0.015,),
                          ]
                        ],
                      ),
                    ],
                  ),
                )
              // ]
              // else...[
              //   Loading()
              // ]
            ],
          ),
        ),
      ),
      bottomNavigationBar: Wrapper(
          child: Container(
            margin: EdgeInsets.fromLTRB(media.width * 0.025, 15, media.width * 0.025, media.width * 0.025),
            child: CustomMainButton(
              horizontalPadding: 0,
              background: createProfileButtonState,
              onPressed: (createProfileButtonState == TColor.BUTTON_DISABLED) ? null : createAccountInformation,
              child: Text(
                "Create profile",
                style: TextStyle(
                    color: TColor.PRIMARY_TEXT,
                    fontSize: FontSize.LARGE,
                    fontWeight: FontWeight.w800
                ),
              ),
            ),
          )
      ),
    );
  }
}


import 'package:debs_driver_app/ChangePassword/view/ChangePasswordScreen.dart';
import 'package:debs_driver_app/OrderHistory/view/OrderHistory.dart';
import 'package:debs_driver_app/Utils/color.dart';
import 'package:debs_driver_app/Utils/sqldata.dart';
import 'package:debs_driver_app/controller/ShiftListController.dart';
import 'package:debs_driver_app/home/homescreencontroller/HomeScreenController.dart';
import 'package:debs_driver_app/home/model/ProfileDetailsResponse.dart';
import 'package:debs_driver_app/issue/view/ReportISsue.dart';
import 'package:debs_driver_app/login/login_screen.dart';
import 'package:debs_driver_app/main.dart';
import 'package:debs_driver_app/home/model/ShiftResponse.dart';
import 'package:debs_driver_app/orders/OrdersListScreen.dart';
import 'package:debs_driver_app/privacypolicy/PrivacyPolicyScreen.dart';
import 'package:debs_driver_app/shiftSelection/view/AvailableShiftScreen.dart';
import 'package:debs_driver_app/shiftsummary/view/ShiftSummaryScreen.dart';
import 'package:debs_driver_app/wallet/WalletScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../checkin/Shift_Checkin_Screen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with TickerProviderStateMixin {
  String? username;
  String? token;

  bool isloading = false;
  TabController? controller;

  ProfileDetailsResponse profileDetailsResponse = ProfileDetailsResponse();
  final Homescreencontroller homescreencontroller = Homescreencontroller();

  @override
  void initState() {
    super.initState();
    loaddata();
    controller = TabController(length: 2, initialIndex: 0, vsync: this);
    callProfileApi();
  }

  Future<void> callProfileApi() async {
    try {
      setState(() {
        isloading = true;
      });

      final data = await homescreencontroller.getProfileDetails(context);
      if (data != null) {
        setState(() {
          isloading = false;
          profileDetailsResponse = data;
        });
      } else {
        setState(() {
          isloading = false;
        });
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      rethrow;
    }
  }

  Future<void> loaddata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
      token = prefs.getString('token');
      getShiftList();
    });

    await DBHelper.instance.saveUser(username ?? '', token ?? '');
    await DBHelper.instance.showuser();
    getShiftList();
  }

  int selectedIndex = 0; // Keeps track of selected drawer item

  // Drawer items data
  final List<Map<String, dynamic>> drawerItems = [
    {'icon': Icons.home, 'title': 'Home'},
    {'icon': Icons.beach_access, 'title': 'Leaves'},
    {'icon': Icons.access_time, 'title': 'Shifts'},
    {'icon': Icons.account_balance_wallet, 'title': 'Wallet'},
    {'icon': Icons.history, 'title': 'Order History'},
    {'icon': Icons.assignment, 'title': 'Shift Summary'},
    {'icon': Icons.report_problem, 'title': 'Report Issue'},
    {'icon': Icons.lock, 'title': 'Change Password'},
    {'icon': Icons.language, 'title': 'English/Arabic'},
    {'icon': Icons.logout, 'title': 'Logout'},
  ]; 
  @override
  Widget build(BuildContext context) {
    final profileData = profileDetailsResponse.data;
    if (isloading && profileDetailsResponse.data == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorTheme().colorPrimary,
        title: Text(
          "Allow Driver",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
            color: Colors.white,
          );
        }),
      ),
      // drawer: Drawer(
      //   child: SafeArea(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //       GestureDetector(onTap: () {

      //       },child: Text("title")),
      //       Icon(Icons.abc_outlined)
      //     ],),
      //   ),
      // ),

      drawer: Drawer(
        child: Column(
          children: [
            // Header
            UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: ColorTheme().colorPrimarydark,
              ),
              currentAccountPicture: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: ColorTheme().colorPrimary,
                    size: 40,
                  ),
                ),
              ),
              accountName: Text(
                profileData == null
                    ? "Loading..."
                    : "${profileData.firstName ?? ''} ${profileData.lastName ?? ''}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileData?.email ?? "",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profileData == null ? "" : "Driver ID: ${profileData.id}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),

            // Drawer Items
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: drawerItems.length,
                itemBuilder: (context, index) {
                  final item = drawerItems[index];
                  bool isSelected = selectedIndex == index;
                  return ListTile(
                    leading: Icon(item['icon'],
                        color: isSelected
                            ? Colors.white
                            : ColorTheme().colorPrimary),
                    title: Text(
                      item['title'],
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black),
                    ),
                    tileColor: isSelected ? ColorTheme().colorPrimary : null,
                    onTap: () async {
                      setState(() {
                        selectedIndex = index;
                      });
                      Navigator.pop(context); // Close the drawer
                      // TODO: Add navigation logic here based on index
                      print('Tapped: ${item['title']}');
                      switch (item['title']) {
                        case "Home":
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Orderhistory()));
                          break;

                        // case "Leaves":
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => Orderhistory()));
                        //   break;

                        case "Shifts":
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AvailableShiftScreen()));
                          break;

                        case "Wallet":
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WalletScreen()));
                          break;

                        case "Order History":
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Orderhistory()));
                          break;
                        case "Shift Summary":
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShiftSummaryScreen()));
                          break;
                        case "Report Issue":
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReportIssueScreen()));
                          break;
                        case "Change Password":
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Changepasswordscreen()));
                          break;
                        case "English/Arabic":
                          MyApp.showLanguageDialog(context, force: true);
                          break;
                        case "Logout":
                          logoutAlert(context);
                          break;

                        default:
                      }
                    },
                  );
                },
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("v1.0.0", style: TextStyle(color: Colors.black)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Privacypolicyscreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Privacy Policy",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: ColorTheme().colorPrimary,
              child: TabBar(
                dividerColor: ColorTheme().colorPrimary,
                controller: controller,
                tabs: [
                  Tab(
                    child: Container(child: Text("Orders")),
                  ),
                  Tab(
                    child: Text("Shifts"),
                  )
                ],
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.white60,
              ),
            ),
            Expanded(
              child: TabBarView(controller: controller, children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 0),
                      Expanded(child: OrdersListScreen())
                    ],
                  ),
                ),
                Container(
                  child: Column(children: [
                    SizedBox(height: 0),
                    Expanded(child: ShiftScheckinScreen()),
                  ]),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }

  Shiftlistcontroller shiftlistcontroller = Shiftlistcontroller();

  ShiftListResponse? response;

  void getShiftList() async {
    response = await shiftlistcontroller.getShiftList('2025-10-08');
  }

  logoutAlert(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Logout!"),
            content: Text("Are you sure ?"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No")),
              ElevatedButton(
                  onPressed: () {
                    callLogout();
                    Navigator.pop(context);
                  },
                  child: Text("Yes"))
            ],
          );
        });
  }

  Future<void> callLogout() async {
    var response = await shiftlistcontroller.callLogoutApi();
    if (response!.status!) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', "");
      await prefs.setString('password', "");
      await prefs.setString('logindata', "");
      await prefs.setString('token', "");
      await prefs.setInt('driverID', 0);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}

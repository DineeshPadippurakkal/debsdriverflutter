import 'package:debs_driver_app/Utils/color.dart';
import 'package:debs_driver_app/checkin/checkinPoints.dart';
import 'package:debs_driver_app/controller/ShiftListController.dart';
import 'package:debs_driver_app/home/model/ShiftResponse.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShiftScheckinScreen extends StatefulWidget {
  const ShiftScheckinScreen({super.key});

  @override
  State<ShiftScheckinScreen> createState() => _ShiftScheckinScreenState();
}

class _ShiftScheckinScreenState extends State<ShiftScheckinScreen> {
  ShiftListResponse? response;
  int? selected;
  int shiftID = 0;
  int slotID = 0;
  bool isVisbile = true;
  Shiftlistcontroller shiftlistcontroller = Shiftlistcontroller();

  @override
  void initState() {
    // TODO: implement initState
    final date = DateTime.now();
    selected = 0;
    getShiftList(DateFormat('yyyy-MM-dd').format(date));
    super.initState();
  }

  bool isloading = false;
  bool isCheckinApiCall = false;
  Future<void> getShiftList(String date) async {
    try {
      setState(() {
        isloading = true;
      });
      final data = await shiftlistcontroller.getShiftList(date);
      if (data != null) {
        setState(() {
          response = data;
          isloading = false;
          isVisbile = response!.data![0].slots![0].isCheckedIn!;

          // print("checkin status - $isVisbile");
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

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final List<DateTime> next7Days =
        List.generate(7, (index) => today.add(Duration(days: index)));
// FirebaseDatabase.getInstance()
//     .getReference("driver-status/26")
//     .addValueEventListener(object : ValueEventListener {
//         override fun onDataChange(snapshot: DataSnapshot) {
//             // handle data
//         }
//         override fun onCancelled(error: DatabaseError) {
//             // handle error
//         }
//     })

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 244, 244),
      // appBar: AppBar(automaticallyImplyLeading: false),
      body: RefreshIndicator(
        onRefresh: () async {
          final date = DateTime.now();
          getShiftList(DateFormat('yyyy-MM-dd').format(date));
        },
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: next7Days.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final shiftDay = next7Days[index];
                  var formatedShiftday = DateFormat('dd MMM').format(shiftDay);
                  if (index == 0) {
                    formatedShiftday = "today";
                  }

                  // selected == indx;
                  return GestureDetector(
                    onTap: () {
                      print("clicked $shiftDay");
                      getShiftList(DateFormat('yyyy-MM-dd').format(shiftDay));

                      setState(() {
                        selected = index;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 80,
                      decoration: BoxDecoration(
                          color: index == selected ? Colors.white : null,
                          border: Border.all(
                              color: index == selected
                                  ? ColorTheme().colorPrimary
                                  : Colors.black),
                          borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Center(
                          child: Text(
                        formatedShiftday.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: index == selected
                                ? ColorTheme().colorPrimary
                                : Colors.black),
                      )),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            isloading
                ? CircularProgressIndicator()
                : response!.data!.isEmpty
                    ? Expanded(
                        child: Center(
                            child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorTheme().colorPrimary),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "No shifts",
                                  style: TextStyle(fontSize: 25),
                                ))))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: response?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final shiftItemmData = response!.data![index];
                            return Card(
                              margin: EdgeInsets.all(10),
                              color: Colors.white,
                              elevation: 5,
                              child: ListTile(
                                  title: StreamBuilder(
                                    stream: FirebaseDatabase.instance
                                        .ref("driver-status/26")
                                        .onValue,
                                    builder: (context, snapshot) {
                                      // 🔄 Show inline loader while waiting for data
                                      if (snapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          !snapshot.hasData ||
                                          snapshot.data?.snapshot.value ==
                                              null) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              right: 150, top: 10),
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            color: Colors.green.shade100,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                          ),
                                          child: Row(
                                            children: const [
                                              SizedBox(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Loading...",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      // ✅ Data received
                                      var status = snapshot.data!.snapshot
                                              .child('status_name')
                                              .value
                                              ?.toString() ??
                                          "N/A";

                                      return Container(
                                        margin: const EdgeInsets.only(
                                            right: 150, top: 10),
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          color: Colors.green.shade100,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Text(
                                          status,
                                          style: const TextStyle(
                                              color: Colors.green),
                                        ),
                                      );
                                    },
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${shiftItemmData.day},${shiftItemmData.date}",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${shiftItemmData.slots!.first.startTime}-${shiftItemmData.slots!.first.endTime}",
                                        // "09:00 AM - 09:00 PM",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                          ),
                                          Text("${shiftItemmData.zone}"),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      !isVisbile
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: isCheckinApiCall
                                                      ? null
                                                      : () {
                                                          callcheckinAPI();
                                                        },
                                                  style: ElevatedButton.styleFrom(
                                                      disabledBackgroundColor:
                                                          ColorTheme()
                                                              .colorPrimary,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      backgroundColor:
                                                          ColorTheme()
                                                              .colorPrimary),
                                                  child: isCheckinApiCall
                                                      ? SizedBox(
                                                          height: 22,
                                                          width: 22,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.white,
                                                            backgroundColor:
                                                                ColorTheme()
                                                                    .colorPrimary,
                                                            strokeWidth: 2.5,
                                                          ),
                                                        )
                                                      : Text("CheckIN",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        backgroundColor:
                                                            ColorTheme()
                                                                .colorPrimary),
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        enableDrag: false,
                                                        isScrollControlled:
                                                            false,
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          16)),
                                                        ),
                                                        builder: (context) =>
                                                            const CheckinPointsBottomSheet(),
                                                      );
                                                    },
                                                    child: Text(
                                                      "CheckIN Ponits",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))
                                              ],
                                            )
                                          : SizedBox.shrink()
                                    ],
                                  )),
                            );
                          },
                        ),
                      )
          ],
        ),
      ),
    );
  }

  Future<void> callcheckinAPI() async {
    try {
      setState(() {
        isCheckinApiCall = true;
      });

      final data = await shiftlistcontroller.callCheckin(
          response!.data![0].slots![0].slot!, response!.data![0].shift!);
      print(data!.message);

      setState(() {
        isCheckinApiCall = false;
        isVisbile = data.status!;
      });
      if (data.status == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response?.message ?? "Checkin Success",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        print(response.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data.message ?? "Checkin failed",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {}
  }
}

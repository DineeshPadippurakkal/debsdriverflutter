import 'package:debs_driver_app/Utils/color.dart';
import 'package:debs_driver_app/wallet/CodOrderItem.dart';
import 'package:debs_driver_app/wallet/controller/WalletController.dart';
import 'package:debs_driver_app/wallet/model/CODOrdersResponse.dart';
import 'package:debs_driver_app/wallet/model/WalletDepositResponse';
import 'package:debs_driver_app/wallet/model/WalletResponse.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {

      
  WalletResponse? response;

  WalletDepositResponse? wallet_deposit_response;
  CODOrdersResponse? cod_response;

  bool isloading = false;
  late TabController _tabController;
  double totalBalance = 100.00;
  double usedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    fetchWalletResponse();
    fetchCODORders();
    fetchDeposits();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (usedAmount / totalBalance).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wallet",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: ColorTheme().colorPrimary,
      ),
      body: Column(
        children: [
          // ================= WALLET HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            color: ColorTheme().colorPrimary,
            child: Column(
              children: [
                const Text(
                  "My Wallet",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "₹ ${usedAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Text(
                        //   "${(progress * 100).toInt()}% used",
                        //   style: const TextStyle(
                        //     color: Colors.white70,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ================= TABS =================
          Container(
            color: ColorTheme().colorPrimary, // 🔥 TAB BACKGROUND COLOR
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: "COD ORDERS"),
                Tab(text: "DEPOSITED"),
              ],
            ),
          ),

          // ================= TAB CONTENT =================
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _codOrdersTab(),
                _depositedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

// ================= COD ORDERS TAB =================
  Widget _codOrdersTab() {
    if (isloading) {
      // show loading spinner
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

     if (cod_response == null || cod_response!.data!.isEmpty) {
      // no orders available
      return const Center(
        child: Text("No COD orders available"),
      );
    }

    return ListView.builder(
      itemCount: cod_response!.data!.length,
      itemBuilder: (context, index) {
        final order = cod_response!.data![index];
        return Column(
          children: [
            CodOrderItem(
              logoUrl: order.logo!,
              orderFrom: order.orderFrom!,
              orderNumber: order.order.toString(),
              date: order.date!,
              amount: "₹ ${order.amount!.toStringAsFixed(3) } KWD",
            ),
            Container(color: Colors.white,
              padding: const EdgeInsets.only(left: 120),
              child: Divider(
                thickness: 1,
                color: ColorTheme().lightgrey,
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= DEPOSITED TAB =================
  Widget _depositedTab() {
    if (wallet_deposit_response == null ||
      wallet_deposit_response!.data == null) {
    return const Center(child: Text("No deposits found"));
  }

  return ListView.builder(
    itemCount: wallet_deposit_response!.data!.length,
    itemBuilder: (context, index) {
      final item = wallet_deposit_response!.data![index];

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.day ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.date ?? "",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  "${item.amount?.toStringAsFixed(2)} KWD",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.only(left: 25),
            color: Colors.black12,
          ),
        ],
      );
    },
  );
  }

  Future<void> fetchWalletResponse() async {
    try {
      setState(() {
        isloading = true;
      });

      final data = await Walletcontroller().fetchWallet(context);
      if (data != null) {
        setState(() {
          isloading = false;
          response = data;
          usedAmount = response?.data?.balance ?? 0.0;
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

  Future<void> fetchCODORders() async {
    try {
      setState(() {
        isloading = true;
      });
      final data = await Walletcontroller().fetchCOD_Orders(context);
      if (data != null) {
        setState(() {
          isloading = false;
          cod_response = data;
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



  Future<void> fetchDeposits() async {
    try {
      setState(() {
        isloading = true;
      });
      final data = await Walletcontroller().fetchDeposits(context);
      if (data != null) {
        setState(() {
          wallet_deposit_response = data;
           isloading = false;
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
}

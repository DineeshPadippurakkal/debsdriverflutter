import 'dart:io';

import 'package:dartz/dartz.dart' hide State;
import 'package:debs_driver_app/Utils/color.dart';
import 'package:debs_driver_app/core/domain/failure/exception.dart';
import 'package:debs_driver_app/core/infrastructure/injection/injection_setup.dart';
import 'package:debs_driver_app/core/infrastructure/services/url_launcher_service.dart';
import 'package:debs_driver_app/core/infrastructure/services/whatsapp_service.dart';
import 'package:debs_driver_app/core/presentation/overlay/overlay_manager.dart';
import 'package:debs_driver_app/core/presentation/widgets/state_widgets.dart';
import 'package:debs_driver_app/features/order/application/controllers/order_details_bloc/order_details_bloc.dart';
import 'package:debs_driver_app/features/order/application/order_details_args.dart';
import 'package:debs_driver_app/features/order/presentation/widgets/DeliveryTimerWidget.dart';
import 'package:debs_driver_app/features/order/presentation/widgets/HolderOrder.dart';
import 'package:debs_driver_app/features/order/presentation/widgets/PickupTimer.dart';
import 'package:debs_driver_app/features/order/application/controllers/OrderDetailController.dart';
import 'package:debs_driver_app/temp/CommonResponse.dart';
import 'package:debs_driver_app/temp/DropOrderRequest.dart';
import 'package:debs_driver_app/features/order/domain/entities/order_details.dart';
import 'package:debs_driver_app/features/order/presentation/widgets/interactive_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key, required this.arguments});
  final OrderDetailsArguments arguments;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => getIt<OrderDetailsBloc>(
              param1: arguments,
            )..add(OrderDetailsLoaded()),
        child: _OrderDetails(
          arguments: arguments,
        ));
  }
}

class _OrderDetails extends StatefulWidget {
  final OrderDetailsArguments arguments;
  int? get taskId => arguments.taskId;
  int? get orderID => arguments.orderID;

  String? pickup_address;
  var pickupdetails;

  _OrderDetails({
    super.key,
    required this.arguments,
  });

  @override
  State<_OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<_OrderDetails> implements OrderDetailsViewContract {
  bool pickup_visible = false;
  bool deliveryVisibile = false;
  late final bloc = context.read<OrderDetailsBloc>();
  int parseExpectedDeliveryTs(String ts) {
    return DateTime.parse(ts).millisecondsSinceEpoch;
  }

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );
  XFile? deliveryImage;

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  bool isloading = false;
  @override
  void initState() {
    super.initState();
    bloc.attachViewContract(this);
  }

  Future<void> pickDeliveryImage(VoidCallback refreshDialog) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        deliveryImage = image;
      });

      refreshDialog();
    }
  }

  void fetchOrderDetails() async {
    setState(() {
      isloading = true;
    });
    //
    // if (response != null) {
    //   setState(() {
    //     orderdetailResponse = response;
    //     isloading = false;
    //     if (orderdetailResponse.data!.pickupDetails != null) {
    //       setPickupData(orderdetailResponse);
    //     }
    //
    //     if (orderdetailResponse.data!.dropOffDetails != null) {
    //       setDropOffData(orderdetailResponse.data!.dropOffDetails);
    //       deliveryVisibile = true;
    //       pickup_visible = false;
    //     } else {
    //       deliveryVisibile = false;
    //     }
    //   });
    // } else {
    //   setState(() {
    //     isloading = false;
    //   });
    // }
  }

  Widget signatureView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // 🔑 IMPORTANT
      children: [
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Signature(
            height: 190,
            controller: _signatureController,
            backgroundColor: Colors.transparent,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _signatureController.clear,
            child: const Text("Clear"),
          ),
        ),
      ],
    );
  }

  Widget deliveryProofView({required VoidCallback refreshDialog}) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 🔑 IMPORTANT
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => pickDeliveryImage(refreshDialog),
          child: Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: deliveryImage == null
                ? const Center(
                    child: Icon(Icons.camera_alt, size: 40),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(deliveryImage!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        builder: (context, state) {
          return LoadStateHandler(
            customState: state.orderDetails,
            onData: (data) {
              return PremiumOrderDetails(
                order: data,
              );
            },
          );
        },
      ),
    );
  }

  @override
  void handleDriverReached(Either<AppException, Unit> result) {
    result.fold(
      (failure) {
        if (failure is NotNearToSupplierException) {
          OverlayManager.instance.showSnackBar('You are not near the Supplier location');
        } else {
          OverlayManager.instance.showSnackBar('Failed to update status. Please try again.');
        }
      },
      (_) {
        OverlayManager.instance.showSnackBar('Status updated to Reached');
      },
    );
  }

  @override
  void handleDropOrder(Either<AppException, Unit> result) {
    result.fold((failure) {
      OverlayManager.instance.showSnackBar('Failed to drop order. Please try again.');
    }, (_) {
      OverlayManager.instance.showSnackBar('Order dropped successfully');
    });
  }

  @override
  void handleDropOrderWithAmount(Either<AppException, Unit> result) {
    result.fold(
      (l) {
        OverlayManager.instance.showSnackBar('Failed to drop order with amount. Please try again.');
      },
      (r) {
        OverlayManager.instance.showSnackBar('Order dropped successfully with amount');
      },
    );
  }

  @override
  void handleDropOrderWithProof(Either<AppException, Unit> result) {
    result.fold(
      (l) {
        OverlayManager.instance.showSnackBar('Failed to drop order with proof. Please try again.');
      },
      (r) {
        OverlayManager.instance.showSnackBar('Order dropped successfully with proof');
      },
    );
  }

  @override
  void handlePickedUp(Either<AppException, Unit> result) {
    result.fold(
      (failure) {
        if (failure is NotNearToSupplierException) {
          OverlayManager.instance.showSnackBar('You are not near the Supplier location');
        } else {
          OverlayManager.instance.showSnackBar('Failed to update status. Please try again.');
        }
      },
      (_) {
        OverlayManager.instance.showSnackBar('Status updated to Picked Up');
      },
    );
  }
}

class PremiumOrderDetails extends StatelessWidget {
  final OrderData order;

  const PremiumOrderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainPickupCard(),
                    const SizedBox(height: 20),
                    _buildSecondaryInfoRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
        // button
        _buildArriveButton(context)
      ],
    );
  }

  Widget _buildArriveButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).padding.bottom + 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // Glass effect
          border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
        ),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF2D63FF), Color(0xFF003CC5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2D63FF).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              context.read<OrderDetailsBloc>().add(DriverReached());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.gps_fixed, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text(
                  "I HAVE ARRIVED",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryInfoRow() {
    return Row(
      children: [
        Expanded(
            child: _miniCard("Status", order.orderDetails?.status ?? "", Icons.assignment_turned_in,
                Colors.orange)),
        const SizedBox(width: 16),
        Expanded(
            child: _miniCard(
                "Payment",
                "${order.orderDetails?.paymentAmount ?? 0.0} ${order.orderDetails?.paymentType ?? ""}",
                Icons.payments_outlined,
                Colors.blueAccent)),
      ],
    );
  }

  Widget _miniCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildMainPickupCard() {
    final pickup = order.pickupDetails;
    final phone = pickup?.address.mobile;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
              color: Colors.blueAccent.withOpacity(0.05),
              blurRadius: 40,
              offset: const Offset(0, 20))
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.green[50], borderRadius: BorderRadius.circular(12)),
                      child: Text(pickup?.area?.toUpperCase() ?? "",
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                    const Icon(Icons.more_horiz, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 20),
                Text(pickup?.name ?? "",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text("${pickup?.block ?? ""}, ${pickup?.street ?? ""}",
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: Colors.blueGrey[400], fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Divider(color: Color(0xFFF1F4F8), thickness: 2),
                ),
                const Text("ADDRESS DETAILS",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                        letterSpacing: 1)),
                const SizedBox(height: 12),
                Text(pickup?.building ?? "",
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600, color: Colors.blueGrey[800])),
              ],
            ),
          ),
          // Action row at bottom of card
          if (phone != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Color(0xFFF9FBFF),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
              child: Row(
                children: [
                  _iconAction(
                    Icons.phone,
                    Colors.green,
                    onTap: () {
                      getIt<UrlLauncherService>()
                          .launch(Uri(scheme: 'tel', path: phone.toString()));
                    },
                  ),
                  const SizedBox(width: 12),
                  _iconAction(
                    Icons.chat_bubble,
                    Colors.blueAccent,
                    onTap: () {
                      getIt<WhatsappService>().openWhatsapp(phone);
                    },
                  ),
                  const Spacer(),
                  const Text("Contact Merchant",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _iconAction(IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22.5),
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[200]!)),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildAppBar() {
    final orderId = order.orderDetails?.referenceId ?? order.orderDetails?.id?.toString() ?? "";
    return SliverAppBar(
      expandedHeight: 100,
      backgroundColor: const Color(0xFFF8FAFD),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: const BackButton(color: Colors.black),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("ORDER #$orderId",
                style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(order.orderDetails?.status ?? "",
                style: const TextStyle(
                    color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

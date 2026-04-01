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
import 'package:debs_driver_app/features/order/presentation/overlay/delivery_proof_dialog.dart';
import 'package:debs_driver_app/features/order/presentation/pages/signature_proof_page.dart';
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

  XFile? deliveryImage;

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
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).padding.bottom + 20),
              child: buildBottomButton(context),
            ))
      ],
    );
  }

  Widget buildBottomButton(BuildContext context) {
    final status = order.orderDetails!.status!;
    print('Current Order Status: $status'); // Debug print
    switch (status) {
      case 'Driver Reached':
        return _buildPickupButton(context);
      case 'Assigned':
        return _buildArriveButton(context);
      case 'Picked Up':
        return _buildExceptionActionRow(context);

      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildExceptionActionRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(child: _buildDropOrderButton(context)),
          const SizedBox(width: 12),
          Expanded(child: _buildHoldButton(context)),
        ],
      ),
    );
  }

  // 2. The "Drop Order" Button (Danger Action)
  Widget _buildDropOrderButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextButton.icon(
        onPressed: () {
          final bloc = context.read<OrderDetailsBloc>();
          showDialog(
            context: context,
            builder: (context) {
              return DeliveryProofPickerDialog(
                  onConfirm: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignatureProofPage(
                                onConfirmed: (file) {
                                  bloc.add(SignatureProofPicked(file));
                                },
                              )), // Ensure this name matches exactly
                    );
                  },
                  onChanged: (image) {
                    bloc.add(DeliveryProofPicked(image));
                  },
                  image: bloc.state.deliveryProof.toNullable());
            },
          );
          // context.read<OrderDetailsBloc>().add(OrderDropped());
        },
        style: TextButton.styleFrom(
          // Using a soft green "Success" theme
          backgroundColor: Colors.green.withOpacity(0.08),
          foregroundColor: Colors.green[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.green.withOpacity(0.2)),
          ),
        ),
        // "Done All" or "Check" icon implies completion
        icon: const Icon(Icons.done_all_rounded, size: 20),
        label: const Text(
          "DROP ORDER",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5),
        ),
      ),
    );
  }

  // 3. The "Hold" Button (Neutral/Warning Action)
  Widget _buildHoldButton(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextButton.icon(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Holderorder(
              orderID: order.orderDetails!.id,
            ),
          ));
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.amber.withOpacity(0.1),
          foregroundColor: Colors.orange[800],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.pause_circle_outline_rounded, size: 18),
        label: const Text(
          "HOLD",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildPickupButton(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF2D63FF), Color(0xFF003CC5)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          context.read<OrderDetailsBloc>().add(OrderPickedUp());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              "PICK UP",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArriveButton(BuildContext context) {
    return Container(
      width: double.infinity,
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
                    Colors.blue,
                    onTap: () {
                      getIt<UrlLauncherService>()
                          .launch(Uri(scheme: 'tel', path: phone.toString()));
                    },
                  ),
                  const SizedBox(width: 12),
                  _iconAction(
                    FontAwesomeIcons.whatsapp.data,
                    Colors.green,
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

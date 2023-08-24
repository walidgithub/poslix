// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bounceable/flutter_bounceable.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:oktoast/oktoast.dart';
// import 'package:flutter/material.dart' hide Image;
// import 'package:poslix_app/pos/domain/entities/order_model.dart';
//
// import '../../../shared/constant/padding_margin_values_manager.dart';
// import '../../../shared/constant/strings_manager.dart';
// import '../../../shared/style/colors_manager.dart';
// import '../../router/arguments.dart';
//
// class ThermalPrint extends StatefulWidget {
//   ThermalPrint({Key? key, required this.arguments}) : super(key: key);
//   GoToThermal arguments;
//
//   @override
//   _ThermalPrintState createState() => _ThermalPrintState();
// }
//
// class _ThermalPrintState extends State<ThermalPrint> {
//   PrinterBluetoothManager printerManager = PrinterBluetoothManager();
//   List<PrinterBluetooth> _devices = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     print('printing');
//
//     printerManager.scanResults.listen((devices) async {
//       // print('UI: Devices found ${devices.length}');
//       setState(() {
//         _devices = devices;
//       });
//     });
//   }
//
//   void _startScanDevices() {
//     setState(() {
//       _devices = [];
//     });
//     printerManager.startScan(const Duration(seconds: 4));
//   }
//
//   void _stopScanDevices() {
//     printerManager.stopScan();
//   }
//
//   Future<List<int>> demoReceipt(
//       PaperSize paper, CapabilityProfile profile) async {
//     final Generator ticket = Generator(paper, profile);
//     List<int> bytes = [];
//
//     // Print image
//     // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
//     // final Uint8List imageBytes = data.buffer.asUint8List();
//     // final Image? image = decodeImage(imageBytes);
//     // bytes += ticket.image(image!);
//
//     bytes += ticket.text('POSLIX',
//         styles: const PosStyles(
//           align: PosAlign.center,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ),
//         linesAfter: 1);
//
//     bytes += ticket.text('Customer: ${listOfOrders[0].customer.toString()}',
//         styles: const PosStyles(align: PosAlign.center));
//     bytes += ticket.text('Tel: ${listOfOrders[0].customerTel.toString()}',
//         styles: const PosStyles(align: PosAlign.center));
//
//     bytes += ticket.hr();
//     bytes += ticket.row([
//       PosColumn(text: 'Qty', width: 1),
//       PosColumn(text: 'Item', width: 7),
//       PosColumn(
//           text: 'Price', width: 2, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
//     ]);
//
//     List.generate(
//         listOfOrders.length, (index) {
//       bytes += ticket.row([
//         PosColumn(text: listOfOrders[index].itemQuantity.toString(), width: 1),
//         PosColumn(text: listOfOrders[index].itemName.toString(), width: 7),
//         PosColumn(
//             text: listOfOrders[index].itemPrice.toString(), width: 2, styles: const PosStyles(align: PosAlign.right)),
//         PosColumn(
//             text: listOfOrders[index].itemAmount.toString(), width: 2, styles: const PosStyles(align: PosAlign.right)),
//       ]);
//     });
//
//     bytes += ticket.hr();
//
//     bytes += ticket.row([
//       PosColumn(
//           text: 'TOTAL',
//           width: 6,
//           styles: const PosStyles(
//             height: PosTextSize.size2,
//             width: PosTextSize.size2,
//           )),
//       PosColumn(
//           text: widget.arguments.total.toString(),
//           width: 6,
//           styles: const PosStyles(
//             align: PosAlign.right,
//             height: PosTextSize.size2,
//             width: PosTextSize.size2,
//           )),
//     ]);
//
//     bytes += ticket.hr(ch: '=', linesAfter: 1);
//
//     bytes += ticket.row([
//       PosColumn(
//           text: 'Discount',
//           width: 7,
//           styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
//       PosColumn(
//           text: listOfOrders[0].orderDiscount.toString(),
//           width: 5,
//           styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
//     ]);
//
//     bytes += ticket.feed(2);
//     bytes += ticket.text('Thank you!',
//         styles: const PosStyles(align: PosAlign.center, bold: true));
//
//     final now = DateTime.now();
//     final formatter = DateFormat('MM/dd/yyyy H:m');
//     final String timestamp = formatter.format(now);
//     bytes += ticket.text(timestamp,
//         styles: const PosStyles(align: PosAlign.center), linesAfter: 2);
//
//     // Print QR Code from image
//     // try {
//     //   const String qrData = 'example.com';
//     //   const double qrSize = 200;
//     //   final uiImg = await QrPainter(
//     //     data: qrData,
//     //     version: QrVersions.auto,
//     //     gapless: false,
//     //   ).toImageData(qrSize);
//     //   final dir = await getTemporaryDirectory();
//     //   final pathName = '${dir.path}/qr_tmp.png';
//     //   final qrFile = File(pathName);
//     //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
//     //   final img = decodeImage(imgFile.readAsBytesSync());
//
//     //   bytes += ticket.image(img);
//     // } catch (e) {
//     //   print(e);
//     // }
//
//     // Print QR Code using native function
//     // bytes += ticket.qrcode('example.com');
//
//     ticket.feed(2);
//     ticket.cut();
//     return bytes;
//   }
//
//   Future<List<int>> testTicket(
//       PaperSize paper, CapabilityProfile profile) async {
//     final Generator generator = Generator(paper, profile);
//     List<int> bytes = [];
//
//     bytes += generator.text(
//         'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
//     // bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
//     //     styles: PosStyles(codeTable: 'ddd'));
//     // bytes += generator.text('Special 2: blåbærgrød',
//     //     styles: PosStyles(codeTable: 'sadasd'));
//
//     bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
//     bytes += generator.text('Reverse text', styles: const PosStyles(reverse: true));
//     bytes += generator.text('Underlined text',
//         styles: const PosStyles(underline: true), linesAfter: 1);
//     bytes +=
//         generator.text('Align left', styles: const PosStyles(align: PosAlign.left));
//     bytes += generator.text('Align center',
//         styles: const PosStyles(align: PosAlign.center));
//     bytes += generator.text('Align right',
//         styles: const PosStyles(align: PosAlign.right), linesAfter: 1);
//
//     bytes += generator.row([
//       PosColumn(
//         text: 'col3',
//         width: 3,
//         styles: const PosStyles(align: PosAlign.center, underline: true),
//       ),
//       PosColumn(
//         text: 'col6',
//         width: 6,
//         styles: const PosStyles(align: PosAlign.center, underline: true),
//       ),
//       PosColumn(
//         text: 'col3',
//         width: 3,
//         styles: const PosStyles(align: PosAlign.center, underline: true),
//       ),
//     ]);
//
//     bytes += generator.text('Text size 200%',
//         styles: const PosStyles(
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ));
//
//     // Print image
//     final ByteData data = await rootBundle.load('assets/logo.png');
//     final Uint8List buf = data.buffer.asUint8List();
//     // final Image image = decodeImage(buf)!;
//     // bytes += generator.image(image);
//     // Print image using alternative commands
//     // bytes += generator.imageRaster(image);
//     // bytes += generator.imageRaster(image, imageFn: PosImageFn.graphics);
//
//     // Print barcode
//     final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
//     bytes += generator.barcode(Barcode.upcA(barData));
//
//     // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
//     bytes += generator.text(
//       'hello ! 中文字 # world @ éphémère &',
//       styles: const PosStyles(codeTable: 'fffff'),
//       containsChinese: true,
//     );
//
//     bytes += generator.feed(2);
//
//     bytes += generator.cut();
//     return bytes;
//   }
//
//   void _testPrint(PrinterBluetooth printer) async {
//     printerManager.selectPrinter(printer);
//
//     // TODO Don't forget to choose printer's paper
//     const PaperSize paper = PaperSize.mm80;
//     final profile = await CapabilityProfile.load();
//
//     // TEST PRINT
//     // final PosPrintResult res =
//     // await printerManager.printTicket(await testTicket(paper));
//
//     // DEMO RECEIPT
//     final PosPrintResult res =
//         await printerManager.printTicket((await demoReceipt(paper, profile)));
//
//     showToast(res.msg);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height / 2,
//         width: MediaQuery.of(context).size.width / 2,
//         child: ListView.builder(
//             itemCount: _devices.length,
//             itemBuilder: (BuildContext context, int index) {
//               return InkWell(
//                 onTap: () async {
//                   _testPrint(_devices[index]);
//                 },
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       height: 60,
//                       padding: const EdgeInsets.only(left: 10),
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         children: <Widget>[
//                           const Icon(Icons.print),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Text(_devices[index].name ?? ''),
//                                 Text(_devices[index].address!),
//                                 Text(
//                                   'Click to print a test receipt',
//                                   style: TextStyle(color: Colors.grey[700]),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     const Divider(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Bounceable(
//                           onTap: () {
//                             listOfOrders = [];
//                             Navigator.of(context).pop();
//                           },
//                           child: Container(
//                             height: 30.h,
//                             width: 50.w,
//                             decoration: BoxDecoration(
//                                 color: ColorManager.white,
//                                 border: Border.all(
//                                     color: ColorManager.primary,
//                                     width: 0.6.w),
//                                 borderRadius:
//                                 BorderRadius.circular(10)),
//                             child: Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Center(
//                                     child: Text(
//                                       AppStrings.close.tr(),
//                                       style: TextStyle(
//                                           color: ColorManager.primary,
//                                           fontSize: AppSize.s14.sp),
//                                     )),
//                                 Icon(
//                                   Icons.close,
//                                   size: 20,
//                                   color: ColorManager.primary,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             }),
//       ),
//       floatingActionButton: StreamBuilder<bool>(
//         stream: printerManager.isScanningStream,
//         initialData: false,
//         builder: (c, snapshot) {
//           if (snapshot.data!) {
//             return FloatingActionButton(
//               onPressed: _stopScanDevices,
//               backgroundColor: Colors.red,
//               child: const Icon(Icons.stop),
//             );
//           } else {
//             return FloatingActionButton(
//               onPressed: _startScanDevices,
//               child: const Icon(Icons.search),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

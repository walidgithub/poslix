import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:poslix_app/pos/domain/entities/order_model.dart';
import 'package:poslix_app/pos/shared/constant/constant_values_manager.dart';
import 'package:poslix_app/pos/shared/constant/strings_manager.dart';
import 'package:poslix_app/pos/shared/style/colors_manager.dart';

buildPrintableData(image, DateTime today, String businessName, String businessImage, String businessTell, int orderId, double taxAmount, double discountAmount, double total, double totalPaying, double due) => pw.Padding(
      padding: const pw.EdgeInsets.all(10.00),
      child: pw.Column(children: [
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Image(
                    image,
                    width: 100,
                    height: 100,
                  ),
                  pw.SizedBox(height: AppConstants.heightBetweenElements),
                  pw.Text(AppStrings.billedFrom.tr(), style: const pw.TextStyle(color: PdfColor.fromInt(0xff868585))),
                  pw.Text('Global Tech Projects'),
                  pw.Text('info@poslix.com'),
                  pw.Text('+986 2428 8077'),
                  pw.Text('Office 21-22, Building 532, Mazoon St. Muscat, Oman'),
                  pw.Text('VAT Number: OM1100270001'),
                ]
            ),
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(AppStrings.invoice.tr(), style: pw.TextStyle(fontSize: 20,fontWeight: pw.FontWeight.bold)),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children:[
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children:[
                            pw.Text(AppStrings.invoiceNumber.tr(), style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold)),
                            pw.Text(orderId.toString()),
                          ]
                      ),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children:[
                            pw.Text(AppStrings.invoiceDate.tr(), style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold)),
                            pw.Text(today.toString().substring(1, 10)),
                          ]
                      ),
                    ]
                  ),
                  pw.SizedBox(height: AppConstants.heightBetweenElements),
                  pw.Text(AppStrings.billedTo.tr(), style: const pw.TextStyle(color: PdfColor.fromInt(0xff868585))),
                  pw.Text(listOfOrders[0].customer!),
                  pw.Text(listOfOrders[0].customerTel!),
                  pw.Text(businessName),
                ]
            ),
          ]
        ),
        pw.SizedBox(height: 10.00),
        pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.SizedBox(width: 5.5),
                pw.Text(
                  "Invoice",
                  style: pw.TextStyle(
                      fontSize: 23.00, fontWeight: pw.FontWeight.bold),
                )
              ],
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 36.00,
              child: pw.Center(
                child: pw.Text(
                  "Approvals",
                  style: pw.TextStyle(
                      color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      fontSize: 20.00,
                      fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            for (var i = 0; i < 3; i++)
              pw.Container(
                color: i % 2 != 0
                    ? const PdfColor(0.9, 0.9, 0.9, 0.6)
                    : const PdfColor(1, 1, 1, 0.1),
                width: double.infinity,
                height: 36.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      i == 2
                          ? pw.Text(
                              "Tax",
                              style: pw.TextStyle(
                                  fontSize: 18.00,
                                  fontWeight: pw.FontWeight.bold),
                            )
                          : pw.Text(
                              "Item ${i + 1}",
                              style: pw.TextStyle(
                                  fontSize: 18.00,
                                  fontWeight: pw.FontWeight.bold),
                            ),
                      i == 2
                          ? pw.Text(
                              "\$ 2.50",
                              style: pw.TextStyle(
                                  fontSize: 18.00,
                                  fontWeight: pw.FontWeight.normal),
                            )
                          : pw.Text(
                              "\$ ${(i + 1) * 7}.00",
                              style: pw.TextStyle(
                                  fontSize: 18.00,
                                  fontWeight: pw.FontWeight.normal),
                            ),
                    ],
                  ),
                ),
              ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 36.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "\$ 23.50",
                      style: pw.TextStyle(
                        fontSize: 22.00,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 15.00),
            pw.Align(
              alignment: pw.Alignment.bottomLeft,
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children:[
                    pw.Text(
                      AppStrings.termsAndConditions.tr(),
                      style: pw.TextStyle(
                          color: const PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 15.00,fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 5.00),
                    pw.Text(
                      AppStrings.thankYouForYourBusiness.tr(),
                      style: const pw.TextStyle(
                          color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 15.00),
                    ),
                  ]
              )
            ),
            pw.SizedBox(height: 15.00),
          ],
        )
      ]),
    );

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:poslix_app/pos/domain/entities/order_model.dart';
import 'package:poslix_app/pos/shared/constant/constant_values_manager.dart';
import 'package:poslix_app/pos/shared/constant/padding_margin_values_manager.dart';
import 'package:poslix_app/pos/shared/constant/strings_manager.dart';

buildPrintableData(
        image,
        String businessAddress,
        String businessEmail,
        String businessVat,
        String customerNumber,
        String currencyCode,
        DateTime today,
        String businessName,
        String businessImage,
        String businessTell,
        int orderId,
        double taxAmount,
        double discountAmount,
        double total,
        double totalPaying,
        double due) =>
    pw.Padding(
      padding: const pw.EdgeInsets.all(AppPadding.p10),
      child: pw.Column(children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Image(
              image,
              width: 100,
              height: 100,
            ),
            pw.SizedBox(height: AppConstants.heightBetweenElements),
            pw.Text(AppStrings.billedFrom.tr(),
                style: const pw.TextStyle(color: PdfColor.fromInt(0xff868585))),
            pw.Text(businessName),
            pw.Text(businessEmail),
            pw.Text(customerNumber),
            pw.Text(businessAddress),
            pw.Text('VAT Number: $businessVat'),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text(AppStrings.invoice.tr(),
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: AppConstants.heightBetweenElements),
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Table(
                      border: pw.TableBorder.all(width: 0.01),
                      defaultVerticalAlignment:
                          pw.TableCellVerticalAlignment.middle,
                      children: [
                        pw.TableRow(children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(AppPadding.p5),
                            child: pw.Text(
                              AppStrings.invoiceNumber.tr(),
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                              textScaleFactor: 1,
                              textAlign: pw.TextAlign.left,
                            ),
                          ),
                          pw.Container(
                            width: 65,
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.all(AppPadding.p5),
                              child: pw.Text(
                                orderId.toString(),
                                style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                textScaleFactor: 1,
                                textAlign: pw.TextAlign.left,
                              ),
                            )
                          ),
                        ]),
                      ]),
                  pw.Table(
                      border: pw.TableBorder.all(width: 0.01),
                      defaultVerticalAlignment:
                          pw.TableCellVerticalAlignment.middle,
                      children: [
                        pw.TableRow(children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(AppPadding.p5),
                            child: pw.Text(
                              ' ${AppStrings.invoiceDate.tr()}     ',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                              textScaleFactor: 1,
                              textAlign: pw.TextAlign.left,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(AppPadding.p5),
                            child: pw.Text(
                              today.toString().substring(1, 10),
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                              textScaleFactor: 1,
                              textAlign: pw.TextAlign.left,
                            ),
                          ),
                        ]),
                      ]),
                ]),
            pw.SizedBox(height: AppConstants.heightBetweenElements),
            pw.Text(AppStrings.billedTo.tr(),
                style: const pw.TextStyle(color: PdfColor.fromInt(0xff868585))),
            pw.Text(listOfOrders[0].customer!),
            pw.Text(listOfOrders[0].customerTel!),
            pw.Text(businessName),
          ]),
        ]),
        pw.SizedBox(height: AppConstants.smallDistance),
        pw.Column(
          children: [
            pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(1),
                  4: const pw.FlexColumnWidth(2),
                },
                border: pw.TableBorder.all(width: 0.01),
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(AppPadding.p5),
                      child: pw.Text(
                        AppStrings.description.tr(),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textScaleFactor: 1,
                        textAlign: pw.TextAlign.left,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(right: AppPadding.p5),
                      child: pw.Text(
                        AppStrings.quantity.tr(),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textScaleFactor: 1,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(right: AppPadding.p5),
                      child: pw.Text(
                        AppStrings.unitPrice.tr(),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textScaleFactor: 1,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(right: AppPadding.p5),
                      child: pw.Text(
                        AppStrings.taxBill.tr(),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textScaleFactor: 1,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(right: AppPadding.p5),
                      child: pw.Text(
                        AppStrings.amount.tr(),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textScaleFactor: 1,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ]),
                  for (var i = 0; i < listOfOrders.length; i++)
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(AppPadding.p5),
                        child: pw.Text(
                          listOfOrders[i].itemName.toString(),
                          textScaleFactor: 1,
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(right: AppPadding.p5),
                        child: pw.Text(
                          listOfOrders[i].itemQuantity.toString(),
                          textScaleFactor: 1,
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(right: AppPadding.p5),
                        child: pw.Text(
                          listOfOrders[i].itemPrice.toString(),
                          textScaleFactor: 1,
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                      pw.Text(
                        '',
                        textScaleFactor: 1,
                        textAlign: pw.TextAlign.right,
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(right: AppPadding.p5),
                        child: pw.Text(
                          listOfOrders[i].itemAmount.toString(),
                          textScaleFactor: 1,
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ]),
                ]),
            pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(8),
                  1: const pw.FlexColumnWidth(2),
                },
                border: pw.TableBorder.all(width: 0.01),
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(AppPadding.p5),
                      child: pw.Text(
                        taxAmount.toString(),
                        textScaleFactor: 1,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Text(
                      '',
                      textScaleFactor: 1,
                      textAlign: pw.TextAlign.center,
                    ),
                  ]),
                ]),
            pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(8),
                  1: const pw.FlexColumnWidth(2),
                },
                border: pw.TableBorder.all(width: 0.01),
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(AppPadding.p5),
                      child: pw.Text(
                        AppStrings.subTotal.tr(),
                        textScaleFactor: 1,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(right: AppPadding.p5),
                      child: pw.Text(
                        total.toString(),
                        textScaleFactor: 1,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ]),
                ]),
            pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(8),
                  1: const pw.FlexColumnWidth(2),
                },
                border: pw.TableBorder.all(width: 0.01),
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(AppPadding.p5),
                      child: pw.Text(
                        AppStrings.total.tr(),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textScaleFactor: 1,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(right: AppPadding.p5),
                      child: pw.Text(
                        total.toString(),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textScaleFactor: 1,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ]),
                ]),
            pw.SizedBox(height: AppConstants.bigHeightBetweenElements),
            pw.Align(
                alignment: pw.Alignment.bottomLeft,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        AppStrings.termsAndConditions.tr(),
                        style: pw.TextStyle(
                            color: const PdfColor(0.5, 0.5, 0.5, 0.5),
                            fontSize: 15.00,
                            fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 5.00),
                      pw.Text(
                        AppStrings.thankYouForYourBusiness.tr(),
                        style: const pw.TextStyle(
                            color: PdfColor(0.5, 0.5, 0.5, 0.5),
                            fontSize: 15.00),
                      ),
                    ])),
            pw.SizedBox(height: 15.00),
          ],
        )
      ]),
    );

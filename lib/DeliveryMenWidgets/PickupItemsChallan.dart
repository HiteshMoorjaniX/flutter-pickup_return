import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

generatePdf(listForChallan, grand_total) async {
  final Document pdf = Document();
  List data = listForChallan;
  print('data is :');
  print(data.length);
  pdf.addPage(MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border:
                    BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
            child: Text('Portable Document Format',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      footer: (Context context) {
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
            Header(
                level: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Pickup Item Challan', textScaleFactor: 2),
                      PdfLogo()
                    ])),
            Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Item id', 'Item Name', 'Item Quantity', 'Price'],
              ...data.map((item) => [
                    item['item_id'].toString(),
                    item['item_name'].toString(),
                    item['item_qua'].toString(),
                    item['price'].toString()
                  ])
            ]),
            Padding(padding: const EdgeInsets.all(10)),
            
            Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Grand Total'],
              <String>['$grand_total']
            ]),
          ]));

  final String dir = (await getApplicationDocumentsDirectory()).path;

  final String path = '$dir/challand.pdf';
  print('path ::');
  print(path);
  final File file = File(path);

  file.writeAsBytesSync(pdf.save());
  return path;
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../transactions/domain/entities/transaction_entry.dart';

class CsvExporter {
  const CsvExporter();

  static const header = ['Date', 'Type', 'Category', 'Merchant', 'Amount', 'Currency', 'Recurrence', 'Note'];

  /// Builds the CSV text. Amounts are plain decimals ("1250.50") so the file
  /// opens cleanly in Excel or Google Sheets.
  String build(List<TransactionEntry> transactions) {
    final date = DateFormat('yyyy-MM-dd');
    final rows = <List<Object?>>[
      header,
      for (final t in transactions)
        [
          date.format(t.occurredAt),
          t.type.name,
          t.category,
          t.merchant ?? '',
          t.amount.toDecimalString(),
          t.amount.currency,
          t.recurrence.name,
          t.note ?? '',
        ],
    ];
    return Csv(lineDelimiter: '\n').encode(rows);
  }

  /// Opens the share sheet (or a download on the web) with the CSV attached.
  Future<void> share(List<TransactionEntry> transactions, DateTime now) async {
    final name = 'wealthmate-${DateFormat('yyyy-MM-dd').format(now)}.csv';
    final bytes = Uint8List.fromList(utf8.encode(build(transactions)));
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(bytes, mimeType: 'text/csv', name: name)],
        fileNameOverrides: [name],
        subject: 'WealthMate transactions',
      ),
    );
  }
}

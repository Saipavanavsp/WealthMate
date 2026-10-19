import 'dart:convert';

import 'package:dio/dio.dart';

import '../database/app_database.dart';

enum PushStatus { applied, conflict, rejected }

class PushResult {
  const PushResult({required this.changeId, required this.status, this.record, this.reason});

  factory PushResult.fromJson(Map<String, dynamic> json) {
    return PushResult(
      changeId: json['changeId'] as int,
      status: PushStatus.values.byName(json['status'] as String),
      record: json['record'] as Map<String, dynamic>?,
      reason: json['reason'] as String?,
    );
  }

  final int changeId;
  final PushStatus status;
  final Map<String, dynamic>? record;
  final String? reason;
}

class PullResponse {
  const PullResponse({required this.changes, required this.cursor});

  factory PullResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['changes'] as Map<String, dynamic>;
    return PullResponse(
      cursor: json['cursor'] as int,
      changes: {
        for (final entry in raw.entries)
          entry.key: [for (final r in entry.value as List<dynamic>) r as Map<String, dynamic>],
      },
    );
  }

  final Map<String, List<Map<String, dynamic>>> changes;
  final int cursor;
}

abstract interface class SyncRemoteDataSource {
  Future<List<PushResult>> push(List<OutboxEntry> entries);
  Future<PullResponse> pull(int since);
}

class SyncApi implements SyncRemoteDataSource {
  SyncApi(this._dio);

  final Dio _dio;

  @override
  Future<List<PushResult>> push(List<OutboxEntry> entries) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/sync/push',
      data: {
        'changes': [
          for (final e in entries) {'changeId': e.id, 'entity': e.entity, 'record': jsonDecode(e.payload)},
        ],
      },
    );
    final results = response.data!['results'] as List<dynamic>;
    return [for (final r in results) PushResult.fromJson(r as Map<String, dynamic>)];
  }

  @override
  Future<PullResponse> pull(int since) async {
    final response = await _dio.get<Map<String, dynamic>>('/sync/pull', queryParameters: {'since': since});
    return PullResponse.fromJson(response.data!);
  }
}

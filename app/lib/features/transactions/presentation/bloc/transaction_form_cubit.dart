import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/money/money.dart';
import '../../domain/categorisation/category_rules.dart';
import '../../domain/entities/categories.dart';
import '../../domain/entities/transaction_entry.dart';
import '../../domain/repositories/transaction_repository.dart';

enum FormStatus { editing, saving, saved }

class TransactionFormState extends Equatable {
  const TransactionFormState({
    required this.occurredAt,
    this.id,
    this.type = TransactionType.expense,
    this.amountText = '',
    this.category = Categories.other,
    this.merchant = '',
    this.note = '',
    this.recurrence = Recurrence.none,
    this.categoryPickedByUser = false,
    this.categorySuggested = false,
    this.status = FormStatus.editing,
    this.failure,
  });

  /// Null for a new transaction.
  final String? id;
  final TransactionType type;
  final String amountText;
  final String category;
  final String merchant;
  final String note;
  final DateTime occurredAt;
  final Recurrence recurrence;
  final bool categoryPickedByUser;
  final bool categorySuggested;
  final FormStatus status;
  final Failure? failure;

  bool get isEditing => id != null;
  Money? get amount => Money.tryParse(amountText);
  bool get canSave => (amount?.isPositive ?? false) && status != FormStatus.saving;

  TransactionFormState copyWith({
    TransactionType? type,
    String? amountText,
    String? category,
    String? merchant,
    String? note,
    DateTime? occurredAt,
    Recurrence? recurrence,
    bool? categoryPickedByUser,
    bool? categorySuggested,
    FormStatus? status,
    Failure? failure,
  }) {
    return TransactionFormState(
      id: id,
      type: type ?? this.type,
      amountText: amountText ?? this.amountText,
      category: category ?? this.category,
      merchant: merchant ?? this.merchant,
      note: note ?? this.note,
      occurredAt: occurredAt ?? this.occurredAt,
      recurrence: recurrence ?? this.recurrence,
      categoryPickedByUser: categoryPickedByUser ?? this.categoryPickedByUser,
      categorySuggested: categorySuggested ?? this.categorySuggested,
      status: status ?? this.status,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    amountText,
    category,
    merchant,
    note,
    occurredAt,
    recurrence,
    categoryPickedByUser,
    categorySuggested,
    status,
    failure,
  ];
}

/// Add/edit form. While the user hasn't chosen a category themselves, typing a
/// merchant updates the category from the rules engine. If they then override
/// the suggestion, the engine learns that merchant for next time.
class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit({
    required TransactionRepository repository,
    required CategoryRuleEngine engine,
    required Future<void> Function(String merchant, String category) learn,
    required String Function() newId,
    DateTime Function()? clock,
  }) : _repository = repository,
       _engine = engine,
       _learn = learn,
       _newId = newId,
       _clock = clock ?? DateTime.now,
       super(TransactionFormState(occurredAt: (clock ?? DateTime.now)()));

  final TransactionRepository _repository;
  final CategoryRuleEngine _engine;
  final Future<void> Function(String merchant, String category) _learn;
  final String Function() _newId;
  final DateTime Function() _clock;

  TransactionEntry? _original;

  Future<void> load(String id) async {
    final entry = await _repository.findById(id);
    if (entry == null) return;
    _original = entry;
    emit(
      TransactionFormState(
        id: entry.id,
        type: entry.type,
        amountText: entry.amount.toDecimalString(),
        category: entry.category,
        merchant: entry.merchant ?? '',
        note: entry.note ?? '',
        occurredAt: entry.occurredAt,
        recurrence: entry.recurrence,
        categoryPickedByUser: true,
      ),
    );
  }

  void typeChanged(TransactionType type) {
    final categories = Categories.forType(type);
    final category = categories.contains(state.category) ? state.category : categories.first;
    emit(state.copyWith(type: type, category: category, categorySuggested: false));
  }

  void amountChanged(String value) => emit(state.copyWith(amountText: value));

  void merchantChanged(String value) {
    if (state.categoryPickedByUser || state.type == TransactionType.income) {
      return emit(state.copyWith(merchant: value));
    }
    final suggestion = _engine.categorise(value);
    emit(state.copyWith(merchant: value, category: suggestion, categorySuggested: suggestion != _engine.fallback));
  }

  void categoryChanged(String category) {
    emit(state.copyWith(category: category, categoryPickedByUser: true, categorySuggested: false));
  }

  void noteChanged(String value) => emit(state.copyWith(note: value));
  void dateChanged(DateTime value) => emit(state.copyWith(occurredAt: value));
  void recurrenceChanged(Recurrence value) => emit(state.copyWith(recurrence: value));

  Future<void> save() async {
    final amount = state.amount;
    if (amount == null || !amount.isPositive) {
      return emit(state.copyWith(failure: const ValidationFailure('Enter an amount greater than zero')));
    }
    emit(state.copyWith(status: FormStatus.saving));

    final merchant = state.merchant.trim();
    final entry = TransactionEntry(
      id: state.id ?? _newId(),
      type: state.type,
      amount: amount,
      category: state.category,
      merchant: merchant.isEmpty ? null : merchant,
      note: state.note.trim().isEmpty ? null : state.note.trim(),
      occurredAt: state.occurredAt,
      recurrence: state.recurrence,
      updatedAt: _clock(),
    );

    final result = await _repository.save(entry);
    if (!result.isOk) {
      return result.fold((f) => emit(state.copyWith(status: FormStatus.editing, failure: f)), (_) {});
    }

    final userCorrected = state.categoryPickedByUser && _engine.categorise(merchant) != state.category;
    final categoryChanged = _original?.category != state.category;
    if (merchant.isNotEmpty && userCorrected && categoryChanged) {
      await _learn(merchant, state.category);
    }
    emit(state.copyWith(status: FormStatus.saved));
  }
}

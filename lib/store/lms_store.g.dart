// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lms_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LmsStore on LmsStoreBase, Store {
  late final _$quizListAtom =
      Atom(name: 'LmsStoreBase.quizList', context: context);

  @override
  List<QuizAnswers> get quizList {
    _$quizListAtom.reportRead();
    return super.quizList;
  }

  @override
  set quizList(List<QuizAnswers> value) {
    _$quizListAtom.reportWrite(value, super.quizList, () {
      super.quizList = value;
    });
  }

  @override
  String toString() {
    return '''
quizList: ${quizList}
    ''';
  }
}

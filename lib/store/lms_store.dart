import 'package:mobx/mobx.dart';
import 'package:socialv/models/lms/quiz_answers.dart';

part 'lms_store.g.dart';

class LmsStore = LmsStoreBase with _$LmsStore;

abstract class LmsStoreBase with Store {
  @observable
  List<QuizAnswers> quizList = [];
}

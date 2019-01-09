import 'package:news_app/models/add_news_to_interesting.dart';
import 'package:news_app/resources/db_helper.dart';
import 'dart:async';

class InterestingBloc {
  final _interestingController = StreamController<List<InterestingModel>>.broadcast();
  get interesting => _interestingController.stream;

  dispose() {
    _interestingController.close();
  }

  // ToDo make not init method
  getInteresting() async {
    _interestingController.sink.add(await DBHelper.get().init());
  }

  add(InterestingModel model) {
    DBHelper.get().newInterestingTheme(model);
    getInteresting();
  }

  getAllInteresting() async{
    _interestingController.sink.add(await DBHelper.get().getAllInteresting());

  }
}


final blocInteresting = InterestingBloc();

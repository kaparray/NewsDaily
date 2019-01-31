# NewsApp
News app in Flutter with BLOC pattern

<img src="https://github.com/kaparray/NewsApp/blob/master/assetss/NewsAppFlutterAsset_2.jpeg" width="500">



This example uses a CustomScrollView, JSON Rest API, BottonNavigationBar,SliverList, ClipRRect, Card, Progress Indicator, NetworkImage, Card, Column, Row, Container, InkWell, BoxDecoration.



### Library 
* [*__rxdart__*](https://pub.dartlang.org/packages/rxdart)
* [*__http__*](https://pub.dartlang.org/packages/http)
* [*__webview_flutter__*](https://pub.dartlang.org/packages/webview_flutter)
* [*__shared_preferences__*](https://pub.dartlang.org/packages/shared_preferences)
* [*__share__*](https://pub.dartlang.org/packages/share)
* [*__cloud_firestore__*](https://pub.dartlang.org/packages/cloud_firestore)
* [*__uuid__*](https://pub.dartlang.org/packages/uuid)
* [*__dynamic_theme__*](https://pub.dartlang.org/packages/dynamic_theme)
* [*__flutter_picker__*](https://pub.dartlang.org/packages/flutter_picker)
* [*__flutter_material_color_picker__*](https://pub.dartlang.org/packages/flutter_material_color_picker)

### Bloc pattern

*I used this pattern to design this application.*

<img src="https://cdn-images-1.medium.com/max/1600/1*MqYPYKdNBiID0mZ-zyE-mA.png"  width="400">

```dart
class NewsBloc {
  final _repository = Repository();
  final _newsFetcher = PublishSubject<NewsModel>();
  final _newsSearchFetcher = PublishSubject<NewsModel>();
  final _newsLikeFetcher = PublishSubject<NewsModel>();

  Observable<NewsModel> get allNews => _newsFetcher.stream;
  Observable<NewsModel> get searchNews => _newsSearchFetcher.stream;
  Observable<NewsModel> get likeNews => _newsLikeFetcher.stream;

  fetchLikedNews() async {
    NewsModel newsModel = await _repository.fetchLikedNews();
    _newsLikeFetcher.sink.add(newsModel);
  }

  fetchAllNews() async {
    NewsModel newsModel = await _repository.fetchAllNews();
    _newsFetcher.sink.add(newsModel);
  }

  fetchSearchNews() async {
    NewsModel newsModel = await _repository.fetchSearchNews();
    _newsSearchFetcher.sink.add(newsModel);
  }

  // Set and delete from Firestore liked
  addFavorit(val) async => _repository.addFavorit(val);
  deliteFavorit(val) async => _repository.deliteFavorit(val);

  dispose() {
    _newsLikeFetcher.close();
    _newsFetcher.close();
    _newsSearchFetcher.close();
  }
}

final bloc = NewsBloc();
```

### Screenshots

<p align="center">
  <img src="https://github.com/kaparray/NewsApp/blob/master/assetss/NewsAppFlutterAsset_3.jpeg" width="350"/>
    <img src="https://github.com/kaparray/NewsApp/blob/master/assetss/NewsAppFlutterAsset_4.jpeg" width="350"/>

</p>
<p align="center">
  <img src="https://github.com/kaparray/NewsApp/blob/master/assetss/NewsAppFlutterAsset_1.gif" width="500"/>
</p>



## Built With
* [Flutter](https://flutter.io) - Crossplatform App Development Framework

### License
Released under the [MIT license](https://github.com/kaparray/NewsApp/blob/master/LICENSE)

### Author

Adeshchenko Kirill (Cyrill) ([@kaparray](https://www.linkedin.com/in/kirill-adeshchenko-b86362161/))

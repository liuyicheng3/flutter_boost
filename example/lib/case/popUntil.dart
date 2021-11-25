import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_boost_example/case/transparent_widget.dart';

class PopUntilRoute extends StatefulWidget {
  static int count = 0;

  @override
  PopUntilRouteState createState() => PopUntilRouteState();
}

class PopUntilRouteState extends State<PopUntilRoute> {
  @override
  void initState() {
    super.initState();
    PopUntilRoute.count++;
  }

  @override
  void dispose() {
    super.dispose();
    PopUntilRoute.count--;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Row(
              children: [
                // Icon(Icons.arrow_back),
                Text('popUntil'),
              ],
            ),
            onTap: () => onBackPressed(context),
          ),
          title: Text('Page A ${PopUntilRoute.count}'),
        ),
        body: Container(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    BoostNavigator.instance
                        .push("popUntilView", withContainer: true);
                  },
                  child: Text('push with container')),
              TextButton(
                  onPressed: () {
                    BoostNavigator.instance
                        .push("popUntilView", withContainer: false);
                  },
                  child: Text('push without container ')),
              TextButton(
                  onPressed: () {
                    BoostNavigator.instance
                        .push("native")
                        .then((value) => print("return:${value?.toString()}"));
                  },
                  child: Text('push 一个Native')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return TransparentWidget();
                    }));
                  },
                  child: Text('原生的 push，回来不会build')),
              TextButton(
                  onPressed: () {
                    BoostNavigator.instance.push("secondStateful", withContainer: true);
                  },
                  child: Text('push with container 复现 push 回来会rebuild')),
              TextButton(
                  onPressed: () {
                    BoostNavigator.instance.push("secondStateful", withContainer: false);
                  },
                  child: Text('push without container 复现 push 回来会rebuild')),
              FutureBuilder<String>(
                future: mockNetworkData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // 请求已结束
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      // 请求失败，显示错误
                      return Text("Error: ${snapshot.error}");
                    } else {
                      // 请求成功，显示数据
                      return Text("Contents: ${snapshot.data}");
                    }
                  } else {
                    // 请求未结束，显示loading
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          )),
        ));
  }

  int current= 0;
  Future<String> mockNetworkData() async {
    debugPrint("futurebuilder Page A ${PopUntilRoute.count}");
    current++;
    return Future.delayed(Duration(seconds: 2), () => "我是build的次数: ${current}");
  }

  void onBackPressed(BuildContext context) {
    BoostNavigator.instance.popUntil(route: "flutterPage");
  }
}

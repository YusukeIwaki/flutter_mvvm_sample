import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:state_notifier/state_notifier.dart';

void main() {
  runApp(MyApp());
}

class HomePageState {
  const HomePageState({this.isLoading = false, this.data = const []});

  final bool isLoading;
  final List<int> data;
}

class HomePageController extends StateNotifier<HomePageState> {
  HomePageController() : super(const HomePageState());

  load() async {
    state = HomePageState(isLoading: true, data: state.data);

    await Future.delayed(Duration(seconds: 3));

    state = HomePageState(isLoading: false, data: [1, 2, 3] + state.data);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StateNotifierProvider<HomePageController, HomePageState>(
        create: (_) => HomePageController(),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Column(
              children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        context.read<HomePageController>().load();
                      },
                      child: Text("Load!"),
                    )
                  ] +
                  context
                      .select<HomePageState, List<int>>((state) => state.data)
                      .map<Widget>((e) => Text(e.toString()))
                      .toList(),
            ),
          ),
          context.select<HomePageState, bool>((state) => state.isLoading)
              ? Container(
                  alignment: AlignmentDirectional.center,
                  child: CircularProgressIndicator())
              : null,
        ]..removeWhere((it) => it == null),
      ),
    );
  }
}

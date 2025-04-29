import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 获取一句土味情话（有够土的🤮
Future<String> getJsonData() async {
  final response = await http.get(
    Uri.https('api.uomg.com', '/api/rand.qinghua', {'format': 'json'}),
  );
  return jsonDecode(response.body)['content'];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter官方Demo',
      theme: ThemeData(
        // 这是应用程序的主题
        //
        // 尝试这个：运行"flutter run"启动应用
        // 你会看到应用有紫色工具栏。在不退出应用的情况下
        // 尝试将colorScheme中的seedColor改为Colors.green
        // 然后执行热重载（保存更改或点击IDE的热重载按钮，如果使用命令行启动可按r键）
        //
        // 注意计数器没有重置归零，应用状态在重载时不会丢失
        // 要重置状态请使用热重启
        //
        // 这不仅适用于值修改，对代码同样有效：大多数代码变更
        // 都可以通过热重载来测试
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      home: const MyHomePage(title: 'Flutter首页'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // 该组件是应用程序的主页，它是一个有状态组件（StatefulWidget）
  // 这意味着它拥有一个状态对象（下方定义的State子类）
  // 该状态对象包含影响页面显示的字段

  // 这个类作为状态的配置类，它保存了父组件（此处指App组件）提供的值
  // （在本例中是标题属性），这些值将被State的build方法使用
  // 请注意：Widget子类中的字段始终标记为final

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _text = "hello";
  bool _isLoading = true;
  Timer? _timer;
  Timer? _timer2;

  @override
  void dispose() {
    _timer?.cancel();
    _timer2?.cancel();
    super.dispose();
  }

  void _incrementCounter() async {
    setState(() {
      // 调用setState会通知Flutter框架当前状态已发生变化
      // 这将触发下方build方法的重新执行，以便界面能够反映更新后的值
      // 若直接修改_counter而不调用setState()
      // 则不会触发build方法重新执行，界面也不会更新
      _counter += 2;
    });
    if (_isLoading) {
      try {
        _text = '🤮${await getJsonData()}🤮';
        setState(() => _text);
      } catch (e) {
        setState(() => _text = 'Error: $e');
      }
      _isLoading = false;
      _timer = Timer(const Duration(seconds: 1), () {
        _isLoading = true;
      });
    } else {
      _timer2?.cancel();
      setState(() {
        _text = '点击频率请慢一些.';
      });
      _timer2 = Timer(const Duration(milliseconds: 1300), () async {
        _text = '🤮${await getJsonData()}🤮';
        setState(() => _text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 每当调用setState时（例如上述的_incrementCounter方法）
    // 这个build方法都会重新执行
    //
    // Flutter框架已优化了build方法的重复执行效率
    // 因此你只需重建需要更新的部分
    // 而无需逐个修改组件实例
    return Scaffold(
      appBar: AppBar(
        // 尝试这个：将此处颜色改为特定颜色（比如Colors.amber）
        // 然后执行热重载，观察AppBar颜色变化
        // 其他颜色将保持原有状态
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // 此处从MyHomePage对象获取值（该对象由App组件的build方法创建）
        // 并用于设置应用栏的标题
        title: Text(widget.title),
      ),
      body: Center(
        // Center 是一个布局组件
        // 它接收一个子组件，并将其居中放置在父组件内
        child: Column(
          // Column 同样是一个布局组件
          // 它接收子组件列表，并垂直排列这些子组件
          // 默认情况下，它会水平延展以适配子组件
          // 并尽可能达到父组件的高度
          //
          // Column 提供多种属性用于控制自身尺寸
          // 以及子组件的排列方式。此处我们使用mainAxisAlignment
          // 在垂直方向居中子组件（由于Column的主轴是垂直方向
          // 交叉轴则为水平方向）
          //
          // 尝试这个：启用"debug painting"调试视图
          // （在IDE中选择"Toggle Debug Paint"操作
          // 或控制台输入p键），查看各组件线框
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('你已经点击的次数为:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(_text),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: '增加',
        child: const Icon(Icons.ac_unit),
      ), // 末尾的逗号让构建方法的自动格式化更美观
    );
  }
}

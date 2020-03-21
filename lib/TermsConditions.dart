import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:http/http.dart' as http;
import 'package:pickup_return/api_config.dart' as Api_Config;
class TermsConditions extends StatefulWidget {
  @override
  _TermsConditionsState createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  String demo = '';
  static const String htmlDemo = '''
  <h2>YouTube embed code</h2>
  <iframe src="https://www.youtube.com/embed/b_sQ9bMltGU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
  <h2>Image</h2>
  <h2>Text</h2>
  <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum nec egestas erat, gravida tempus ipsum. Suspendisse ac pharetra quam. Ut pellentesque interdum est non sodales. Nunc nec lacus in neque dapibus cursus id eget neque. Curabitur luctus ante id orci eleifend, nec consequat arcu ullamcorper. Pellentesque quis mi ex. In mattis sollicitudin metus at molestie. Cras maximus felis eget leo lacinia egestas. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Maecenas ipsum ligula, sodales quis auctor in, vestibulum nec ligula. Pellentesque aliquet justo in faucibus bibendum. Praesent risus arcu, interdum eget elit id, dictum mollis ex. Pellentesque in sodales diam.</p>
  <p>Praesent quis augue vitae quam consectetur aliquet. Fusce sit amet orci quis leo porttitor vestibulum quis nec justo. Donec gravida in leo at rhoncus. Pellentesque faucibus porttitor sapien, sit amet interdum lacus lacinia at. Duis sagittis dolor massa, ut aliquet orci egestas a. Aenean orci metus, malesuada quis sapien in, dignissim ultrices elit. Nullam tincidunt dictum gravida. Mauris cursus libero enim, ultrices posuere sapien sodales ut. Suspendisse lacinia odio id fringilla pharetra. Aliquam iaculis augue ac enim porta, pulvinar hendrerit nibh rutrum. Donec quis lorem eget augue interdum malesuada. Etiam tincidunt sed diam et lacinia. Fusce nec lacus tellus. Vestibulum odio magna, molestie et orci sit amet, porta ullamcorper nisl. Donec porta quam in molestie laoreet.</p>
  <p>Duis pretium suscipit euismod. Donec sodales risus ut felis porttitor rhoncus. Cras ullamcorper egestas lacus id euismod. Maecenas aliquet tellus odio, eget vulputate orci consequat quis. Duis interdum, ipsum eget rutrum scelerisque, dolor justo malesuada enim, eget tempus purus magna vitae lorem. Maecenas quis neque a purus tempor scelerisque vel ut libero. Suspendisse posuere nisl ut varius molestie.</p>
 ''';

  @override
  void initState() {
    this.fetchTermsAndConditions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("flutter_html_renderer demo")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Expanded(
              child: HtmlWidget(demo),
            )
          ],
        )

        // body: HtmlWidget(
        //   htmlDemo
        // ),
        );
  }

  Future<String> fetchTermsAndConditions() {
    http.get(Api_Config.termsAndConditions).then((http.Response response) {
      final int statusCode = response.statusCode;
      print('Status Code : $statusCode');
      print(response.body);
      demo = response.body;
    });
  }

}

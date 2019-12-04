import 'dart:io';

import 'package:html_factory/html_factory.dart';

void main() {
  final html = 'html'([
    'head'([
      'meta'({'charset': 'UTF-8'}),
      'title'('This is a document title'),
    ]),
    'body'([
      'p'('Hello World!'),
      'a'({'href': 'https://www.google.com/'})('This is a link'),
      'p'(
        'a'({'href': 'https://en.wikipedia.org/'})(
          'img'({
            'src': 'https://via.placeholder.com/300',
            'width': '100px',
            'height': '100px',
          })('A clickable image should go here'),
        ),
      ),
    ]),
  ]);

  final render = html.render();
  print(render);

  File('index.html').writeAsStringSync(render);
}

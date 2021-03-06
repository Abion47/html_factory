# html_factory

A proof-of-concept package that uses extension methods to create a concise HTML writer syntax similar to the one on the [Kotlin reference page](https://kotlinlang.org/docs/reference/type-safe-builders.html).

This is not meant to be a robust HTML writer package solution. It is merely an experiment using the new Dart 2.6 extension method feature. The package creates an extension method for the `String` type named `call`. This takes advantage of Dart's support for callable objects, namely any type that defines a "call" method can be called as though it were a method. As a result, strings become callable objects, which when paired with an HTML element class can create a concise way to write and render HTML code in Dart.

In use, the string's `call` method returns an `HtmlElement` with the name set to the string value that the method was called on. There are optional parameters for child/value and attributes as well. The `HtmlElement` itself is also a callable object which returns a cloned element with an optional new child/value or attribute set, allowing a method call chain that organizes the attributes before the child/value parameter which more closely resembles actual HTML syntax. Calling `render` on the element object converts the entire HTML tree into a string representation, which can then be exported as an HTML file.

This approach has some readability concerns (which could probably be resolved with plugin support) and could probably be extended to also support a certain level of type safety, but as I've said, this is merely a proof-of-concept. In fact, I'm not sure I would recommend this approach in practice, as there are several concerns regarding using an extension method to turn a built-in type to a callable object, not least of which being that it would naturally conflict with any other package that attempts to do the same thing. Still, it's a cool enough idea, and there may be some use for it as a server-side HTML renderer option if it got fleshed out.

To see it in action, run the example:

```dart
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
```
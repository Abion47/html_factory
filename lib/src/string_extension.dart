import 'html_element.dart';

extension StringExtension on String {
  HtmlElement call([dynamic child, Map<String, String> attributes]) {
    if (child is Map<String, String>) {
      attributes = child;
      child = null;
    }

    return HtmlElement(this, child, attributes);
  }
}

class HtmlElement {
  final String name;
  final dynamic value;
  final Map<String, String> attributes;

  HtmlElement(this.name, this.value, this.attributes);

  HtmlElement call([dynamic value, Map<String, String> attributes]) {
    return HtmlElement(
      this.name,
      value ?? this.value,
      attributes ?? this.attributes,
    );
  }

  String render() {
    if (!RenderState.rendering) {
      RenderState.reset();
      RenderState.rendering = true;

      String render = '<!DOCTYPE html>\n${this.render()}';

      RenderState.rendering = false;
      return render;
    }

    String indent = RenderState.indent;

    String attrRender = _renderAttributes();

    RenderState.incrementIndent();
    String childRender = _renderChild(value);
    RenderState.decrementIndent();

    if (childRender.isEmpty) {
      return '$indent<$name${attrRender.isEmpty ? '' : ' $attrRender'} />';
    }

    if (value is String && !childRender.contains('\n')) {
      return '$indent<$name${attrRender.isEmpty ? '' : ' $attrRender'}>${childRender.trimLeft()}</$name>';
    }

    String start = '$indent<$name${attrRender.isEmpty ? '' : ' $attrRender'}>';
    String end = '$indent</$name>';
    return '$start\n$childRender\n$end';
  }

  String _renderAttributes() {
    if (attributes == null || attributes.length == 0) {
      return '';
    }

    String render = '';
    for (var entry in attributes.entries) {
      if (render.isNotEmpty) render += ' ';
      render += '${entry.key}="${entry.value}"';
    }

    return render;
  }

  String _renderChild(dynamic child) {
    if (child == null) {
      return '';
    }

    if (child is String) {
      return '${RenderState.indent}$child';
    }

    if (child is HtmlElement) {
      return child.render();
    }

    if (child is List) {
      if (child.length == 0) {
        return '';
      }

      if (child.length == 1) {
        return _renderChild(child[0]);
      }

      var render = '';
      for (var v in child) {
        if (render.isNotEmpty) render += '\n';
        render += _renderChild(v);
      }

      return render;
    }

    print('Unsupported child type: ${child.runtimeType}');
    return '';
  }
}

class RenderState {
  static bool rendering = false;
  static var indentLevel = 0;
  static String indentChar = '  ';

  static String get indent => indentChar * indentLevel;

  static reset() {
    rendering = false;
    indentLevel = 0;
  }

  static incrementIndent() {
    indentLevel++;
  }

  static decrementIndent() {
    indentLevel--;
    if (indentLevel < 0) indentLevel = 0;
  }
}

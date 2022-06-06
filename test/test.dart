// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  ColorRep c1 = ColorRep(name: "red");
  ColorRep c2 = ColorRep(name: "blue");
  Hello h11 = Hello(color: c1, name: "hellored");
  Hello h12 = Hello(color: c1, name: "hellored");
  Hello h2 = Hello(color: c2, name: "helloblue");

  print(h11.color);
  print(h12.color);
  print(h2.color);

  c1.name = "green";

  print(h11.color);
  print(h12.color);
  print(h2.color);

  print("--" + (h11 is ColorRep).toString());
}

class ColorRep {
  String name = "";
  ColorRep({
    required this.name,
  });

  ColorRep copyWith({
    String? name,
  }) {
    return ColorRep(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory ColorRep.fromMap(Map<String, dynamic> map) {
    return ColorRep(
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ColorRep.fromJson(String source) => ColorRep.fromMap(json.decode(source));

  @override
  String toString() => 'ColorRep(name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ColorRep && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

class Hello {
  ColorRep color;
  String name = "";
  Hello({
    required this.color,
    required this.name,
  });

  Hello copyWith({
    ColorRep? color,
    String? name,
  }) {
    return Hello(
      color: color ?? this.color,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'name': name,
    };
  }

  factory Hello.fromMap(Map<String, dynamic> map) {
    return Hello(
      color: map['color'],
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Hello.fromJson(String source) => Hello.fromMap(json.decode(source));

  @override
  String toString() => 'Hello(color: $color, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Hello && other.color == color && other.name == name;
  }

  @override
  int get hashCode => color.hashCode ^ name.hashCode;
}

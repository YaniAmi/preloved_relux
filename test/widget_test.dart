import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prelovedrelux/main.dart';
import 'package:prelovedrelux/data/datasource/item_repository_impl.dart';
import 'package:prelovedrelux/data/datasource/local/local_cart_datasource.dart';
import 'package:prelovedrelux/data/datasource/network/firebase_item_datasource.dart';
import 'package:prelovedrelux/data/datasource/network/firebase_user_datasource.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Provide the necessary arguments for MyApp
    final userRepository = FirebaseUserDataSource();
    final itemRepository = ItemRepositoryImpl(
      FirebaseItemDataSource(),
      LocalCartDataSource(FirebaseItemDataSource()),
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(userRepository, itemRepository));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/main.dart';

void main() {
  testWidgets('App renders splash title', (WidgetTester tester) async {
   
    await tester.pumpWidget(const MyApp());

  
    expect(find.text('NewsApp'), findsOneWidget);

  
    await tester.pump(const Duration(seconds: 3));
    
  
    await tester.pumpAndSettle();
  });
}
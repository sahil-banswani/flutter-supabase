import 'package:flutter/material.dart';
import 'package:practice_1_supabase/constants/api_keys.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: API_URL,
    anonKey: API_ANON,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Supabase example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _future = Supabase.instance.client.from('countries').select<List<Map<String, dynamic>>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Data'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _future,
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  final countries = snapshot.data!;
                  return ListView.builder(
                    itemCount: countries.length,
                    itemBuilder: (country, index) {
                      final country = countries[index];
                      return ListTile(
                        title: Text(country['name']),
                      );
                    });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
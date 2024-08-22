import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: "Temperature Calculator",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum TemperatureUnit {
  celsius(unit: "°C", name: "Celsius"),
  fahrenheit(unit: "°F", name: "Fahrenheit"),
  kelvin(unit: "K", name: "Kelvin");

  const TemperatureUnit({required this.unit, required this.name});

  final String unit;
  final String name;
}

class _MyHomePageState extends State<MyHomePage> {
  var _inputTemperature = 0.0;
  final _fromCelsiusMap = {
    TemperatureUnit.celsius: (x) => x,
    TemperatureUnit.fahrenheit: (x) => x * 1.8 + 32,
    TemperatureUnit.kelvin: (x) => x + 273.15
  };
  final _toCelsiusMap = {
    TemperatureUnit.celsius: (x) => x,
    TemperatureUnit.fahrenheit: (x) => (x - 32) / 1.8,
    TemperatureUnit.kelvin: (x) => x - 273.15
  };
  var _selectedInitUnit = TemperatureUnit.celsius;
  var _selectedOutUnit = TemperatureUnit.celsius;

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Result: ${format(_fromCelsiusMap[_selectedOutUnit]!(_toCelsiusMap[_selectedInitUnit]!(_inputTemperature)))} ${_selectedOutUnit.unit}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownMenu<TemperatureUnit>(
                    initialSelection: _selectedInitUnit,
                    label: const Text('Initial Unit'),
                    onSelected: (TemperatureUnit? unit) {
                      setState(() {
                        _selectedInitUnit = unit ?? TemperatureUnit.celsius;
                      });
                    },
                    dropdownMenuEntries: TemperatureUnit.values
                        .map<DropdownMenuEntry<TemperatureUnit>>(
                            (TemperatureUnit unit) {
                      return DropdownMenuEntry<TemperatureUnit>(
                          value: unit, label: unit.name);
                    }).toList(),
                  ),
                ),
                const Text("to"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownMenu<TemperatureUnit>(
                    initialSelection: _selectedOutUnit,
                    label: const Text('Output Unit'),
                    onSelected: (TemperatureUnit? unit) {
                      setState(() {
                        _selectedOutUnit = unit ?? TemperatureUnit.celsius;
                      });
                    },
                    dropdownMenuEntries: TemperatureUnit.values
                        .map<DropdownMenuEntry<TemperatureUnit>>(
                            (TemperatureUnit unit) {
                      return DropdownMenuEntry<TemperatureUnit>(
                          value: unit, label: unit.name);
                    }).toList(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration:
                    const InputDecoration(hintText: "Input Temperature..."),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _inputTemperature =
                        double.tryParse(value) ?? _inputTemperature;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

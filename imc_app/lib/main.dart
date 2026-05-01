import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const ImcApp());
}

class ImcApp extends StatelessWidget {
  const ImcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D4AA),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const CalculadoraScreen(),
    );
  }
}

// ── Modelo para guardar cada medición ──
class Medicion {
  final double peso;
  final double altura;
  final double imc;
  final String categoria;
  final DateTime fecha;

  Medicion({
    required this.peso,
    required this.altura,
    required this.imc,
    required this.categoria,
    required this.fecha,
  });

  Map<String, dynamic> toJson() => {
        'peso': peso,
        'altura': altura,
        'imc': imc,
        'categoria': categoria,
        'fecha': fecha.toIso8601String(),
      };

  factory Medicion.fromJson(Map<String, dynamic> json) => Medicion(
        peso: json['peso'],
        altura: json['altura'],
        imc: json['imc'],
        categoria: json['categoria'],
        fecha: DateTime.parse(json['fecha']),
      );
}

// ── Pantalla principal: Calculadora ──
class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();
  double? _imc;
  String? _categoria;
  Color? _categoriaColor;
  List<Medicion> _historial = [];

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  // Cargar historial guardado
  Future<void> _cargarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('historial');
    if (data != null) {
      final List<dynamic> lista = jsonDecode(data);
      setState(() {
        _historial = lista.map((e) => Medicion.fromJson(e)).toList();
      });
    }
  }

  // Guardar historial
  Future<void> _guardarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_historial.map((e) => e.toJson()).toList());
    await prefs.setString('historial', data);
  }

  // Calcular IMC y categoría
  void _calcular() {
    final peso = double.tryParse(_pesoController.text);
    final altura = double.tryParse(_alturaController.text);

    if (peso == null || altura == null || peso <= 0 || altura <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa valores válidos')),
      );
      return;
    }

    final alturaM = altura / 100; // convertir cm a metros
    final imc = peso / (alturaM * alturaM);

    String categoria;
    Color color;

    if (imc < 18.5) {
      categoria = 'Bajo peso';
      color = Colors.lightBlue;
    } else if (imc < 25) {
      categoria = 'Normal';
      color = const Color(0xFF00D4AA);
    } else if (imc < 30) {
      categoria = 'Sobrepeso';
      color = Colors.orange;
    } else {
      categoria = 'Obesidad';
      color = Colors.redAccent;
    }

    final medicion = Medicion(
      peso: peso,
      altura: altura,
      imc: imc,
      categoria: categoria,
      fecha: DateTime.now(),
    );

    setState(() {
      _imc = imc;
      _categoria = categoria;
      _categoriaColor = color;
      _historial.insert(0, medicion); // Más reciente primero
    });

    _guardarHistorial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora IMC',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistorialScreen(
                    historial: _historial,
                    onBorrar: () {
                      setState(() {
                        _historial.clear();
                      });
                      _guardarHistorial();
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ícono superior
            const Icon(
              Icons.monitor_weight_outlined,
              size: 64,
              color: Color(0xFF00D4AA),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingresa tus datos',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Campo peso
            TextField(
              controller: _pesoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Peso (kg)',
                prefixIcon: const Icon(Icons.fitness_center),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
              ),
            ),
            const SizedBox(height: 16),

            // Campo altura
            TextField(
              controller: _alturaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Altura (cm)',
                prefixIcon: const Icon(Icons.height),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
              ),
            ),
            const SizedBox(height: 24),

            // Botón calcular
            ElevatedButton(
              onPressed: _calcular,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4AA),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Calcular IMC'),
            ),
            const SizedBox(height: 32),

            // Resultado
            if (_imc != null) ...[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _categoriaColor!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _categoriaColor!.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Tu IMC',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _imc!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: _categoriaColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _categoriaColor!.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _categoria!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _categoriaColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBarraImc(),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Barra visual de categorías IMC
  Widget _buildBarraImc() {
    return Column(
      children: [
        Row(
          children: [
            _buildSegmento('Bajo', Colors.lightBlue, 0.185),
            _buildSegmento('Normal', const Color(0xFF00D4AA), 0.315),
            _buildSegmento('Sobre', Colors.orange, 0.25),
            _buildSegmento('Obesidad', Colors.redAccent, 0.25),
          ],
        ),
        const SizedBox(height: 4),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('< 18.5', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('25', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('30', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('40+', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildSegmento(String label, Color color, double flex) {
    return Expanded(
      flex: (flex * 100).toInt(),
      child: Container(
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

// ── Pantalla de Historial ──
class HistorialScreen extends StatelessWidget {
  final List<Medicion> historial;
  final VoidCallback onBorrar;

  const HistorialScreen({
    super.key,
    required this.historial,
    required this.onBorrar,
  });

  Color _getColor(String categoria) {
    switch (categoria) {
      case 'Bajo peso':
        return Colors.lightBlue;
      case 'Normal':
        return const Color(0xFF00D4AA);
      case 'Sobrepeso':
        return Colors.orange;
      case 'Obesidad':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historial',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (historial.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Borrar historial'),
                    content: const Text(
                      '¿Estás seguro de borrar todas las mediciones?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          onBorrar();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('Borrar'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: historial.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Sin mediciones aún',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historial.length,
              itemBuilder: (context, index) {
                final m = historial[index];
                final color = _getColor(m.categoria);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.2),
                      child: Text(
                        m.imc.toStringAsFixed(0),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      m.categoria,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    subtitle: Text(
                      '${m.peso} kg · ${m.altura} cm',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      '${m.fecha.day}/${m.fecha.month}/${m.fecha.year}\n${m.fecha.hour}:${m.fecha.minute.toString().padLeft(2, '0')}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
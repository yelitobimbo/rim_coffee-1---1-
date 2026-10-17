/// Formatea un monto como moneda: 4180 -> $4,180
String money(num valor) {
  final entero = valor.round();
  final digitos = entero.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digitos.length; i++) {
    if (i > 0 && (digitos.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digitos[i]);
  }
  final signo = entero < 0 ? '-' : '';
  return '$signo\$${buffer.toString()}';
}

/// Hora actual en formato HH:MM.
String horaActual() {
  final ahora = DateTime.now();
  String dos(int v) => v.toString().padLeft(2, '0');
  return '${dos(ahora.hour)}:${dos(ahora.minute)}';
}

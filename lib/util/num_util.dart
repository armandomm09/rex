import 'dart:math';

class NumUtil {

  static double recortarDecimales(double numero, int decimales) {
    var factor = pow(10, decimales);
    return (numero * factor).truncateToDouble() / factor;
  }
}
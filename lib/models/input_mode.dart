enum InputMode { 
  normal, 
  corner, 
  center, 
  color, 
  multiSelect 
}

extension InputModeExtension on InputMode {
  String get displayName {
    switch (this) {
      case InputMode.normal:
        return 'Normal';
      case InputMode.corner:
        return 'Corner';
      case InputMode.center:
        return 'Center';
      case InputMode.color:
        return 'Color';
      case InputMode.multiSelect:
        return 'Multi-Select';
    }
  }
}
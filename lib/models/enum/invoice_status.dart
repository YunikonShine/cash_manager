enum InvoiceStatus {
  close,
  open,
  future;
}

extension InvoiceStatusExtension on InvoiceStatus {
  int get id {
    switch (this) {
      case InvoiceStatus.close:
        return 0;
      case InvoiceStatus.open:
        return 1;
      case InvoiceStatus.future:
        return 2;
    }
  }

  String get description {
    switch (this) {
      case InvoiceStatus.close:
        return "Fechada";
      case InvoiceStatus.open:
        return "Aberta";
      case InvoiceStatus.future:
        return "Futura";
    }
  }
}

class InvoiceStatusHelper {
  static InvoiceStatus fromId(int id) {
    switch (id) {
      case 0:
        return InvoiceStatus.close;
      case 1:
        return InvoiceStatus.open;
      case 2:
        return InvoiceStatus.future;
      default:
        throw Exception("Enum id not found");
    }
  }
}

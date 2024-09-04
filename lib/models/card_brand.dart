import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum CardBrand { visa, master }

extension CardBrandExtension on CardBrand {
  String get name {
    switch (this) {
      case CardBrand.visa:
        return 'Visa';
      case CardBrand.master:
        return 'Mastercard';
    }
  }

  String get image {
    switch (this) {
      case CardBrand.visa:
        return 'visa';
      case CardBrand.master:
        return 'mastercard';
    }
  }

  int get id {
    switch (this) {
      case CardBrand.visa:
        return 1;
      case CardBrand.master:
        return 2;
    }
  }

  IconData get icon {
    switch (this) {
      case CardBrand.visa:
        return FontAwesomeIcons.ccVisa;
      case CardBrand.master:
        return FontAwesomeIcons.ccMastercard;
    }
  }
}

class CardBrandHelper {
  static CardBrand fromId(int id) {
    switch (id) {
      case 1:
        return CardBrand.visa;
      case 2:
        return CardBrand.master;
    }
    throw Exception();
  }
}

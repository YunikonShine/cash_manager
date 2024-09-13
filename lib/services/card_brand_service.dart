import 'package:cash_manager/models/card_brand.dart';
import 'package:cash_manager/services/database/repositories/card_brand_repository.dart';

class CardBrandService {
  static Future<CardBrand> findById(int brandId) async {
    Map<String, dynamic>? brandResponse =
        await CardBrandRepository.findById(brandId);
    if (brandResponse == null) {
      throw Exception("Card brand not found");
    }
    return CardBrand.fromMap(brandResponse);
  }

  static Future<List<CardBrand>> findAll() async {
    List<Map<String, dynamic>> brandResponse =
        await CardBrandRepository.findAll();

    List<CardBrand> brands = [];
    for (Map<String, dynamic> brandItem in brandResponse) {
      brands.add(CardBrand.fromMap(brandItem));
    }

    return brands;
  }
}

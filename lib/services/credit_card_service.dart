import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/dto/credit_card_dto.dart';
import 'package:cash_manager/services/account_service.dart';
import 'package:cash_manager/services/card_brand_service.dart';
import 'package:cash_manager/services/database/repositories/credit_card_repository.dart';

class CreditCardService {
  static Future<void> createCreditCard(CreditCardDTO card) async {
    await CreditCardRepository.create(card);
  }

  static Future<CreditCard> findById(int id) async {
    Map<String, dynamic>? creditCardResponse =
        await CreditCardRepository.findById(id);

    if (creditCardResponse == null) {
      throw Exception("Credit card not found");
    }

    CreditCard creditCard = CreditCard.fromMap(creditCardResponse);
    creditCard.account =
        await AccountService.findById(creditCardResponse['account_id']);
    creditCard.brand =
        await CardBrandService.findById(creditCardResponse['brand_id']);

    return creditCard;
  }

  static Future<List<CreditCard>> findAll() async {
    List<Map<String, dynamic>> creditCardResponse =
        await CreditCardRepository.findAll();

    List<CreditCard> creditCards = [];
    for (Map<String, dynamic> creditCardItem in creditCardResponse) {
      CreditCard creditCard = CreditCard.fromMap(creditCardItem);
      creditCard.account =
          await AccountService.findById(creditCardItem['account_id']);
      creditCard.brand =
          await CardBrandService.findById(creditCardItem['brand_id']);

      creditCards.add(creditCard);
    }

    return creditCards;
  }
}

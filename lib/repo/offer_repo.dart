import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import '../screens/home/models/offer.dart';

class OfferRepository {
  static Future<List<Offer>> getOffers() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      Offer(
        id: '1',
        title: tr('offer_electronics_title'),
        imageUrl: 'https://images.unsplash.com/photo-1607082349566-187342175e2f?q=80&w=2940&auto=format&fit=crop',
        subtitle: tr('offer_electronics_subtitle'),
      ),
      Offer(
        id: '2',
        title: tr('offer_buy_one_get_one_title'),
        imageUrl: 'https://images.unsplash.com/photo-1607082349566-187342175e2f?q=80&w=2940&auto=format&fit=crop',
        subtitle: tr('offer_buy_one_get_one_subtitle'),
      ),
      Offer(
        id: '3',
        title: tr('offer_flash_sale_title'),
        imageUrl: 'https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?q=80&w=2940&auto=format&fit=crop',
        subtitle: tr('offer_flash_sale_subtitle'),
      ),
      Offer(
        id: '4',
        title: tr('offer_clothing_title'),
        imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=2940&auto=format&fit=crop',
        subtitle: tr('offer_clothing_subtitle'),
      ),
      Offer(
        id: '5',
        title: tr('offer_new_arrivals_title'),
        imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=2940&auto=format&fit=crop',
        subtitle: tr('offer_new_arrivals_subtitle'),
      ),
    ];
  }
}
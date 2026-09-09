import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/monetisation/domain/marketplace_engine.dart';
import 'package:fitkarma/features/monetisation/domain/marketplace_models.dart';
import 'package:fitkarma/features/monetisation/presentation/providers/marketplace_provider.dart';

void main() {
  group('MarketplaceEngine Deterministic Tests', () {
    const engine = MarketplaceEngine();
    final catalog = MarketplaceEngine.sampleCatalog();

    test('Catalog contains rich Pan-Indian verified offerings', () {
      expect(catalog.length, greaterThanOrEqualTo(5));
      final featured = catalog.where((l) => l.isFeatured).toList();
      expect(featured.isNotEmpty, isTrue);
    });

    test('Filters listings by coach specialty accurately', () {
      const filter = MarketplaceFilter(specialty: CoachSpecialty.ayurvedicVaidya);
      final filtered = engine.filterListings(listings: catalog, filter: filter);

      expect(filtered.isNotEmpty, isTrue);
      expect(filtered.every((l) => l.specialty == CoachSpecialty.ayurvedicVaidya), isTrue);
    });

    test('Filters listings by listing type accurately', () {
      const filter = MarketplaceFilter(type: ListingType.oneOnOneConsultation);
      final filtered = engine.filterListings(listings: catalog, filter: filter);

      expect(filtered.isNotEmpty, isTrue);
      expect(filtered.every((l) => l.type == ListingType.oneOnOneConsultation), isTrue);
    });

    test('Filters listings by case-insensitive search query', () {
      const filter = MarketplaceFilter(searchQuery: 'pcos');
      final filtered = engine.filterListings(listings: catalog, filter: filter);

      expect(filtered.isNotEmpty, isTrue);
      expect(filtered.first.title.toLowerCase(), contains('pcos'));
    });

    test('Calculates 80/20 creator revenue split accurately', () {
      final split = engine.calculateRevenueSplit(priceInr: 2499);
      // 2499 * 0.20 = 500; Coach = 1999
      expect(split.amountPaidInr, equals(2499));
      expect(split.platformFeeInr, equals(500));
      expect(split.coachPayoutInr, equals(1999));
      expect(split.coachPayoutInr + split.platformFeeInr, equals(2499));
    });

    test('Creates valid order record with revenue breakdown', () {
      final listing = catalog.first;
      final testTime = DateTime(2026, 9, 9, 12, 0);

      final order = engine.createOrder(
        userId: 'user_test_buyer',
        listing: listing,
        timestamp: testTime,
      );

      expect(order.userId, equals('user_test_buyer'));
      expect(order.listingId, equals(listing.listingId));
      expect(order.amountPaidInr, equals(listing.priceInr));
      expect(order.status, equals('active'));
      expect(order.purchasedAt, equals(testTime));
    });
  });

  group('Marketplace StateNotifier Provider Tests', () {
    test('StateNotifier filters catalog and processes purchases', () async {
      final notifier = MarketplaceNotifier();
      expect(notifier.state.catalog.isNotEmpty, isTrue);
      expect(notifier.state.userOrders.isEmpty, isTrue);

      notifier.setSpecialty(CoachSpecialty.hypertrophyStrength);
      expect(notifier.state.filter.specialty, equals(CoachSpecialty.hypertrophyStrength));
      expect(notifier.state.filteredListings.every((l) => l.specialty == CoachSpecialty.hypertrophyStrength), isTrue);

      notifier.setSearchQuery('Vikram');
      expect(notifier.state.filteredListings.length, equals(1));

      final listing = notifier.state.filteredListings.first;
      await notifier.purchaseListing(listing);

      expect(notifier.state.userOrders.length, equals(1));
      expect(notifier.state.userOrders.first.listingId, equals(listing.listingId));
      expect(notifier.state.successMessage, contains('Successfully enrolled'));

      notifier.resetFilters();
      expect(notifier.state.filter.specialty, isNull);
      expect(notifier.state.filteredListings.length, equals(notifier.state.catalog.length));
    });
  });
}

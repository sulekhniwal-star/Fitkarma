import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/marketplace_engine.dart';
import '../../domain/marketplace_models.dart';

/// State of the Creator & Coach Marketplace
class MarketplaceState {
  final List<MarketplaceListing> catalog;
  final List<MarketplaceListing> filteredListings;
  final MarketplaceFilter filter;
  final List<MarketplaceOrder> userOrders;
  final MarketplaceListing? selectedListing;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const MarketplaceState({
    required this.catalog,
    required this.filteredListings,
    required this.filter,
    required this.userOrders,
    this.selectedListing,
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  MarketplaceState copyWith({
    List<MarketplaceListing>? catalog,
    List<MarketplaceListing>? filteredListings,
    MarketplaceFilter? filter,
    List<MarketplaceOrder>? userOrders,
    MarketplaceListing? selectedListing,
    bool clearSelectedListing = false,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return MarketplaceState(
      catalog: catalog ?? this.catalog,
      filteredListings: filteredListings ?? this.filteredListings,
      filter: filter ?? this.filter,
      userOrders: userOrders ?? this.userOrders,
      selectedListing: clearSelectedListing
          ? null
          : (selectedListing ?? this.selectedListing),
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

final marketplaceProvider =
    StateNotifierProvider<MarketplaceNotifier, MarketplaceState>((ref) {
  return MarketplaceNotifier();
});

class MarketplaceNotifier extends StateNotifier<MarketplaceState> {
  MarketplaceNotifier() : super(_buildInitialState());

  static const MarketplaceEngine _engine = MarketplaceEngine();

  static MarketplaceState _buildInitialState() {
    final catalog = MarketplaceEngine.sampleCatalog();
    const initialFilter = MarketplaceFilter();
    final filtered =
        _engine.filterListings(listings: catalog, filter: initialFilter);

    return MarketplaceState(
      catalog: catalog,
      filteredListings: filtered,
      filter: initialFilter,
      userOrders: const [],
    );
  }

  void _applyFilters(MarketplaceFilter filter) {
    final filtered =
        _engine.filterListings(listings: state.catalog, filter: filter);
    state = state.copyWith(filter: filter, filteredListings: filtered);
  }

  void setSearchQuery(String query) {
    _applyFilters(state.filter.copyWith(searchQuery: query));
  }

  void setSpecialty(CoachSpecialty? specialty) {
    if (specialty == null) {
      _applyFilters(state.filter.copyWith(clearSpecialty: true));
    } else {
      _applyFilters(state.filter.copyWith(specialty: specialty));
    }
  }

  void setListingType(ListingType? type) {
    if (type == null) {
      _applyFilters(state.filter.copyWith(clearType: true));
    } else {
      _applyFilters(state.filter.copyWith(type: type));
    }
  }

  void toggleVerifiedOnly(bool onlyVerified) {
    _applyFilters(state.filter.copyWith(onlyVerified: onlyVerified));
  }

  void resetFilters() {
    _applyFilters(const MarketplaceFilter());
  }

  void selectListing(MarketplaceListing? listing) {
    state = state.copyWith(
        selectedListing: listing, clearSelectedListing: listing == null);
  }

  /// Completes purchase & creates order
  Future<void> purchaseListing(MarketplaceListing listing) async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, successMessage: null);

    // Simulate verified checkout
    await Future.delayed(const Duration(milliseconds: 300));

    final order = _engine.createOrder(
      userId: 'user_fitkarma_local',
      listing: listing,
    );

    final updatedOrders = List<MarketplaceOrder>.from(state.userOrders)
      ..insert(0, order);

    state = state.copyWith(
      userOrders: updatedOrders,
      isLoading: false,
      successMessage: 'Successfully enrolled in ${listing.title}!',
    );
  }
}

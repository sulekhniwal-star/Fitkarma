// §P16-E Grocery Checkout Provider & State Management
// Cross-reference: §P16-E in Fitkarma_documentation.md

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/grocery_vendor_adapter.dart';
import '../models/grocery_models.dart';

class GroceryCheckoutState {
  final List<GroceryVendorAdapter> adapters;
  final GroceryVendorAdapter selectedAdapter;
  final Uri? lastGeneratedDeepLink;
  final bool isCheckingOut;
  final String? checkoutMessage;

  const GroceryCheckoutState({
    required this.adapters,
    required this.selectedAdapter,
    this.lastGeneratedDeepLink,
    this.isCheckingOut = false,
    this.checkoutMessage,
  });

  GroceryCheckoutState copyWith({
    List<GroceryVendorAdapter>? adapters,
    GroceryVendorAdapter? selectedAdapter,
    Uri? lastGeneratedDeepLink,
    bool? isCheckingOut,
    String? checkoutMessage,
  }) {
    return GroceryCheckoutState(
      adapters: adapters ?? this.adapters,
      selectedAdapter: selectedAdapter ?? this.selectedAdapter,
      lastGeneratedDeepLink:
          lastGeneratedDeepLink ?? this.lastGeneratedDeepLink,
      isCheckingOut: isCheckingOut ?? this.isCheckingOut,
      checkoutMessage: checkoutMessage ?? this.checkoutMessage,
    );
  }
}

class GroceryCheckoutNotifier extends StateNotifier<GroceryCheckoutState> {
  final GroceryCheckoutService _service;

  GroceryCheckoutNotifier([GroceryCheckoutService? service])
      : _service = service ?? const GroceryCheckoutService(),
        super(GroceryCheckoutState(
          adapters: (service ?? const GroceryCheckoutService()).supportedAdapters,
          selectedAdapter: (service ?? const GroceryCheckoutService()).supportedAdapters.first,
        ));

  void selectAdapter(GroceryVendorAdapter adapter) {
    state = state.copyWith(selectedAdapter: adapter);
  }

  Future<Uri> generateCheckoutDeepLink(List<GroceryItem> items) async {
    state = state.copyWith(isCheckingOut: true);
    final link = await state.selectedAdapter.buildCheckoutDeepLink(items);
    state = state.copyWith(
      isCheckingOut: false,
      lastGeneratedDeepLink: link,
      checkoutMessage: 'Deep link generated for ${state.selectedAdapter.vendorName}',
    );
    return link;
  }
}

final groceryCheckoutServiceProvider =
    Provider<GroceryCheckoutService>((ref) => const GroceryCheckoutService());

final groceryCheckoutProvider =
    StateNotifierProvider<GroceryCheckoutNotifier, GroceryCheckoutState>((ref) {
  final service = ref.watch(groceryCheckoutServiceProvider);
  return GroceryCheckoutNotifier(service);
});

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/grocery_vendor_engine.dart';
import '../domain/grocery_vendor_models.dart';

@immutable
class GroceryVendorState {
  final List<VendorCartItem> items;
  final GroceryVendorCheckoutPayload payload;
  final GroceryVendorType selectedVendor;
  final bool isVegetarian;
  final bool includeAyurvedicPantry;
  final String pincode;
  final String? statusMessage;

  const GroceryVendorState({
    required this.items,
    required this.payload,
    required this.selectedVendor,
    required this.isVegetarian,
    required this.includeAyurvedicPantry,
    required this.pincode,
    this.statusMessage,
  });

  GroceryVendorState copyWith({
    List<VendorCartItem>? items,
    GroceryVendorCheckoutPayload? payload,
    GroceryVendorType? selectedVendor,
    bool? isVegetarian,
    bool? includeAyurvedicPantry,
    String? pincode,
    String? statusMessage,
  }) {
    return GroceryVendorState(
      items: items ?? this.items,
      payload: payload ?? this.payload,
      selectedVendor: selectedVendor ?? this.selectedVendor,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      includeAyurvedicPantry: includeAyurvedicPantry ?? this.includeAyurvedicPantry,
      pincode: pincode ?? this.pincode,
      statusMessage: statusMessage,
    );
  }
}

final groceryVendorProvider =
    StateNotifierProvider<GroceryVendorNotifier, GroceryVendorState>((ref) {
  return GroceryVendorNotifier();
});

class GroceryVendorNotifier extends StateNotifier<GroceryVendorState> {
  GroceryVendorNotifier() : super(_buildInitialState());

  static GroceryVendorState _buildInitialState() {
    const defaultPincode = '110001';
    final initialItems = GroceryVendorEngine.generateDefaultCart(
      isVegetarian: true,
      includeAyurvedicPantry: true,
    );
    final initialPayload = GroceryVendorEngine.compileCheckoutPayload(
      items: initialItems,
      pincode: defaultPincode,
    );

    return GroceryVendorState(
      items: initialItems,
      payload: initialPayload,
      selectedVendor: GroceryVendorType.blinkit,
      isVegetarian: true,
      includeAyurvedicPantry: true,
      pincode: defaultPincode,
    );
  }

  void selectVendor(GroceryVendorType vendor) {
    state = state.copyWith(selectedVendor: vendor);
  }

  void toggleItem(String itemId) {
    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isChecked: !item.isChecked);
      }
      return item;
    }).toList();

    final newPayload = GroceryVendorEngine.compileCheckoutPayload(
      items: updatedItems,
      pincode: state.pincode,
    );

    state = state.copyWith(
      items: updatedItems,
      payload: newPayload,
    );
  }

  void setDietaryPreference(bool isVegetarian) {
    final items = GroceryVendorEngine.generateDefaultCart(
      isVegetarian: isVegetarian,
      includeAyurvedicPantry: state.includeAyurvedicPantry,
    );

    final payload = GroceryVendorEngine.compileCheckoutPayload(
      items: items,
      pincode: state.pincode,
    );

    state = state.copyWith(
      isVegetarian: isVegetarian,
      items: items,
      payload: payload,
      statusMessage: isVegetarian ? 'Switched to 100% शाकाहारी (Veg) items' : 'Non-veg protein staples added',
    );
  }

  void toggleAyurvedicPantry(bool include) {
    final items = GroceryVendorEngine.generateDefaultCart(
      isVegetarian: state.isVegetarian,
      includeAyurvedicPantry: include,
    );

    final payload = GroceryVendorEngine.compileCheckoutPayload(
      items: items,
      pincode: state.pincode,
    );

    state = state.copyWith(
      includeAyurvedicPantry: include,
      items: items,
      payload: payload,
      statusMessage: include ? 'Ayurvedic superfoods added to pantry list' : 'Removed Ayurvedic pantry items',
    );
  }

  void updatePincode(String pincode) {
    final payload = GroceryVendorEngine.compileCheckoutPayload(
      items: state.items,
      pincode: pincode,
    );

    state = state.copyWith(
      pincode: pincode,
      payload: payload,
      statusMessage: 'Updated delivery pincode: $pincode',
    );
  }

  VendorPriceQuote? get selectedVendorQuote {
    try {
      return state.payload.vendorQuotes.firstWhere(
        (quote) => quote.vendor == state.selectedVendor,
      );
    } catch (_) {
      return state.payload.vendorQuotes.isNotEmpty ? state.payload.vendorQuotes.first : null;
    }
  }
}

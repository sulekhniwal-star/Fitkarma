import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/growth_engine.dart';
import '../models/growth_model.dart';

class GrowthState {
  final bool isWhatsappOptedIn;
  final VernacularLanguage selectedLanguage;
  final AbhaAccount abhaAccount;
  final List<GroceryVendorItem> vendorAdapters;

  const GrowthState({
    this.isWhatsappOptedIn = false, // Off by default
    this.selectedLanguage = VernacularLanguage.hindi,
    this.abhaAccount = const AbhaAccount(
      abhaHealthId: 'enc_abha_984210',
      abhaNumber: '91-8492-1049-2810',
      isLinked: true,
      fhirLiteExportUrl: 'https://api.fitkarma.in/fhir/export/v1',
    ),
    this.vendorAdapters = const [
      GroceryVendorItem(partnerName: 'Blinkit Quick-Cart', cartExportUrl: 'blinkit://cart/export'),
      GroceryVendorItem(partnerName: 'BigBasket Smart Basket', cartExportUrl: 'bigbasket://cart/export'),
    ],
  });

  GrowthState copyWith({
    bool? isWhatsappOptedIn,
    VernacularLanguage? selectedLanguage,
    AbhaAccount? abhaAccount,
    List<GroceryVendorItem>? vendorAdapters,
  }) {
    return GrowthState(
      isWhatsappOptedIn: isWhatsappOptedIn ?? this.isWhatsappOptedIn,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      abhaAccount: abhaAccount ?? this.abhaAccount,
      vendorAdapters: vendorAdapters ?? this.vendorAdapters,
    );
  }
}

class GrowthNotifier extends StateNotifier<GrowthState> {
  final GrowthEngine engine;

  GrowthNotifier(this.engine) : super(const GrowthState());

  void toggleWhatsappOptIn() {
    state = state.copyWith(isWhatsappOptedIn: !state.isWhatsappOptedIn);
  }

  void selectLanguage(VernacularLanguage lang) {
    state = state.copyWith(selectedLanguage: lang);
  }
}

final growthProvider = StateNotifierProvider<GrowthNotifier, GrowthState>((ref) {
  return GrowthNotifier(const GrowthEngine());
});

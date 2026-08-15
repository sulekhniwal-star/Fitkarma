// §P13-B Payment Webhook Split-Settlement & Double-Entry Ledger (Pure Dart, No AI)
// Cross-reference: §P13-B, ADR-040 in Fitkarma_documentation.md

import 'dart:convert';
import 'dart:typed_data';
import '../../features/premium/models/creator_marketplace_models.dart';

/// Pure Dart SHA-256 and HMAC implementation for WebhookSignatureVerifier
class _Sha256Internal {
  static const List<int> _k = [
    0x428a2f98,
    0x71374491,
    0xb5c0fbcf,
    0xe9b5dba5,
    0x3956c25b,
    0x59f111f1,
    0x923f82a4,
    0xab1c5ed5,
    0xd807aa98,
    0x12835b01,
    0x243185be,
    0x550c7dc3,
    0x72be5d74,
    0x80deb1fe,
    0x9bdc06a7,
    0xc19bf174,
    0xe49b69c1,
    0xefbe4786,
    0x0fc19dc6,
    0x240ca1cc,
    0x2de92c6f,
    0x4a7484aa,
    0x5cb0a9dc,
    0x76f988da,
    0x983e5152,
    0xa831c66d,
    0xb00327c8,
    0xbf597fc7,
    0xc6e00bf3,
    0xd5a79147,
    0x06ca6351,
    0x14292967,
    0x27b70a85,
    0x2e1b2138,
    0x4d2c6dfc,
    0x53380d13,
    0x650a7354,
    0x766a0abb,
    0x81c2c92e,
    0x92722c85,
    0xa2bfe8a1,
    0xa81a664b,
    0xc24b8b70,
    0xc76c51a3,
    0xd192e819,
    0xd6990624,
    0xf40e3585,
    0x106aa070,
    0x19a4c116,
    0x1e376c08,
    0x2748774c,
    0x34b0bcb5,
    0x391c0cb3,
    0x4ed8aa4a,
    0x5b9cca4f,
    0x682e6ff3,
    0x748f82ee,
    0x78a5636f,
    0x84c87814,
    0x8cc70208,
    0x90befffa,
    0xa4506ceb,
    0xbef9a3f7,
    0xc67178f2
  ];

  static Uint8List hash(List<int> bytes) {
    var h0 = 0x6a09e667;
    var h1 = 0xbb67ae85;
    var h2 = 0x3c6ef372;
    var h3 = 0xa54ff53a;
    var h4 = 0x510e527f;
    var h5 = 0x9b05688c;
    var h6 = 0x1f83d9ab;
    var h7 = 0x5be0cd19;

    final bitLength = bytes.length * 8;
    final padded = <int>[...bytes, 0x80];
    while ((padded.length + 8) % 64 != 0) {
      padded.add(0);
    }
    for (var i = 7; i >= 0; i--) {
      padded.add((bitLength >> (i * 8)) & 0xff);
    }

    final words = List<int>.filled(64, 0);
    for (var i = 0; i < padded.length; i += 64) {
      for (var j = 0; j < 16; j++) {
        words[j] = (padded[i + j * 4] << 24) |
            (padded[i + j * 4 + 1] << 16) |
            (padded[i + j * 4 + 2] << 8) |
            padded[i + j * 4 + 3];
      }
      for (var j = 16; j < 64; j++) {
        final s0 = _rotr(words[j - 15], 7) ^
            _rotr(words[j - 15], 18) ^
            (words[j - 15] >>> 3);
        final s1 = _rotr(words[j - 2], 17) ^
            _rotr(words[j - 2], 19) ^
            (words[j - 2] >>> 10);
        words[j] = (words[j - 16] + s0 + words[j - 7] + s1) & 0xffffffff;
      }

      var a = h0, b = h1, c = h2, d = h3, e = h4, f = h5, g = h6, h = h7;

      for (var j = 0; j < 64; j++) {
        final s1 = _rotr(e, 6) ^ _rotr(e, 11) ^ _rotr(e, 25);
        final ch = (e & f) ^ (~e & g);
        final temp1 = (h + s1 + ch + _k[j] + words[j]) & 0xffffffff;
        final s0 = _rotr(a, 2) ^ _rotr(a, 13) ^ _rotr(a, 22);
        final maj = (a & b) ^ (a & c) ^ (b & c);
        final temp2 = (s0 + maj) & 0xffffffff;

        h = g;
        g = f;
        f = e;
        e = (d + temp1) & 0xffffffff;
        d = c;
        c = b;
        b = a;
        a = (temp1 + temp2) & 0xffffffff;
      }

      h0 = (h0 + a) & 0xffffffff;
      h1 = (h1 + b) & 0xffffffff;
      h2 = (h2 + c) & 0xffffffff;
      h3 = (h3 + d) & 0xffffffff;
      h4 = (h4 + e) & 0xffffffff;
      h5 = (h5 + f) & 0xffffffff;
      h6 = (h6 + g) & 0xffffffff;
      h7 = (h7 + h) & 0xffffffff;
    }

    final result = Uint8List(32);
    final view = ByteData.view(result.buffer);
    view.setUint32(0, h0);
    view.setUint32(4, h1);
    view.setUint32(8, h2);
    view.setUint32(12, h3);
    view.setUint32(16, h4);
    view.setUint32(20, h5);
    view.setUint32(24, h6);
    view.setUint32(28, h7);
    return result;
  }

  static int _rotr(int x, int n) => ((x >>> n) | (x << (32 - n))) & 0xffffffff;

  static Uint8List hmacSha256(List<int> key, List<int> message) {
    var keyBytes = key;
    if (keyBytes.length > 64) {
      keyBytes = hash(keyBytes);
    }
    if (keyBytes.length < 64) {
      final paddedKey = Uint8List(64);
      paddedKey.setRange(0, keyBytes.length, keyBytes);
      keyBytes = paddedKey;
    }

    final oKeyPad = Uint8List(64);
    final iKeyPad = Uint8List(64);
    for (var i = 0; i < 64; i++) {
      oKeyPad[i] = keyBytes[i] ^ 0x5c;
      iKeyPad[i] = keyBytes[i] ^ 0x36;
    }

    final innerHash = hash([...iKeyPad, ...message]);
    return hash([...oKeyPad, ...innerHash]);
  }
}

/// Webhook Cryptographic Signature Verifier (§P13-B)
class WebhookSignatureVerifier {
  const WebhookSignatureVerifier();

  /// Securely validates Razorpay webhook cryptographic signatures to block spoofing
  bool verifyRazorpaySignature({
    required String payload,
    required String signatureHeader,
    required String secret,
  }) {
    if (signatureHeader.isEmpty || secret.isEmpty) return false;

    try {
      final hmac = _Sha256Internal.hmacSha256(
        utf8.encode(secret),
        utf8.encode(payload),
      );
      final computedSignature =
          hmac.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

      // Secure constant-time string comparison to defend against timing side-channel attacks
      return _secureCompare(computedSignature, signatureHeader);
    } catch (_) {
      return false;
    }
  }

  bool _secureCompare(String a, String b) {
    if (a.length != b.length) return false;
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}

/// Marketplace Matchmaking Engine (§P13-B)
class CoachMatchingEngine {
  const CoachMatchingEngine();

  List<CreatorProfile> match({
    required UserProfile client,
    required List<CreatorProfile> allCoaches,
  }) {
    final scored = allCoaches.map((coach) {
      double score = 0.0;

      // Match specialty to primary goals
      if ((client.goals.contains('weight_loss') ||
              client.goals.contains('muscle_building')) &&
          coach.specialties.contains(CoachSpecialty.muscleBuilding)) {
        score += 30.0;
      }
      if (client.goals.contains('pcos') &&
          coach.specialties.contains(CoachSpecialty.pcosManagement)) {
        score += 50.0;
      }
      if (client.goals.contains('diabetes') &&
          coach.specialties.contains(CoachSpecialty.diabeticReversal)) {
        score += 45.0;
      }
      if (client.goals.contains('running') &&
          coach.specialties.contains(CoachSpecialty.runningMarathon)) {
        score += 40.0;
      }

      // Verified credentials bonus
      if (coach.isVerified) {
        score += 20.0;
      }

      // Client rating weighting
      score += coach.averageRating * 10.0;

      return MapEntry(coach, score);
    }).toList();

    scored.sort((a, b) => b.value.compareTo(a.value));
    return scored.map((entry) => entry.key).toList();
  }
}

enum LedgerAccountType {
  escrowLiability, // Held for creator during dispute window (80% net)
  creatorPayable, // Cleared and due to the creator
  platformRevenue, // Platform's 20% share
  tcsLiability, // 1% Tax Collected at Source (Sec 52 CGST Act)
  tdsLiability, // 1% Tax Deducted at Source (Sec 194-O Income Tax)
  gstExpense, // 18% GST on platform fee
  cashAsset, // Gross incoming funds
}

class LedgerEntry {
  final String entryId;
  final String txId;
  final LedgerAccountType accountType;
  final double debit;
  final double credit;
  final DateTime timestamp;
  final String memo;

  const LedgerEntry({
    required this.entryId,
    required this.txId,
    required this.accountType,
    required this.debit,
    required this.credit,
    required this.timestamp,
    required this.memo,
  });
}

/// Double-Entry Ledger Engine with Indian Compliance (§P13-B, Pure Dart)
class DoubleEntryLedgerEngine {
  final List<LedgerEntry> _ledger = [];

  List<LedgerEntry> get ledgerEntries => List.unmodifiable(_ledger);

  /// Processes coaching package sales and executes GST, TCS, and TDS double-entry allocations.
  /// Gross Coaching Fee: 100% (e.g. ₹1,000)
  /// - 80% Creator Escrow Allocation (₹800)
  /// - 20% Platform Fee Commission (₹200)
  /// - 18% GST on Platform Fee (18% of ₹200 = ₹36)
  /// - 1% TCS Deducted from Creator Escrow (1% of ₹1,000 = ₹10)
  /// - 1% TDS Deducted from Creator Escrow (1% of ₹1,000 = ₹10)
  void recordCoachingPurchase({
    required String txId,
    required double grossAmountInr,
    required String creatorId,
  }) {
    final timestamp = DateTime.now();

    // 1. Calculate transaction fee divisions
    final platformCommission = grossAmountInr * 0.20;
    final creatorGross = grossAmountInr * 0.80;

    // 2. Tax calculations (GST on platform commission, TCS/TDS on creator gross)
    final platformGst = platformCommission * 0.18;
    final tcsDeduction = grossAmountInr * 0.01;
    final tdsDeduction = grossAmountInr * 0.01;

    final creatorNetEscrow = creatorGross - tcsDeduction - tdsDeduction;

    // --- DOUBLE ENTRY JOURNAL TRANSACTIONS ---

    // JOURNAL ENTRY 1: Ingest Gross Funds & Allocate Creator Escrow + Platform Fee
    final entries = [
      LedgerEntry(
        entryId: '${txId}_cash_in',
        txId: txId,
        accountType: LedgerAccountType.cashAsset,
        debit: grossAmountInr,
        credit: 0.0,
        timestamp: timestamp,
        memo: 'Gross payment capture from client',
      ),
      LedgerEntry(
        entryId: '${txId}_escrow_alloc',
        txId: txId,
        accountType: LedgerAccountType.escrowLiability,
        debit: 0.0,
        credit: creatorNetEscrow,
        timestamp: timestamp,
        memo: 'Creator net share allocated to escrow',
      ),
      LedgerEntry(
        entryId: '${txId}_platform_fee',
        txId: txId,
        accountType: LedgerAccountType.platformRevenue,
        debit: 0.0,
        credit: platformCommission,
        timestamp: timestamp,
        memo: 'Platform 20% commission fee',
      ),

      // JOURNAL ENTRY 2: Record Tax Deductions
      LedgerEntry(
        entryId: '${txId}_tcs_withhold',
        txId: txId,
        accountType: LedgerAccountType.tcsLiability,
        debit: 0.0,
        credit: tcsDeduction,
        timestamp: timestamp,
        memo: '1% TCS withheld from creator escrow',
      ),
      LedgerEntry(
        entryId: '${txId}_tds_withhold',
        txId: txId,
        accountType: LedgerAccountType.tdsLiability,
        debit: 0.0,
        credit: tdsDeduction,
        timestamp: timestamp,
        memo: '1% TDS withheld from creator escrow',
      ),

      // JOURNAL ENTRY 3: Record Platform GST Expense
      LedgerEntry(
        entryId: '${txId}_platform_gst',
        txId: txId,
        accountType: LedgerAccountType.gstExpense,
        debit: platformGst,
        credit: 0.0,
        timestamp: timestamp,
        memo: '18% GST accrued on platform commission',
      ),
      LedgerEntry(
        entryId: '${txId}_platform_gst_offset',
        txId: txId,
        accountType: LedgerAccountType.platformRevenue,
        debit: 0.0,
        credit:
            platformGst, // platformRevenue credit offset to balance GST debit
        timestamp: timestamp,
        memo: 'Platform revenue GST offset',
      ),
    ];

    // Enforce matching transaction balancing before writing to ledger
    _verifyAndWriteEntries(entries);
  }

  /// Releases funds from Escrow to Payable after 7-day dispute window clears
  void clearEscrowToPayable({
    required String txId,
    required double netEscrowAmount,
  }) {
    final timestamp = DateTime.now();

    final entries = [
      LedgerEntry(
        entryId: '${txId}_clear_escrow',
        txId: txId,
        accountType: LedgerAccountType.escrowLiability,
        debit: netEscrowAmount,
        credit: 0.0,
        timestamp: timestamp,
        memo: 'Release cleared escrow funds',
      ),
      LedgerEntry(
        entryId: '${txId}_credit_payable',
        txId: txId,
        accountType: LedgerAccountType.creatorPayable,
        debit: 0.0,
        credit: netEscrowAmount,
        timestamp: timestamp,
        memo: 'Credit cleared funds to creator payable balance',
      ),
    ];

    _verifyAndWriteEntries(entries);
  }

  /// Processes refund in case of 7-day no-contact dispute
  void processEscrowRefund({
    required String txId,
    required double netEscrowAmount,
    required double grossAmountInr,
  }) {
    final timestamp = DateTime.now();

    final platformCommission = grossAmountInr * 0.20;
    final platformGst = platformCommission * 0.18;
    final tcsDeduction = grossAmountInr * 0.01;
    final tdsDeduction = grossAmountInr * 0.01;

    final entries = [
      LedgerEntry(
        entryId: '${txId}_refund_cash_out',
        txId: txId,
        accountType: LedgerAccountType.cashAsset,
        debit: 0.0,
        credit: grossAmountInr,
        timestamp: timestamp,
        memo: 'Refund cash out to client',
      ),
      LedgerEntry(
        entryId: '${txId}_refund_escrow',
        txId: txId,
        accountType: LedgerAccountType.escrowLiability,
        debit: netEscrowAmount,
        credit: 0.0,
        timestamp: timestamp,
        memo: 'Revert creator escrow liability',
      ),
      LedgerEntry(
        entryId: '${txId}_refund_platform_fee',
        txId: txId,
        accountType: LedgerAccountType.platformRevenue,
        debit: platformCommission,
        credit: 0.0,
        timestamp: timestamp,
        memo: 'Revert platform commission',
      ),
      LedgerEntry(
        entryId: '${txId}_refund_tcs',
        txId: txId,
        accountType: LedgerAccountType.tcsLiability,
        debit: tcsDeduction,
        credit: 0.0,
        timestamp: timestamp,
        memo: 'Revert TCS liability',
      ),
      LedgerEntry(
        entryId: '${txId}_refund_tds',
        txId: txId,
        accountType: LedgerAccountType.tdsLiability,
        debit: tdsDeduction,
        credit: 0.0,
        timestamp: timestamp,
        memo: 'Revert TDS liability',
      ),
      LedgerEntry(
        entryId: '${txId}_refund_gst_expense',
        txId: txId,
        accountType: LedgerAccountType.gstExpense,
        debit: 0.0,
        credit: platformGst,
        timestamp: timestamp,
        memo: 'Revert GST expense',
      ),
      LedgerEntry(
        entryId: '${txId}_refund_gst_offset',
        txId: txId,
        accountType: LedgerAccountType.platformRevenue,
        debit: platformGst,
        credit: 0.0,
        timestamp: timestamp,
        memo: 'Revert GST offset',
      ),
    ];

    _verifyAndWriteEntries(entries);
  }

  /// Calculates current balance of a specific account by summing ledger debits vs credits
  double sumAccountBalance(LedgerAccountType accountType) {
    double totalDebits = 0.0;
    double totalCredits = 0.0;

    for (final entry in _ledger) {
      if (entry.accountType == accountType) {
        totalDebits += entry.debit;
        totalCredits += entry.credit;
      }
    }

    // Asset and Expense accounts increase with Debit. Liability and Revenue accounts increase with Credit.
    if (accountType == LedgerAccountType.cashAsset ||
        accountType == LedgerAccountType.gstExpense) {
      return totalDebits - totalCredits;
    } else {
      return totalCredits - totalDebits;
    }
  }

  void _verifyAndWriteEntries(List<LedgerEntry> entries) {
    double sumDebits = 0.0;
    double sumCredits = 0.0;

    for (final entry in entries) {
      sumDebits += entry.debit;
      sumCredits += entry.credit;
    }

    // To prevent ledger corruption, debits must mathematically balance credits
    if ((sumDebits - sumCredits).abs() > 0.0001) {
      throw Exception(
          'Ledger integrity error: Unbalanced journal entry. Debits: $sumDebits, Credits: $sumCredits');
    }

    _ledger.addAll(entries);
  }
}

/// §P16-C ABHA Health ID Controller & Riverpod Notifier

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'abha_models.dart';
import 'abha_service.dart';

class AbhaState {
  const AbhaState({
    this.account,
    this.sharingMode = DoctorSharingMode.passcodePdf, // PDF Export REMAINS DEFAULT (§P16-C spec)
    this.isLinking = false,
    this.txnId,
    this.isOtpSent = false,
    this.successMessage,
    this.errorMessage,
  });

  final AbhaAccount? account;
  final DoctorSharingMode sharingMode;
  final bool isLinking;
  final String? txnId;
  final bool isOtpSent;
  final String? successMessage;
  final String? errorMessage;

  AbhaState copyWith({
    AbhaAccount? account,
    DoctorSharingMode? sharingMode,
    bool? isLinking,
    String? txnId,
    bool? isOtpSent,
    String? successMessage,
    String? errorMessage,
    bool clearMessages = false,
    bool clearAccount = false,
  }) {
    return AbhaState(
      account: clearAccount ? null : (account ?? this.account),
      sharingMode: sharingMode ?? this.sharingMode,
      isLinking: isLinking ?? this.isLinking,
      txnId: txnId ?? this.txnId,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AbhaNotifier extends Notifier<AbhaState> {
  late final AbhaService _service;

  @override
  AbhaState build() {
    _service = const AbhaService();
    // Default sharing mode is passcode PDF (remains default per §P16-C spec)
    return const AbhaState(sharingMode: DoctorSharingMode.passcodePdf);
  }

  Future<void> requestOtp(String abhaNumberOrAddress) async {
    state = state.copyWith(isLinking: true, clearMessages: true);
    try {
      final txnId = await _service.requestOtp(abhaNumberOrAddress);
      state = state.copyWith(
        isLinking: false,
        txnId: txnId,
        isOtpSent: true,
        successMessage: '📩 6-digit OTP sent to NDHM mobile number.',
      );
    } catch (e) {
      state = state.copyWith(
        isLinking: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> submitOtp({required String otp, String? abhaHealthId}) async {
    if (state.txnId == null) return;
    state = state.copyWith(isLinking: true, clearMessages: true);
    try {
      final account = await _service.verifyOtpAndLink(
        txnId: state.txnId!,
        otpCode: otp,
        abhaHealthId: abhaHealthId ?? '14-8899-1234-5678',
      );
      state = state.copyWith(
        isLinking: false,
        account: account,
        isOtpSent: false,
        successMessage: '🏥 ABHA Health ID linked & verified successfully (${account.abhaHealthId})!',
      );
    } catch (e) {
      state = state.copyWith(
        isLinking: false,
        errorMessage: e.toString(),
      );
    }
  }

  void setSharingMode(DoctorSharingMode mode) {
    state = state.copyWith(
      sharingMode: mode,
      successMessage: mode == DoctorSharingMode.passcodePdf
          ? '📄 Doctor Sharing set to Passcode PDF Export (Default).'
          : '🏥 Doctor Sharing set to FHIR-lite ABHA Bundle Mode.',
    );
  }

  void unlinkAbha() {
    state = state.copyWith(
      clearAccount: true,
      isOtpSent: false,
      txnId: null,
      sharingMode: DoctorSharingMode.passcodePdf,
      successMessage: 'ABHA Health ID unlinked successfully.',
    );
  }
}

final abhaProvider = NotifierProvider<AbhaNotifier, AbhaState>(
  AbhaNotifier.new,
);

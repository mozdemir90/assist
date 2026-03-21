// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reminderApiService)
final reminderApiServiceProvider = ReminderApiServiceProvider._();

final class ReminderApiServiceProvider
    extends
        $FunctionalProvider<
          ReminderApiService,
          ReminderApiService,
          ReminderApiService
        >
    with $Provider<ReminderApiService> {
  ReminderApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderApiServiceHash();

  @$internal
  @override
  $ProviderElement<ReminderApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReminderApiService create(Ref ref) {
    return reminderApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReminderApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReminderApiService>(value),
    );
  }
}

String _$reminderApiServiceHash() =>
    r'a29728c519d6bc93577429e6433635c247e0b627';

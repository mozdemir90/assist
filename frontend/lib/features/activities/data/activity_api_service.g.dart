// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activityApiService)
final activityApiServiceProvider = ActivityApiServiceProvider._();

final class ActivityApiServiceProvider
    extends
        $FunctionalProvider<
          ActivityApiService,
          ActivityApiService,
          ActivityApiService
        >
    with $Provider<ActivityApiService> {
  ActivityApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityApiServiceHash();

  @$internal
  @override
  $ProviderElement<ActivityApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActivityApiService create(Ref ref) {
    return activityApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityApiService>(value),
    );
  }
}

String _$activityApiServiceHash() =>
    r'2f8484fb7f7c19f1c947ceb8e4152e78c72d66c1';

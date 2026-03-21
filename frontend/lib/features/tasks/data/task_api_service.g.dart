// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskApiService)
final taskApiServiceProvider = TaskApiServiceProvider._();

final class TaskApiServiceProvider
    extends $FunctionalProvider<TaskApiService, TaskApiService, TaskApiService>
    with $Provider<TaskApiService> {
  TaskApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskApiServiceHash();

  @$internal
  @override
  $ProviderElement<TaskApiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskApiService create(Ref ref) {
    return taskApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskApiService>(value),
    );
  }
}

String _$taskApiServiceHash() => r'71e2d76d47d149f0801842ff721d78757a85be4b';

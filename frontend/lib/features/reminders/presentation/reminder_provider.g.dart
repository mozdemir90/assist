// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReminderList)
final reminderListProvider = ReminderListProvider._();

final class ReminderListProvider
    extends $AsyncNotifierProvider<ReminderList, List<ReminderModel>> {
  ReminderListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderListHash();

  @$internal
  @override
  ReminderList create() => ReminderList();
}

String _$reminderListHash() => r'5757803f19ebcd4b54146179d5543fbc1944c7ae';

abstract class _$ReminderList extends $AsyncNotifier<List<ReminderModel>> {
  FutureOr<List<ReminderModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ReminderModel>>, List<ReminderModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ReminderModel>>, List<ReminderModel>>,
              AsyncValue<List<ReminderModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

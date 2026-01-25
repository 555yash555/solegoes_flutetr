// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for ChatRepository instance

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

/// Provider for ChatRepository instance

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  /// Provider for ChatRepository instance
  ChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'9e515e152cf26104a0e2afe976e106c279d10296';

/// Provider for ChatAccessService instance

@ProviderFor(chatAccessService)
final chatAccessServiceProvider = ChatAccessServiceProvider._();

/// Provider for ChatAccessService instance

final class ChatAccessServiceProvider
    extends
        $FunctionalProvider<
          ChatAccessService,
          ChatAccessService,
          ChatAccessService
        >
    with $Provider<ChatAccessService> {
  /// Provider for ChatAccessService instance
  ChatAccessServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatAccessServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatAccessServiceHash();

  @$internal
  @override
  $ProviderElement<ChatAccessService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatAccessService create(Ref ref) {
    return chatAccessService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatAccessService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatAccessService>(value),
    );
  }
}

String _$chatAccessServiceHash() => r'cff7d6841dbd5aaecb3c81f8345ba57a654a366f';

/// Provider to watch all chats for the current user

@ProviderFor(userChats)
final userChatsProvider = UserChatsFamily._();

/// Provider to watch all chats for the current user

final class UserChatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TripChat>>,
          List<TripChat>,
          Stream<List<TripChat>>
        >
    with $FutureModifier<List<TripChat>>, $StreamProvider<List<TripChat>> {
  /// Provider to watch all chats for the current user
  UserChatsProvider._({
    required UserChatsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userChatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userChatsHash();

  @override
  String toString() {
    return r'userChatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<TripChat>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TripChat>> create(Ref ref) {
    final argument = this.argument as String;
    return userChats(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserChatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userChatsHash() => r'65aac0eed7a43ee3dc67d3957faf867ce846022d';

/// Provider to watch all chats for the current user

final class UserChatsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<TripChat>>, String> {
  UserChatsFamily._()
    : super(
        retry: null,
        name: r'userChatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider to watch all chats for the current user

  UserChatsProvider call(String userId) =>
      UserChatsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userChatsProvider';
}

/// Provider to watch messages for a specific chat

@ProviderFor(chatMessages)
final chatMessagesProvider = ChatMessagesFamily._();

/// Provider to watch messages for a specific chat

final class ChatMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatMessage>>,
          List<ChatMessage>,
          Stream<List<ChatMessage>>
        >
    with
        $FutureModifier<List<ChatMessage>>,
        $StreamProvider<List<ChatMessage>> {
  /// Provider to watch messages for a specific chat
  ChatMessagesProvider._({
    required ChatMessagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatMessagesHash();

  @override
  String toString() {
    return r'chatMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ChatMessage>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatMessage>> create(Ref ref) {
    final argument = this.argument as String;
    return chatMessages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatMessagesHash() => r'9431c39be1122bfba8135d436ba67c965c2edfa5';

/// Provider to watch messages for a specific chat

final class ChatMessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ChatMessage>>, String> {
  ChatMessagesFamily._()
    : super(
        retry: null,
        name: r'chatMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider to watch messages for a specific chat

  ChatMessagesProvider call(String chatId) =>
      ChatMessagesProvider._(argument: chatId, from: this);

  @override
  String toString() => r'chatMessagesProvider';
}

/// Provider to get a chat by its chatId

@ProviderFor(chatById)
final chatByIdProvider = ChatByIdFamily._();

/// Provider to get a chat by its chatId

final class ChatByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<TripChat?>,
          TripChat?,
          FutureOr<TripChat?>
        >
    with $FutureModifier<TripChat?>, $FutureProvider<TripChat?> {
  /// Provider to get a chat by its chatId
  ChatByIdProvider._({
    required ChatByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatByIdHash();

  @override
  String toString() {
    return r'chatByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TripChat?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TripChat?> create(Ref ref) {
    final argument = this.argument as String;
    return chatById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatByIdHash() => r'2bf7fadd6e9cddcd30b01f458bb627d1ac7fad39';

/// Provider to get a chat by its chatId

final class ChatByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TripChat?>, String> {
  ChatByIdFamily._()
    : super(
        retry: null,
        name: r'chatByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider to get a chat by its chatId

  ChatByIdProvider call(String chatId) =>
      ChatByIdProvider._(argument: chatId, from: this);

  @override
  String toString() => r'chatByIdProvider';
}

/// Provider to get a chat for a specific trip

@ProviderFor(tripChat)
final tripChatProvider = TripChatFamily._();

/// Provider to get a chat for a specific trip

final class TripChatProvider
    extends
        $FunctionalProvider<
          AsyncValue<TripChat?>,
          TripChat?,
          FutureOr<TripChat?>
        >
    with $FutureModifier<TripChat?>, $FutureProvider<TripChat?> {
  /// Provider to get a chat for a specific trip
  TripChatProvider._({
    required TripChatFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tripChatProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tripChatHash();

  @override
  String toString() {
    return r'tripChatProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TripChat?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TripChat?> create(Ref ref) {
    final argument = this.argument as String;
    return tripChat(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TripChatProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tripChatHash() => r'3ac3fe8b013b81aa707527dd6354462150b282ab';

/// Provider to get a chat for a specific trip

final class TripChatFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TripChat?>, String> {
  TripChatFamily._()
    : super(
        retry: null,
        name: r'tripChatProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider to get a chat for a specific trip

  TripChatProvider call(String tripId) =>
      TripChatProvider._(argument: tripId, from: this);

  @override
  String toString() => r'tripChatProvider';
}

import 'package:either_dart/either.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Base class for [Bloc]s that fetches data from remote and/or local data sources.
abstract class BaseBloc<T, S> extends Bloc<T, S> {
  BaseBloc(super.initialState);

  /// Data fetching strategy that fetches only remote data. This strategy
  /// uses "either" pattern.
  ///
  /// See also: [strategyFetchRemoteOnlyTryCatch] for try-catch pattern.
  strategyFetchRemoteOnly<E, D>({
    required VoidCallback onLoading,
    required Future<Either<E, D>> Function() onFetchRemote,
    required Function(D? data, E? exception) onFinished,
  }) async {
    /// Loading.
    onLoading();

    /// Fetch remote data.
    var dataRemote = await onFetchRemote();

    await dataRemote.fold(
          (exception) async {
        /// If fail, return exception from remote fetch and local data if exist.
        await onFinished(null, exception);
      },
          (data) async {
        /// Return remote data.
        await onFinished(data, null);
      },
    );
  }

  /// Data fetching strategy that fetches only remote data. This strategy
  /// uses try-catch pattern.
  ///
  /// See also: [strategyFetchRemoteOnly] for "either" pattern.
  strategyFetchRemoteOnlyTryCatch<E, D>({
    required VoidCallback onLoading,
    required Future<D> Function() onFetchRemote,
    required Function(D? data, Object? exception, [StackTrace stackTrace])
    onFinished,
  }) async {
    try {
      /// Loading.
      onLoading();

      /// Fetch remote data.
      var data = await onFetchRemote();

      await onFinished(data, null);
    } catch (err, stack) {
      /// If fail, return exception from remote fetch and local data if exist.
      await onFinished(null, err, stack);
    }
  }

  /// Data fetching strategy that fetches remote data first, then if fail,
  /// try to fetch local data.
  strategyFetchRemoteFirstIfFailLocal<E, D>({
    required VoidCallback onLoading,
    required Future<Either<E, D>> Function() onFetchRemote,
    required Future<D?> Function() onFetchLocal,
    required Function(D? data, E? exception) onFinished,
    required Future<void> Function(D data) onSaveToLocal,
  }) async {
    /// Loading.
    onLoading();

    /// Fetch remote data.
    var dataRemote = await onFetchRemote();

    await dataRemote.fold(
          (exception) async {
        /// If fail, try fetch local data.
        var dataLocal = await onFetchLocal();

        /// Return exception from remote fetch and local data if exist.
        await onFinished(dataLocal, exception);
      },
          (data) async {
        /// Save remove data to local.
        await onSaveToLocal(data);

        /// Return remote data.
        await onFinished(data, null);
      },
    );
  }

  /// Data fetching strategy that fetches local data first, then try to fetch
  /// remote data.
  ///
  /// See also: [strategyFetchLocalFirstThenRemoteTryCatch] for try-catch
  /// pattern.
  strategyFetchLocalFirstThenRemote<E, D>({
    required Function(D? data) onLoading,
    required Future<Either<E, D>> Function() onFetchRemote,
    required Future<D?> Function() onFetchLocal,
    required Function(D? data, E? exception) onFinished,
    required Future<D?> Function(D data) onSaveToLocal,
  }) async {
    /// Fetch local data.
    var dataLocal = await onFetchLocal();

    /// Loading.
    onLoading(dataLocal);

    /// Fetch remote data.
    var dataRemote = await onFetchRemote();

    await dataRemote.fold(
          (exception) async {
        /// Return exception from remote fetch and local data if exist.
        await onFinished(dataLocal, exception);
      },
          (data) async {
        /// Save remove data to local.
        var finalData = await onSaveToLocal(data);

        /// Return remote data.
        await onFinished(finalData ?? data, null);
      },
    );
  }

  /// Data fetching strategy that fetches local data first, then try to fetch
  /// remote data. This strategy uses try-catch pattern.
  ///
  /// See also: [strategyFetchLocalFirstThenRemote] for "either" pattern.
  strategyFetchLocalFirstThenRemoteTryCatch<E, D>({
    required Function(D? data) onLoading,
    required Future<D> Function() onFetchRemote,
    required Future<D?> Function() onFetchLocal,
    required Function(D? data, Object? exception, [StackTrace stackTrace])
    onFinished,
    required Future<D?> Function(D data) onSaveToLocal,
  }) async {
    /// Fetch local data.
    var dataLocal = await onFetchLocal();
    try {
      /// Loading.
      onLoading(dataLocal);

      /// Fetch remote data.
      var dataRemote = await onFetchRemote();

      /// Save remove data to local.
      var finalData = await onSaveToLocal(dataRemote);

      /// Return remote data.
      await onFinished(finalData ?? dataRemote, null);
    } catch (err, stack) {
      await onFinished(dataLocal, err, stack);
    }
  }
}

import 'package:debs_driver_app/core/application/controllers/states/app_state.dart';
import 'package:debs_driver_app/core/domain/failure/exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Retry extends StatelessWidget {
  const Retry({super.key, required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error icon
          Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),

          const SizedBox(height: 24),

          // Main error message
          Text(
            'Something went wrong',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),

          const SizedBox(height: 16),

          if (onTap != null)
            Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade600,
              ),
            ),

          const SizedBox(height: 32),

          ElevatedButton.icon(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            icon: const Icon(Icons.refresh, size: 20),
            label: Text(
              'Retry',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Optional: Secondary action
        ],
      ),
    );
  }
}

class Progress extends StatelessWidget {
  const Progress({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('No data available'));
  }
}

class LoadStateHandler<T extends Object> extends StatelessWidget {
  const LoadStateHandler({
    super.key,
    this.onTapRetry,
    this.empty,
    required this.customState,
    required this.onData,
    this.loading,
    this.onError,
  });

  final VoidCallback? onTapRetry;
  final DataLoadState<T> customState;
  final Widget? empty;
  final Widget Function(T data) onData;
  final Widget? loading;
  final Widget Function(AppException? error)? onError;

  @override
  Widget build(BuildContext context) {
    return switch (customState) {
      DataLoadLoadedState(data: final T data) => onData(data),
      DataLoadErrorState(err: final AppException? err) =>
        onError?.call(err) ?? Retry(onTap: onTapRetry),
      DataLoadEmptyState() => empty ?? const Empty(),
      _ => loading ?? const Progress(),
    };
  }
}

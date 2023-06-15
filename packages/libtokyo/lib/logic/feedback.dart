abstract class FeedbackId<BuildContext> {
  const FeedbackId({
    required this.key,
    required this.onGenerateTitle,
  });

  final String key;
  final String Function(BuildContext context) onGenerateTitle;
}
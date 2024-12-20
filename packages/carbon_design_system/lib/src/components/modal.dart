part of 'index.dart';

class CarbonModal extends StatelessWidget {
  const CarbonModal(
      {super.key, this.label, this.title, this.body, this.actions});

  final Widget? label;
  final Widget? title;
  final Widget? body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        title: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (label != null)
                      DefaultTextStyle(
                          style: CarbonTextStyle.body01, child: label!),
                    if (title != null)
                      DefaultTextStyle(
                          style: CarbonTextStyle.heading03, child: title!),
                  ]),
            ),
          ),
          IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(CarbonIcon.close)),
        ]),
        content: DefaultTextStyle(
          style: CarbonTextStyle.body01,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (body != null)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: body!),
                const Spacing.$9(),
                Row(children: [if (actions != null) ...actions!]),
              ]),
        ),
      );
}

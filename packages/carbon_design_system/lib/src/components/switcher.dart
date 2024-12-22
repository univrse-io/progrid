part of 'index.dart';

class CarbonSwitcher extends StatelessWidget {
  final Widget? header;
  final Widget? footer;
  final List<Widget> children;

  const CarbonSwitcher(
      {super.key, this.header, this.footer, this.children = const <Widget>[]});

  static Widget item(String label, {VoidCallback? onTap}) => ListTile(
      onTap: onTap,
      title: Text(label, style: CarbonTextStyle.headingCompact01),
      visualDensity: VisualDensity.compact);

  static Widget divider([String? label]) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null)
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(label, style: CarbonTextStyle.bodyCompact01)),
            const Divider(indent: 16, endIndent: 16),
          ]);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: kHeaderHeight),
          child: Drawer(
            child: Column(children: [
              if (header != null) header!,
              Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(children: children)),
              ),
              if (footer != null) footer!,
            ]),
          ),
        ),
      );
}

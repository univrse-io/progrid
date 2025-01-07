part of 'index.dart';

// TODO: Create separate constructors for contained and bottomNavigation.
class CarbonTabBar extends StatefulWidget {
  final TabController? controller;
  final List<CarbonTab> tabs;
  final Color? indicatorColor;
  final double indicatorThickness;

  const CarbonTabBar(
      {super.key,
      this.controller,
      required this.tabs,
      this.indicatorColor,
      this.indicatorThickness = 2});

  @override
  State<CarbonTabBar> createState() => _CarbonTabBarState();
}

class _CarbonTabBarState extends State<CarbonTabBar> {
  late final carbonToken = Theme.of(context).extension<CarbonToken>();

  @override
  Widget build(BuildContext context) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        Divider(
            color: carbonToken?.borderSubtle00,
            height: widget.indicatorThickness,
            thickness: widget.indicatorThickness),
        ColoredBox(
          color: carbonToken!.background,
          child: TabBar.secondary(
              controller: widget.controller,
              tabs: widget.tabs,
              dividerHeight: 0,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                      color: widget.indicatorColor ??
                          carbonToken!.borderInteractive,
                      width: widget.indicatorThickness),
                  insets:
                      EdgeInsets.only(bottom: 48 + widget.indicatorThickness)),
              labelColor: carbonToken?.textPrimary,
              unselectedLabelColor:
                  carbonToken?.textSecondary.withValues(alpha: 0.7)),
        ),
      ]);
}

// TODO: Customize CarbonTab label style and icon size.
class CarbonTab extends Tab {
  const CarbonTab({super.key, super.child, super.icon})
      : super(height: 48, iconMargin: const EdgeInsets.all(5));
}

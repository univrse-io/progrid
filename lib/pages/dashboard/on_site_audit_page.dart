import 'package:flutter/material.dart';

class OnSiteAuditPage extends StatefulWidget {
  const OnSiteAuditPage({super.key});

  @override
  State<OnSiteAuditPage> createState() => _OnSiteAuditPageState();
}

class _OnSiteAuditPageState extends State<OnSiteAuditPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const Center(
      child: Text('On-Site Audit Page'),
    );
  }
}

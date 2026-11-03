import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import '../../app/utils/formatters.dart';
import '../../controllers/applications_controller.dart';
import '../../controllers/main_controller.dart';
import '../../models/loan_application_model.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/primary_button.dart';

class ApplicationsView extends GetView<ApplicationsController> {
  const ApplicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Applications'),
      ),
      body: Obx(() {
        final list = controller.applications;
        if (list.isEmpty) return const _EmptyState();
        return RefreshIndicator(
          onRefresh: () async => controller.load(),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => FadeSlideIn(
              index: i,
              child: _ApplicationCard(app: list[i]),
            ),
          ),
        );
      }),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.app});
  final LoanApplicationModel app;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.description_rounded,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(app.loanType, style: AppTextStyles.title),
                    Text('ID: ${app.id}', style: AppTextStyles.caption),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  app.status,
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              _info('Loan Amount', AppFormatters.currency(app.loanAmount)),
              _info('Purpose', app.purpose),
              _info('Applied On', AppFormatters.date(app.createdAt)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(String label, String value) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.label,
        ),
      ],
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: const BoxDecoration(
                color: AppColors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.description_outlined,
                size: 50,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 20),
            Text('No applications yet', style: AppTextStyles.h3),
            const SizedBox(height: 6),
            Text(
              'Apply for a loan in just a few steps and\ntrack its status right here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Apply for a Loan',
              onPressed: () => Get.find<MainController>().changeTab(1),
            ),
          ],
        ),
      ),
    );
  }
}

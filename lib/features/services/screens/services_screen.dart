import 'package:flutter/material.dart';

import '../../../core/api/api_client.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/option_picker.dart';
import '../../../core/widgets/stat_card.dart';
import '../../auth/models/auth_session.dart';
import '../models/service_item.dart';
import '../models/service_page.dart';
import '../widgets/empty_services_card.dart';
import '../widgets/service_card.dart';
import '../widgets/service_details_sheet.dart';
import '../widgets/service_form_sheet.dart';
import '../widgets/service_helpers.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key, required this.session});

  final AuthSession session;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final api = ApiClient();
  final searchController = TextEditingController();
  ServicePage? page;
  bool isLoading = true;
  int currentPage = 1;
  String search = '';
  String? category;

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadServices() async {
    setState(() => isLoading = true);
    try {
      final nextPage = await api.fetchServices(
        widget.session.token,
        page: currentPage,
        pageSize: 5,
        search: search,
        category: category,
      );
      setState(() => page = nextPage);
    } catch (error) {
      if (mounted) {
        showToast(context, error.toString(), isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> openServiceForm([ServiceItem? service]) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ServiceFormSheet(session: widget.session, service: service),
    );

    if (saved == true) {
      if (!mounted) {
        return;
      }
      showToast(
        context,
        service == null
            ? 'Service added successfully.'
            : 'Service updated successfully.',
      );
      loadServices();
    }
  }

  Future<void> openServiceDetails(ServiceItem service) async {
    final action = await showModalBottomSheet<ServiceDetailsAction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceDetailsSheet(service: service),
    );

    if (action == ServiceDetailsAction.edit) {
      openServiceForm(service);
    } else if (action == ServiceDetailsAction.toggleStatus) {
      toggleStatus(service);
    }
  }

  Future<void> toggleStatus(ServiceItem service) async {
    final nextStatus = service.status == 'active' ? 'inactive' : 'active';
    try {
      await api.updateServiceStatus(
        widget.session.token,
        service.id,
        nextStatus,
      );
      if (!mounted) {
        return;
      }
      showToast(
        context,
        nextStatus == 'active' ? 'Service activated.' : 'Service deactivated.',
      );
      loadServices();
    } catch (error) {
      if (!mounted) {
        return;
      }
      showToast(context, error.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicePage = page;
    final services = servicePage?.items ?? [];
    final meta = servicePage?.meta;
    final summary = servicePage?.summary;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service catalog',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLoading
                        ? 'Loading services...'
                        : '${services.length} shown from ${meta?.total ?? 0} services',
                    style: const TextStyle(color: Color(0xff6b7886)),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => openServiceForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Active',
                value: '${summary?.activeCount ?? 0}',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                label: 'Inactive',
                value: '${summary?.inactiveCount ?? 0}',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                label: 'Categories',
                value: '${serviceCategories.length}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Search services',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: search.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        search = '';
                        currentPage = 1;
                      });
                      loadServices();
                    },
                    icon: const Icon(Icons.close),
                  ),
          ),
          onSubmitted: (value) {
            setState(() {
              search = value.trim();
              currentPage = 1;
            });
            loadServices();
          },
        ),
        const SizedBox(height: 10),
        OptionPickerField<String>(
          label: 'Category filter',
          sheetTitle: 'Filter services',
          valueLabel: category == null
              ? 'All categories'
              : serviceCategoryLabel(category!),
          items: [
            const OptionPickerItem(value: '', label: 'All categories'),
            ...serviceCategories.entries.map(
              (entry) => OptionPickerItem(value: entry.key, label: entry.value),
            ),
          ],
          onChanged: (value) {
            setState(() {
              category = value.isEmpty ? null : value;
              currentPage = 1;
            });
            loadServices();
          },
        ),
        const SizedBox(height: 14),
        if (isLoading && services.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          )
        else if (services.isEmpty)
          EmptyServicesCard(onAdd: () => openServiceForm())
        else
          ...services.map(
            (service) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ServiceCard(
                service: service,
                onTap: () => openServiceDetails(service),
                onEdit: () => openServiceForm(service),
                onToggleStatus: () => toggleStatus(service),
              ),
            ),
          ),
        if ((meta?.totalPages ?? 1) > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: currentPage <= 1
                    ? null
                    : () {
                        setState(() => currentPage -= 1);
                        loadServices();
                      },
                child: const Text('Previous'),
              ),
              Text(
                'Page ${meta?.page ?? currentPage} of ${meta?.totalPages ?? 1}',
              ),
              OutlinedButton(
                onPressed: currentPage >= (meta?.totalPages ?? 1)
                    ? null
                    : () {
                        setState(() => currentPage += 1);
                        loadServices();
                      },
                child: const Text('Next'),
              ),
            ],
          ),
      ],
    );
  }
}

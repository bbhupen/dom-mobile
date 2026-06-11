import 'package:flutter/material.dart';

import '../../../core/api/api_client.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/stat_card.dart';
import '../../auth/models/auth_session.dart';
import '../models/drone.dart';
import '../models/drone_page.dart';
import '../widgets/drone_card.dart';
import '../widgets/drone_details_sheet.dart';
import '../widgets/drone_form_sheet.dart';
import '../widgets/empty_fleet_card.dart';

class FleetScreen extends StatefulWidget {
  const FleetScreen({super.key, required this.session});

  final AuthSession session;

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  final api = ApiClient();
  final searchController = TextEditingController();
  DronePage? page;
  bool isLoading = true;
  int currentPage = 1;
  String search = '';

  @override
  void initState() {
    super.initState();
    loadDrones();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadDrones() async {
    setState(() => isLoading = true);
    try {
      final nextPage = await api.fetchDrones(
        widget.session.token,
        page: currentPage,
        pageSize: 5,
        search: search,
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

  Future<void> openDroneForm([Drone? drone]) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          DroneFormSheet(session: widget.session, drone: drone),
    );

    if (saved == true) {
      if (!mounted) {
        return;
      }
      showToast(
        context,
        drone == null
            ? 'Drone added successfully.'
            : 'Drone updated successfully.',
      );
      loadDrones();
    }
  }

  Future<void> openDroneDetails(Drone drone) async {
    final action = await showModalBottomSheet<DroneDetailsAction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DroneDetailsSheet(drone: drone),
    );

    if (action == DroneDetailsAction.edit) {
      openDroneForm(drone);
    }
  }

  Future<void> toggleStatus(Drone drone) async {
    final nextStatus = drone.status == 'active' ? 'grounded' : 'active';
    try {
      await api.updateDroneStatus(widget.session.token, drone.id, nextStatus);
      if (!mounted) {
        return;
      }
      showToast(
        context,
        nextStatus == 'active' ? 'Drone activated.' : 'Drone deactivated.',
      );
      loadDrones();
    } catch (error) {
      if (!mounted) {
        return;
      }
      showToast(context, error.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dronePage = page;
    final drones = dronePage?.items ?? [];
    final meta = dronePage?.meta;
    final summary = dronePage?.summary;

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
                    'Registered drones',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLoading
                        ? 'Loading fleet...'
                        : '${drones.length} shown from ${meta?.total ?? 0} drones',
                    style: const TextStyle(color: Color(0xff6b7886)),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => openDroneForm(),
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
                label: 'Maintenance',
                value: '${summary?.maintenanceCount ?? 0}',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                label: 'Hours',
                value: summary?.totalFlightHours.toStringAsFixed(0) ?? '0',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Search fleet',
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
                      loadDrones();
                    },
                    icon: const Icon(Icons.close),
                  ),
          ),
          onSubmitted: (value) {
            setState(() {
              search = value.trim();
              currentPage = 1;
            });
            loadDrones();
          },
        ),
        const SizedBox(height: 14),
        if (isLoading && drones.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          )
        else if (drones.isEmpty)
          EmptyFleetCard(onAdd: () => openDroneForm())
        else
          ...drones.map(
            (drone) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DroneCard(
                drone: drone,
                onTap: () => openDroneDetails(drone),
                onEdit: () => openDroneForm(drone),
                onToggleStatus: () => toggleStatus(drone),
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
                        loadDrones();
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
                        loadDrones();
                      },
                child: const Text('Next'),
              ),
            ],
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:service_p/models/appointment_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<Appointment> get _appointments {
    return const [
      Appointment(
        customerName: 'Sarah Johnson',
        appointmentTitle: 'Barber',
        appointmentTime: '09:00 AM',
        appointmentDate: 'Today',
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      ),
      Appointment(
        customerName: 'Michael Chen',
        appointmentTitle: 'Spa Session',
        appointmentTime: '10:30 AM',
        appointmentDate: 'Tomorrow',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      ),
      Appointment(
        customerName: 'Emma Davis',
        appointmentTitle: 'Consultation',
        appointmentTime: '02:00 PM',
        appointmentDate: 'Jul 25',
        avatarUrl:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      ),
      Appointment(
        customerName: 'James Wilson',
        appointmentTitle: 'Team Meeting',
        appointmentTime: '03:45 PM',
        appointmentDate: 'Jul 26',
        avatarUrl:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      ),
      Appointment(
        customerName: 'Sofia Rodriguez',
        appointmentTitle: 'Massage Therapy',
        appointmentTime: '11:15 AM',
        appointmentDate: 'Jul 27',
        avatarUrl:
            'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150&h=150&fit=crop&crop=face',
      ),
      Appointment(
        customerName: 'Another User',
        appointmentTitle: 'Follow-up',
        appointmentTime: '09:00 AM',
        appointmentDate: 'Jul 28',
        avatarUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsToDisplay = _appointments;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointments',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body:
          appointmentsToDisplay.isEmpty
              ? _buildEmptyState(context)
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.separated(
                  itemCount: appointmentsToDisplay.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int index) {
                    final appointment = appointmentsToDisplay[index];
                    return AppointmentCard(
                      customerName: appointment.customerName,
                      appointmentTitle: appointment.appointmentTitle,
                      appointmentTime: appointment.appointmentTime,
                      appointmentDate: appointment.appointmentDate,
                      avatarUrl: appointment.avatarUrl,
                    );
                  },
                ),
              ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'No Appointments Yet!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later or schedule a new one.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String customerName;
  final String appointmentTitle;
  final String appointmentTime;
  final String appointmentDate;
  final String avatarUrl;

  const AppointmentCard({
    super.key,
    required this.customerName,
    required this.appointmentTitle,
    required this.appointmentTime,
    required this.appointmentDate,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomerAvatar(avatarUrl: avatarUrl),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointmentTitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppointmentTimeInfo(date: appointmentDate, time: appointmentTime),
            const SizedBox(height: 20),
            const AppointmentActions(),
          ],
        ),
      ),
    );
  }
}

// --- Customer Avatar (remains the same, uses theme) ---
class CustomerAvatar extends StatelessWidget {
  final String avatarUrl;

  const CustomerAvatar({super.key, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Image.network(
          avatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 32,
              ),
            );
          },
        ),
      ),
    );
  }
}

// --- Appointment Time Info (remains the same, uses theme) ---
class AppointmentTimeInfo extends StatelessWidget {
  final String date;
  final String time;

  const AppointmentTimeInfo({
    super.key,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            '$date at $time',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}

class AppointmentActions extends StatelessWidget {
  const AppointmentActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context: context,
            label: 'Decline',
            isPrimary: false,
            onPressed: () => _handleDecline(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            context: context,
            label: 'Accept',
            isPrimary: true,
            onPressed: () => _handleAccept(context),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isPrimary
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
          foregroundColor:
              isPrimary
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
          elevation: 0,
          side:
              isPrimary
                  ? null
                  : BorderSide(color: Theme.of(context).colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ),
    );
  }

  void _handleDecline(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Appointment declined')));
  }

  void _handleAccept(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Appointment accepted')));
  }
}

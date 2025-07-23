class Appointment {
  final String customerName;
  final String appointmentTitle;
  final String appointmentTime;
  final String appointmentDate;
  final String avatarUrl;

  const Appointment({
    required this.customerName,
    required this.appointmentTitle,
    required this.appointmentTime,
    required this.appointmentDate,
    required this.avatarUrl,
  });
}

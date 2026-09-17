// 🔥 Estado de las operaciones remotas (tipo cerrado)
enum RemoteOperationStatus {
  idle,      // Sin operación
  loading,   // Cargando
  success,   // Éxito
  error,     // Error
}

// 🔥 Estado con tipo cerrado para operaciones de carga
sealed class AppointmentsState {
  const AppointmentsState();
}

final class AppointmentsLoading extends AppointmentsState {
  const AppointmentsLoading();
}

final class AppointmentsLoaded extends AppointmentsState {
  final List<dynamic> data;
  const AppointmentsLoaded(this.data);
}

final class AppointmentsError extends AppointmentsState {
  final String message;
  const AppointmentsError(this.message);
}

final class AppointmentsEmpty extends AppointmentsState {
  const AppointmentsEmpty();
}
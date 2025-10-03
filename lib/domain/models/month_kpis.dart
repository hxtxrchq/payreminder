class MonthKpis {
  // Counts
  final int pendingCount; // PENDING + NEAR + DUE_TODAY
  final int paidCount; // PAID (occurrences marked paid in month)
  final int overdueCount; // OVERDUE

  // Amounts
  final double
      pendingAmount; // sum of occurrences due in month with pending-like states
  final double paidAmount; // sum of payments with payment date in month
  final double overdueAmount; // sum of occurrences due in month with OVERDUE

  const MonthKpis({
    required this.pendingCount,
    required this.paidCount,
    required this.overdueCount,
    required this.pendingAmount,
    required this.paidAmount,
    required this.overdueAmount,
  });
}

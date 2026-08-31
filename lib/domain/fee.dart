/// A股交易费用估算（§5.1 记账提速：手续费自动预填，可手改）
class FeeRates {
  const FeeRates({
    this.commissionRate = 0.00025, // 佣金 万2.5
    this.commissionMin = 5.0, // 最低佣金 5 元
    this.stampRate = 0.0005, // 印花税 0.05%（仅卖出）
    this.transferRate = 0.00001, // 过户费 0.001%（双边）
  });

  final double commissionRate;
  final double commissionMin;
  final double stampRate;
  final double transferRate;

  static const FeeRates defaults = FeeRates();

  double estimate(String side, double price, double quantity) {
    final amount = price * quantity;
    if (amount <= 0) return 0;
    final commission =
        (amount * commissionRate).clamp(commissionMin, double.infinity);
    final transfer = amount * transferRate;
    final stamp = side == 'SELL' ? amount * stampRate : 0.0;
    return commission + transfer + stamp;
  }
}

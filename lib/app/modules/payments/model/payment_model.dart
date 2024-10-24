class PaymentMethods {
  int? id;
  String? cardId;
  String? cardBrand;
  String? cardLastFourDigits;
  String? cardExpiryMonth;
  String? cardExpiryYear;
  String? createdAt;

  PaymentMethods(
      {this.id,
      this.cardId,
      this.cardBrand,
      this.cardLastFourDigits,
      this.cardExpiryMonth,
      this.cardExpiryYear,
      this.createdAt});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardId = json['card_id'];
    cardBrand = json['card_brand'];
    cardLastFourDigits = json['card_last_four_digits'];
    cardExpiryMonth = json['card_expiry_month'];
    cardExpiryYear = json['card_expiry_year'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['card_id'] = this.cardId;
    data['card_brand'] = this.cardBrand;
    data['card_last_four_digits'] = this.cardLastFourDigits;
    data['card_expiry_month'] = this.cardExpiryMonth;
    data['card_expiry_year'] = this.cardExpiryYear;
    data['created_at'] = this.createdAt;
    return data;
  }
}

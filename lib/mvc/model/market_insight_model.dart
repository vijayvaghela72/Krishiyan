class MarketInsight {
  String? id;
  String? state;
  String? district;
  String? market;
  String? commodity;
  List<PriceData> prices;
  int? v;

  MarketInsight({
    this.id,
    this.state,
    this.district,
    this.market,
    this.commodity,
    required this.prices,
    this.v,
  });

  factory MarketInsight.fromJson(Map<String, dynamic> json) {
    var priceList = json['prices'] as List;
    List<PriceData> pricesData =
        priceList.map((price) => PriceData.fromJson(price)).toList();

    return MarketInsight(
      id: json['_id'],
      state: json['state'],
      district: json['district'],
      market: json['market'],
      commodity: json['commodity'],
      prices: pricesData,
      v: json['__v'],
    );
  }

  // Helper methods to get price information
  int? get todaysPrice {
    if (prices.isEmpty) return null;
    return prices.last.price;
  }

  int? get yesterdaysPrice {
    if (prices.length < 2) return null;
    return prices[prices.length - 2].price;
  }

  int? get dayBeforeYesterdayPrice {
    if (prices.length < 3) return null;
    return prices[prices.length - 3].price;
  }

  int? get todaysPriceChange {
    if (prices.length < 2) return null;
    return todaysPrice! - yesterdaysPrice!;
  }

  int? get yesterdaysPriceChange {
    if (prices.length < 3) return null;
    return yesterdaysPrice! - dayBeforeYesterdayPrice!;
  }

  DateTime? get date {
    if (prices.isEmpty) return null;
    return prices.last.date;
  }
}

class PriceData {
  int price;
  DateTime date;
  String? id;

  PriceData({
    required this.price,
    required this.date,
    this.id,
  });

  factory PriceData.fromJson(Map<String, dynamic> json) {
    // Parse date in format "dd/MM/yyyy"
    final dateParts = json['date'].toString().split('/');
    final parsedDate = DateTime(
      int.parse(dateParts[2]), // year
      int.parse(dateParts[1]), // month
      int.parse(dateParts[0]), // day
    );

    return PriceData(
      price: json['price'],
      date: parsedDate,
      id: json['_id'],
    );
  }
}

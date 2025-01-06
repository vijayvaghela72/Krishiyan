
class MarketInsight {
   String? id;
   String? primaryKey;
   String? state;
   String? district;
   String? market;
   String? commodity;
   int? todaysPrice;
   int? yesterdaysPrice;
   int? dayBeforeYesterdayPrice;
   int? todaysPriceChange;
   int? yesterdaysPriceChange;
   DateTime? date;

  MarketInsight({
     this.id,
     this.primaryKey,
     this.state,
     this.district,
     this.market,
     this.commodity,
     this.todaysPrice,
     this.yesterdaysPrice,
     this.dayBeforeYesterdayPrice,
     this.todaysPriceChange,
     this.yesterdaysPriceChange,
     this.date,
  });

  // Factory method to create a MarketInsight from a JSON response
  MarketInsight.fromJson(Map<String, dynamic> json) {
    
       id = json['_id'] ?? '';  // Default to empty string if null
       primaryKey = json['primarykey'] ?? '';
    state = json['state'] ?? '';  // Default to empty string if null
    district = json['district'] ?? '';  // Default to empty string if null
    market = json['market'] ?? '';  // Default to empty string if null
    commodity = json['commodity'] ?? '';  // Default to empty string if null
    todaysPrice = json['todays_price'] ?? 0;  // Default to 0 if null
    yesterdaysPrice = json['yesterdays_price'] ?? 0;  // Default to 0 if null
    dayBeforeYesterdayPrice = json['day_before_yesterday_price'] ?? 0;  // Default to 0 if null
    todaysPriceChange = json['todays_price_change'] ?? 0;  // Default to 0 if null
    yesterdaysPriceChange = json['yesterdays_price_change'] ?? 0;  // Default to 0 if null
    date = json['date'] != null ? DateTime.parse(json['date']) : null;  // Only parse if not null
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    
      data['_id'] = this.id;
      data['primarykey'] = this.primaryKey;
      data['state'] =  this.state;
      data['district'] = this.district;
      data['market']= this.market;
      data['commodity']= this.commodity;
      data['todays_price'] = this.todaysPrice;
      data['yesterdays_price'] = this.yesterdaysPrice;
      data['day_before_yesterday_price'] = this.dayBeforeYesterdayPrice;
      data['todays_price_change'] = this.todaysPriceChange;
      data['yesterdays_price_change'] = this.yesterdaysPriceChange;
      data['date'] = this.date?.toIso8601String();
      return data;
    
  }
}

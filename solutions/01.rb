TO_BGN_EXCHANGE_RATE = {bgn: 1, usd: 1.7408, eur: 1.9557, gbp: 2.6415}

def convert_to_bgn(price, currency)
  (price * TO_BGN_EXCHANGE_RATE[currency]).round(2)
end

def compare_prices(price_1, currency_1, price_2, currency_2)
  convert_to_bgn(price_1, currency_1) <=> convert_to_bgn(price_2, currency_2)
end
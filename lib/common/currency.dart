enum Currency { EUR, USD, GBP }

Currency currencyfromString(String currencyCode) {
  switch (currencyCode) {
    case "EUR":
      return Currency.EUR;

    case "USD":
      return Currency.USD;

    case "GBP":
      return Currency.GBP;
  }

  return null;
}

String currencyStringtoSymbol(String currency) {
  switch (currencyfromString(currency)) {
    case Currency.EUR:
      return "€";

    case Currency.USD:
      return "\$";

    case Currency.GBP:
      return "£";
  }

  return null;
}

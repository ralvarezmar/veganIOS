# Deprecations in Angular 18

## Deprecated functions in the @angular/common module

The following functions from the `@angular/common` module are deprecated:

- [`getCurrencySymbol`](https://angular.dev/api/common/getCurrencySymbol)
- [`getLocaleCurrencyCode`](https://angular.dev/api/common/getLocaleCurrencyCode)
- [`getLocaleCurrencyName`](https://angular.dev/api/common/getLocaleCurrencyName)
- [`getLocaleCurrencySymbol`](https://angular.dev/api/common/getLocaleCurrencySymbol)
- [`getLocaleDateFormat`](https://angular.dev/api/common/getLocaleDateFormat)
- [`getLocaleDateTimeFormat`](https://angular.dev/api/common/getLocaleDateTimeFormat)
- [`getLocaleDayNames`](https://angular.dev/api/common/getLocaleDayNames)
- [`getLocaleDayPeriods`](https://angular.dev/api/common/getLocaleDayPeriods)
- [`getLocaleDirection`](https://angular.dev/api/common/getLocaleDirection)
- [`getLocaleEraNames`](https://angular.dev/api/common/getLocaleEraNames)
- [`getLocaleExtraDayPeriodRules`](https://angular.dev/api/common/getLocaleExtraDayPeriodRules)
- [`getLocaleExtraDayPeriods`](https://angular.dev/api/common/getLocaleExtraDayPeriods)
- [`getLocaleFirstDayOfWeek`](https://angular.dev/api/common/getLocaleFirstDayOfWeek)
- [`getLocaleId`](https://angular.dev/api/common/getLocaleId)
- [`getLocaleMonthNames`](https://angular.dev/api/common/getLocaleMonthNames)
- [`getLocaleNumberFormat`](https://angular.dev/api/common/getLocaleNumberFormat)
- [`getLocaleNumberSymbol`](https://angular.dev/api/common/getLocaleNumberSymbol)
- [`getLocalePluralCase`](https://angular.dev/api/common/getLocalePluralCase)
- [`getLocaleTimeFormat`](https://angular.dev/api/common/getLocaleTimeFormat)
- [`getLocaleWeekEndRange`](https://angular.dev/api/common/getLocaleWeekEndRange)
- [`getNumberOfCurrencyDigits`](https://angular.dev/api/common/getNumberOfCurrencyDigits)

## Deprecated property of the @Component decorator

The `interpolation` property of the [`@Component`](https://angular.dev/api/core/Component) decorator is deprecated. Use Angular's delimiters instead.

## Deprecated HTTP modules

The following modules from `@angular/common/http` are deprecated:

- HttpClientModule
- HttpClientXsrfModule
- HttpClientJsonpModule

Use the [`provideHttpClient`](https://angular.dev/api/common/http/provideHttpClient) function instead.

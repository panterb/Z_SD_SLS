@EndUserText.label: 'Goodwill Product'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@ObjectModel.query.implementedBy: 'ABAP:ZCL_SD_SLS_GOODWILLPRODUCT_VH'
@ObjectModel.resultSet.sizeCategory: #XS

define custom entity ZSD_SLS_C_GOODWILLPRODUCT_VH
{

      @Search                : { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @ObjectModel.text.element: ['ProductText']
      @UI.textArrangement: #TEXT_ONLY
  key Product                : matnr;

      @UI.hidden             : true
      @Consumption.filter.hidden    : true
      CustomerClassification : abap.char( 2 );

      @Search                : { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @Semantics.text        : true
      @Consumption.filter.hidden    : true
      ProductText            : zsd_sls_description;
}

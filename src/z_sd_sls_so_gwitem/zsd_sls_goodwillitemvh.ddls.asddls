@AccessControl.authorizationCheck: #NOT_REQUIRED

@Search: {
  searchable: true
}

@Consumption.ranked: true

@ObjectModel:{
  usageType:{
    dataClass: #MASTER,
    serviceQuality: #A,
    sizeCategory: #L},
  dataCategory: #VALUE_HELP}

@ObjectModel.representativeKey: 'SapUUID'
@Consumption.valueHelpDefault.fetchValues:#AUTOMATICALLY_WHEN_DISPLAYED

@ObjectModel.resultSet.sizeCategory: #XS

@EndUserText.label: 'Gift Card'
define view entity ZSD_SLS_GOODWILLITEMVH
  as select from ZSD_SLS_I_GWITEMTP as GoodwillItem
{
      @UI.hidden:true
  key GoodwillItem.SapUUID,
      
      @Search                : { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @ObjectModel.text.element: ['ProductName']
      @UI.textArrangement: #TEXT_ONLY
      @EndUserText.label: 'Product'
      GoodwillItem.Product,

      @UI.hidden             : true
      @Consumption.filter.hidden    : true
      GoodwillItem.CustomerClassification,

      @Search                : { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @Semantics.text        : true
      @Consumption.filter.hidden    : true
      GoodwillItem._Product._Text[ Language = $session.system_language ].ProductName     
}

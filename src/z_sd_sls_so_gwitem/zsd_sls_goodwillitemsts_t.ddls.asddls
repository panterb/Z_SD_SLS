@ObjectModel.usageType.dataClass: #META
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.resultSet.sizeCategory: #XS
@EndUserText.label: 'Goodwill Item Status Text'
@ObjectModel.dataCategory: #TEXT
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true


define view entity ZSD_SLS_GOODWILLITEMSTS_T
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZSD_SLS_GOODWILLITEM_STATUS' )

{
  key domain_name,
  key value_position,
      @Semantics.language: true
  key language,
      value_low as zz_goodwillitemstatus_sdh,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #LOW
      text

}

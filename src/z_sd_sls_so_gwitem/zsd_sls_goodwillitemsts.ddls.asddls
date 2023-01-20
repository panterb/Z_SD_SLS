@ObjectModel.representativeKey: 'zz_goodwillitemstatus_sdh'
@ObjectModel.usageType.dataClass: #META
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.resultSet.sizeCategory: #XS
@EndUserText.label: 'Goodwill Item Status'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true


define view entity ZSD_SLS_GOODWILLITEMSTS
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name: 'ZSD_SLS_GOODWILLITEM_STATUS' )

  association [0..*] to ZSD_SLS_GOODWILLITEMSTS_T as _Text on  $projection.zz_goodwillitemstatus_sdh = _Text.zz_goodwillitemstatus_sdh
                                                           and $projection.value_position            = _Text.value_position
                                                           and $projection.domain_name               = _Text.domain_name
{
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @ObjectModel.text.association: '_Text'
  key value_low as zz_goodwillitemstatus_sdh,
      @Search.defaultSearchElement: true
      _Text


}

@ObjectModel.representativeKey: 'zz_PrfrdSrvc_sdh'
@ObjectModel.usageType.dataClass: #META
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.resultSet.sizeCategory: #XS
@EndUserText.label: 'Preferred Service'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true


define view entity ZSD_SLS_I_PRFRDSRVC
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name: 'ZSD_SLS_PRFRDSRVC' )

  association [0..*] to ZSD_SLS_I_PRFRDSRVC_T as _Text on  $projection.zz_PrfrdSrvc_sdh   = _Text.zz_PrfrdSrvc_sdh
                                                           and $projection.value_position = _Text.value_position
                                                           and $projection.domain_name    = _Text.domain_name
{
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @ObjectModel.text.association: '_Text'
  key value_low as zz_PrfrdSrvc_sdh,
      @Search.defaultSearchElement: true
      _Text


}

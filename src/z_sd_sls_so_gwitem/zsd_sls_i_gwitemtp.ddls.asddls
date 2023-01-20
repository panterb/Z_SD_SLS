@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '##GENERATED Goodwill Item'
define root view entity ZSD_SLS_I_GWITEMTP
  as select from zsd_sls_gwitem as GoodwillItem
  association [0..1] to I_CustomerClassification as _CustomerClassification on $projection.CustomerClassification = _CustomerClassification.CustomerClassification
  association [0..1] to I_Product                as _Product                on $projection.Product = _Product.Product

{
  key sap_uuid               as SapUUID,
      @ObjectModel.foreignKey.association:'_CustomerClassification'
      customerclassification as CustomerClassification,
      @ObjectModel.foreignKey.association:'_Product'
      product                as Product,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat     as Locallastchangedat,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat          as Lastchangedat,
      @Semantics.user.lastChangedBy: true
      lastchangedby          as Lastchangedby,

      _CustomerClassification,
      _Product

}

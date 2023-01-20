@EndUserText.label: 'Preferred Service for Customer Class.'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_PRFRDSRVC4CUSTCN
  as select from zsdprsrv4custcn
  association [1..1] to I_CustomerClassification     as _CustomerClassification on $projection.Customerclassification = _CustomerClassification.CustomerClassification
  association [1..1] to ZSD_SLS_I_PRFRDSRVC          as _Prfrdsrvc              on $projection.Prfrdsrvc = _Prfrdsrvc.zz_PrfrdSrvc_sdh
  association        to parent ZI_PRFRDSRVC4CUSTCN_S as _PreferredServiceAll    on $projection.SingletonID = _PreferredServiceAll.SingletonID
{
      @ObjectModel.foreignKey.association:'_CustomerClassification'
  key customerclassification as Customerclassification,
      @ObjectModel.foreignKey.association:'_Prfrdsrvc'
  key prfrdsrvc              as Prfrdsrvc,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat     as Locallastchangedat,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat          as Lastchangedat,
      @Semantics.user.lastChangedBy: true
      lastchangedby          as Lastchangedby,
      1                      as SingletonID,
      _PreferredServiceAll,
      _CustomerClassification,
      _Prfrdsrvc

}

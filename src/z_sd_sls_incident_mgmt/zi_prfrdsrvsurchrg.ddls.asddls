@EndUserText.label: 'Preferred Service Surcharge'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_PrfrdSrvSurchrg
  as select from zsdprsrvsurchrg
  association [1..1] to ZSD_SLS_I_PRFRDSRVC         as _Prfrdsrvc           on $projection.Prfrdsrvc = _Prfrdsrvc.zz_PrfrdSrvc_sdh

  association        to parent ZI_PrfrdSrvSurchrg_S as _PreferredServiceAll on $projection.SingletonID = _PreferredServiceAll.SingletonID
{

      @ObjectModel.foreignKey.association:'_Prfrdsrvc'
  key prfrdsrvc          as Prfrdsrvc,
      surchrg            as Surchrg,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as Locallastchangedat,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat      as Lastchangedat,
      @Semantics.user.lastChangedBy: true
      lastchangedby      as Lastchangedby,
      1                  as SingletonID,
      _PreferredServiceAll,
      _Prfrdsrvc

}

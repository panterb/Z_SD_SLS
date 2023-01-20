@EndUserText.label: 'Preferred Service Surcharge Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_PrfrdSrvSurchrg_S
  as select from I_Language
    left outer join ZSDPRSRVSURCHRG on 0 = 0
  composition [0..*] of ZI_PrfrdSrvSurchrg as _PrfrdSrvSurchrg
{
  key 1 as SingletonID,
  _PrfrdSrvSurchrg,
  max( ZSDPRSRVSURCHRG.LASTCHANGEDAT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language

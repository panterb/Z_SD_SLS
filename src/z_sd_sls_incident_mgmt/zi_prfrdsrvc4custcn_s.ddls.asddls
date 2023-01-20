@EndUserText.label: 'Preferred Service for Customer Class'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_PRFRDSRVC4CUSTCN_S
  as select from I_Language
    left outer join ZSDPRSRV4CUSTCN on 0 = 0
  composition [0..*] of ZI_PRFRDSRVC4CUSTCN as _PRFRDSRVC4CUSTCN
{
  key 1 as SingletonID,
  _PRFRDSRVC4CUSTCN,
  max( ZSDPRSRV4CUSTCN.LASTCHANGEDAT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language

@EndUserText.label: 'Preferred Service Surcharge Singleton - '
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_PrfrdSrvSurchrg_S
  provider contract transactional_query
  as projection on ZI_PrfrdSrvSurchrg_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _PrfrdSrvSurchrg : redirected to composition child ZC_PrfrdSrvSurchrg
  
}

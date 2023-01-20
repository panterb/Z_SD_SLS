@EndUserText.label: 'Preferred Service for Customer Class - M'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_PRFRDSRVC4CUSTCN_S
  provider contract transactional_query
  as projection on ZI_PRFRDSRVC4CUSTCN_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _PRFRDSRVC4CUSTCN : redirected to composition child ZC_PRFRDSRVC4CUSTCN
  
}

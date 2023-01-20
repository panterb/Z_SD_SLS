@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZSD_SLS_I_GIFTCARDTP'
define root view entity ZSD_SLS_C_GIFTCARDTP
  as projection on ZSD_SLS_I_GIFTCARDTP
{
  key SapUUID,
  Giftcardnumber,
  SapDescription,
  @Semantics.amount.currencyCode: 'AmountC'
  AmountV,
  AmountC,
  Lastchangedat
  
}

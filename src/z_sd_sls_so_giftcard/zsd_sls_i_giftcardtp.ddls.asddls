@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Gift Card'
define root view entity ZSD_SLS_I_GIFTCARDTP
  as select from zsd_sls_giftcard as GiftCard
{
  key sap_uuid as SapUUID,
  giftcardnumber as Giftcardnumber,
  sap_description as SapDescription,
  @Semantics.amount.currencyCode: 'AmountC'
  amount_v as AmountV,
  amount_c as AmountC,
  lastchangedat as Lastchangedat
  
}

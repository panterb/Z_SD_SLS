@AccessControl.authorizationCheck: #NOT_REQUIRED

@Search: {
  searchable: true
}

@Consumption.ranked: true

@ObjectModel:{
  usageType:{
    dataClass: #MASTER,
    serviceQuality: #A,
    sizeCategory: #L},
  dataCategory: #VALUE_HELP}

@ObjectModel.representativeKey: 'SapUUID'
@Consumption.valueHelpDefault.fetchValues:#AUTOMATICALLY_WHEN_DISPLAYED

//@ObjectModel.resultSet.sizeCategory: #XS

@EndUserText.label: 'Gift Card'
define view entity ZSD_SLS_GIFTCARDVH
  as select from ZSD_SLS_I_GIFTCARDTP as GiftCard
{
      @UI.hidden:true
  key GiftCard.SapUUID,

      @ObjectModel.text.element: ['SapDescription']
      GiftCard.Giftcardnumber,

      @Search: {
        defaultSearchElement: true,
        ranking: #HIGH,
        fuzzinessThreshold: 0.8 }
      @Semantics.text: true
      GiftCard.SapDescription
}

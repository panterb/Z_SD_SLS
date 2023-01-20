@EndUserText.label: 'Preferred Service for Customer Class. - '
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_PRFRDSRVC4CUSTCN
  as projection on ZI_PRFRDSRVC4CUSTCN
{
      @ObjectModel.text.element: ['CustomerClassificationDesc']
  key Customerclassification,
      @ObjectModel.text.element: ['PrfrdsrvcDesc']
  key Prfrdsrvc,
      @Consumption.hidden: true
      Locallastchangedat,
      Lastchangedat,
      Lastchangedby,
      @Consumption.hidden: true
      SingletonID,
      _PreferredServiceAll : redirected to parent ZC_PRFRDSRVC4CUSTCN_S,

      ZI_PRFRDSRVC4CUSTCN._CustomerClassification._Text.CustomerClassificationDesc as CustomerClassificationDesc : localized,
      ZI_PRFRDSRVC4CUSTCN._Prfrdsrvc._Text.text                                    as PrfrdsrvcDesc              : localized



}

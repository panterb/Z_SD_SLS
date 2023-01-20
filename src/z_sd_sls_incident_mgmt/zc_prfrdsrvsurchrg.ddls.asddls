@EndUserText.label: 'Preferred Service Surcharge - Maintain'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_PrfrdSrvSurchrg
  as projection on ZI_PrfrdSrvSurchrg
{
      @ObjectModel.text.element: ['PrfrdsrvcDesc']
  key Prfrdsrvc,
      Surchrg,
      @Consumption.hidden: true
      Locallastchangedat,
      Lastchangedat,
      Lastchangedby,
      @Consumption.hidden: true
      SingletonID,
      _PreferredServiceAll : redirected to parent ZC_PrfrdSrvSurchrg_S,
      ZI_PrfrdSrvSurchrg._Prfrdsrvc._Text.text as PrfrdsrvcDesc : localized


}

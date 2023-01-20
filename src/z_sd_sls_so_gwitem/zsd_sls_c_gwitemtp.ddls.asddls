@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZSD_SLS_I_GWITEMTP'
define root view entity ZSD_SLS_C_GWITEMTP
  provider contract transactional_query
  as projection on ZSD_SLS_I_GWITEMTP as GWITEMTP
{
  key GWITEMTP.SapUUID,
      @ObjectModel.text.element: ['CustomerClassificationDesc']
      GWITEMTP.CustomerClassification,
      @ObjectModel.text.element: ['ProductName']
      GWITEMTP.Product,
      GWITEMTP.Locallastchangedat,

      GWITEMTP._CustomerClassification._Text.CustomerClassificationDesc as CustomerClassificationDesc : localized,
      GWITEMTP._Product._Text.ProductName                               as ProductName                : localized



}

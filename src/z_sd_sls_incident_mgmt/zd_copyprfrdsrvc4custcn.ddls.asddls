@EndUserText.label: 'Copy Preferred Service for Customer Class.'
define abstract entity ZD_CopyPRFRDSRVC4CUSTCN
{
  @EndUserText.label: 'New Customerclassification'
  Customerclassification : abap.char( 2 );
  @EndUserText.label: 'New Prfrdsrvc'
  Prfrdsrvc : ZSD_SLS_PRFRDSRVC;
  
}

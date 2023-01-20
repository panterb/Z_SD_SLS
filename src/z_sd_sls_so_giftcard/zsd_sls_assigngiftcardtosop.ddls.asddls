@EndUserText.label: 'Sales Order Gift Card'
define abstract entity ZSD_SLS_ASSIGNGIFTCARDTOSOP { 
@Consumption.valueHelpDefinition: [{
  entity: {
    name: 'ZSD_SLS_GIFTCARDVH',
    element: 'Giftcardnumber'
  }
}]
    @EndUserText.label: 'Gift Card'
    Giftcardnumber     : zsd_sls_giftcardnumber; 
}

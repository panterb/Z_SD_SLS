@EndUserText.label: 'Sales Order Goodwill Product'
define abstract entity ZSD_SLS_ADDGOODWILLITEM
{
  @Consumption.valueHelpDefinition: [{
    entity               : {
      name               : 'ZSD_SLS_GOODWILLITEMVH',
      element            : 'Product'
    },
    additionalBinding    : [{ element: 'CustomerClassification',
                          localElement: 'CustomerClassification',
                          usage: #FILTER } ] }]

  @EndUserText.label     : 'Goodwill Product'
  Product                : matnr;

  @UI.hidden             : true
  @UI.defaultValue       : #('ELEMENT_OF_REFERENCED_ENTITY:YY1_CustClassification')
  CustomerClassification : abap.char( 2 );
}

extend view entity C_SalesOrderManage with
{
  @UI: {
  fieldGroup:[{qualifier: 'OrderData', importance: #HIGH, type: #FOR_ACTION, dataAction: 'zz_add_goodwill_item', label: 'Add Goodwill Item' }]}
  @Consumption.valueHelpDefinition: [{
    entity: { name: 'ZSD_SLS_GOODWILLITEMSTS',
              element: 'zz_goodwillitemstatus_sdh' } }]
  @ObjectModel.text.element: ['zz_goodwillitemstst_sdh']
  @UI.textArrangement: #TEXT_ONLY
  SalesOrder.zz_goodwillitemstatus_sdh          as zz_goodwillitemstatus_sdh,

  SalesOrder._ZZ_GOODWILLITEMSTS_SDH._Text.text as zz_goodwillitemstst_sdh : localized

}

extend view entity C_SalesOrderManage with
{
    @UI: {
    fieldGroup:[{qualifier: 'OrderData', importance: #HIGH, type: #FOR_ACTION, dataAction: 'zz_review_order', label: 'Set to Reviewed' }]}
    @UI.hidden: true
    virtual zz_dummy_sdh: abap.char( 1 )
}

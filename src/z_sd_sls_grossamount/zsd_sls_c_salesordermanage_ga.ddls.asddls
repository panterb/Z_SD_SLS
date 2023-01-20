extend view entity C_SalesOrderManage with {


@UI.facet: [{
    id: 'MyNetValueDataHeader',
    label: 'My Net Value',
    purpose:    #HEADER,
    position:   100,
    importance: #HIGH,
    type:       #DATAPOINT_REFERENCE,
    targetQualifier: 'MyNetValue' 
}]
  @UI: {
    lineItem: [{position: 900, importance:#HIGH }],
    dataPoint:{qualifier: 'MyNetValue', title: 'My Net Value'}
  }
  SalesOrder.zz_grossamount_sdh
}

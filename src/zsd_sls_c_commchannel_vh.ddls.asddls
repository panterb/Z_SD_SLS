@EndUserText.label: 'Communication Channel'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@ObjectModel.query.implementedBy: 'ABAP:ZCL_SD_SLS_COMMCHANNEL_VH'
@ObjectModel.resultSet.sizeCategory: #XS

define custom entity ZSD_SLS_C_COMMCHANNEL_VH
{

      @Search: { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @ObjectModel.text.element: ['CommunicationChannelText']
  key CommunicationChannel          : abap.char( 2 );

      @UI.hidden                    : true
      @Consumption.filter.hidden    : true
      CustomerClassification        : abap.char( 2 );

      @Search: { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @Semantics.text: true
      @Consumption.filter.hidden    : true
      CommunicationChannelText      : abap.char( 20 );
}

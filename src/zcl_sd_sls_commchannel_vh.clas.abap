CLASS zcl_sd_sls_commchannel_vh DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
    CLASS-METHODS class_constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES tct_value_help_entry TYPE STANDARD TABLE OF ZSD_SLS_C_COMMCHANNEL_VH WITH DEFAULT KEY.

    TYPES tct_comm_channel_range  TYPE RANGE OF ZSD_SLS_C_COMMCHANNEL_VH-CommunicationChannel.
    TYPES tct_customer_class_range  TYPE RANGE OF ZSD_SLS_C_COMMCHANNEL_VH-CustomerClassification.
    CLASS-DATA st_data TYPE tct_value_help_entry.
ENDCLASS.



CLASS zcl_sd_sls_commchannel_vh IMPLEMENTATION.
  METHOD if_rap_query_provider~select.

    DATA lt_result TYPE STANDARD TABLE OF ZSD_SLS_C_COMMCHANNEL_VH .
    DATA lt_customer_class_range TYPE tct_customer_class_range.
    DATA lt_comm_channel_range TYPE tct_comm_channel_range.

    DATA(lo_paging) = io_request->get_paging( ).
    DATA(lt_sort_elements) = io_request->get_sort_elements( ) .


    "GET RANGES
    TRY.
        DATA(lt_ranges)     = io_request->get_filter( )->get_as_ranges(  ).
        LOOP AT lt_ranges REFERENCE INTO DATA(lr_range).
          CASE lr_range->name.
            WHEN 'CUSTOMERCLASSIFICATION'.
              LOOP AT lr_range->range REFERENCE INTO DATA(lr_range_entry).
                INSERT VALUE #( sign = lr_range_entry->sign option =  lr_range_entry->option
                                low  = CONV #( lr_range_entry->low )  high   = CONV #( lr_range_entry->high ) )
                                INTO TABLE lt_customer_class_range.
              ENDLOOP.
            WHEN 'COMMUNICATIONCHANNEL'.
              LOOP AT lr_range->range REFERENCE INTO lr_range_entry.
                INSERT VALUE #( sign = lr_range_entry->sign option =  lr_range_entry->option
                                low  = CONV #( lr_range_entry->low )  high   = CONV #( lr_range_entry->high ) )
                                INTO TABLE lt_comm_channel_range.
              ENDLOOP.
          ENDCASE.
        ENDLOOP.
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_previous).
        "Exception handling needed - not implemented yet
    ENDTRY.

    "Description Only Request
    IF lt_comm_channel_range IS NOT INITIAL
      AND lt_customer_class_range IS INITIAL.
      APPEND VALUE #( CommunicationChannel = '01' CommunicationChannelText = 'E-Mail') TO lt_result.
      APPEND VALUE #( CommunicationChannel = '02' CommunicationChannelText = 'Online Survey') TO lt_result.
      APPEND VALUE #( CommunicationChannel = '03' CommunicationChannelText = 'Post Campaign') TO lt_result.
    ELSE.
      LOOP AT lt_customer_class_range ASSIGNING FIELD-SYMBOL(<ls_customer_classification>).

        LOOP AT st_data ASSIGNING FIELD-SYMBOL(<ls_data>)
          WHERE CustomerClassification = <ls_customer_classification>-low.

          INSERT CORRESPONDING #( <ls_data> ) INTO TABLE lt_result.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

    io_response->set_data( lt_result ).
    io_response->set_total_number_of_records(  lines( lt_result ) ).
  ENDMETHOD.

  METHOD class_constructor.
    st_data = VALUE #( ( CommunicationChannel = '01' CommunicationChannelText = 'E-Mail' CustomerClassification = 'A' )
                       ( CommunicationChannel = '02' CommunicationChannelText = 'Online Survey' CustomerClassification = 'A' )
                       ( CommunicationChannel = '03' CommunicationChannelText = 'Post Campaign' CustomerClassification = 'A' )
                       ( CommunicationChannel = '02' CommunicationChannelText = 'Online Survey' CustomerClassification = 'B' )
                       ( CommunicationChannel = '01' CommunicationChannelText = 'E-MAil' CustomerClassification = 'C' )
                       ( CommunicationChannel = '04' CommunicationChannelText = 'Quarterly exhibition' CustomerClassification = 'C' ) ).
  ENDMETHOD.
ENDCLASS.


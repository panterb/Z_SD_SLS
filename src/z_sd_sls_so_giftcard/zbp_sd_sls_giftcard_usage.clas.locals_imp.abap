CLASS lhc_salesorder DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR SalesOrder RESULT result.
    METHODS zz_use_gift_card FOR MODIFY
      IMPORTING it_keys FOR ACTION SalesOrder~zz_use_gift_card RESULT result.

ENDCLASS.

CLASS lhc_salesorder IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF I_SalesOrderTP IN LOCAL MODE
      ENTITY SalesOrder
      FIELDS ( TotalNetAmount )
        WITH CORRESPONDING #( keys )
          RESULT DATA(lt_result_salesorder).

    result = VALUE #( FOR ls_salesorder IN lt_result_salesorder ( %tky = ls_salesorder-%tky
                                                                  %features-%action-zz_use_gift_card = COND #( WHEN ls_salesorder-TotalNetAmount < '50'
                                                                                                               THEN if_abap_behv=>fc-o-disabled
                                                                                                               ELSE if_abap_behv=>fc-o-enabled ) ) ).
  ENDMETHOD.

  METHOD zz_use_gift_card.

    SELECT giftcardnumber, amount_v, amount_c FROM zsd_sls_giftcard for all ENTRIES IN @it_keys
        WHERE giftcardnumber = @it_keys-%param-Giftcardnumber
        INTO table @data(lt_discount).

    "action implementation
    LOOP AT it_keys REFERENCE INTO DATA(lr_key).

      read TABLE lt_discount into data(ls_discount) WITH KEY giftcardnumber = lr_key->%param-Giftcardnumber.
      CHECK ls_discount IS NOT INITIAL.

*     PAAS API pricing test (hide price details)
*      READ ENTITY IN LOCAL MODE i_salesordertp BY \_item FROM VALUE #( ( salesorder = lr_key->%tky-SalesOrder ) ) RESULT DATA(lt_salesorderitem).
*
*      READ ENTITY PRIVILEGED i_salesorderitemtp BY \_ItemPricingElement  FROM VALUE #( ( salesorder = lr_key->%tky-SalesOrder
*                                                                                         SalesOrderItem = lt_salesorderitem[ 1 ]-SalesOrderItem ) )
*                                                   RESULT DATA(lt_itempricingelement).
*
*      READ ENTITY  i_salesorderitemprcgelmnttp
*     FROM VALUE #( ( %tky = VALUE #( salesorder = lr_key->%tky-SalesOrder
*                                     SalesOrderItem = lt_salesorderitem[ 1 ]-SalesOrderItem
*                                     PricingProcedureStep = 950
*                                     PricingProcedureCounter = 001 ) ) )
*         RESULT DATA(lt_profit_margin)
*         REPORTED DATA(ls_reported)
*         FAILED   DATA(ls_failed).
*
*      MODIFY ENTITIES OF i_salesordertp IN LOCAL MODE
*     ENTITY salesorderitempricingelement
*       UPDATE FROM VALUE #( ( %key-salesorder              = lr_key->%tky-SalesOrder
*                              %key-salesorderitem          = lt_salesorderitem[ 1 ]-SalesOrderItem
*                              %key-pricingprocedurestep    = 120
*                              %key-pricingprocedurecounter = 001
*                              ConditionRateAmount           = '20'
*                              %control-ConditionRateAmount  = if_abap_behv=>mk-on ) )
*       REPORTED ls_reported
*       FAILED   ls_failed.
*
*      MODIFY ENTITIES OF i_salesordertp PRIVILEGED
*    ENTITY salesorderitempricingelement
*      UPDATE FROM VALUE #( ( %key-salesorder              = lr_key->%tky-SalesOrder
*                             %key-salesorderitem          = lt_salesorderitem[ 1 ]-SalesOrderItem
*                             %key-pricingprocedurestep    = 120
*                             %key-pricingprocedurecounter = 001
*                             ConditionRateAmount           = '20'
*                             %control-ConditionRateAmount  = if_abap_behv=>mk-on ) )
*      REPORTED ls_reported
*      FAILED   ls_failed.

*      End PAAS API pricing test (hide price details)
*      *******************************************************************************************************************
      MODIFY ENTITIES OF i_salesordertp IN LOCAL MODE
        ENTITY salesorder
        UPDATE SET FIELDS WITH VALUE #(
        ( %tky                    = lr_key->%tky
          %data-zz_giftcardamount_sdh  = ls_discount-amount_v
          %data-zz_giftcardcurrency_sdh = ls_discount-amount_c )
         )
       CREATE BY \_pricingelement SET FIELDS WITH VALUE #(
        ( %tky    = lr_key->%tky
          %target =   VALUE #( (
            %cid                = 'CIDGIFTCARD'
            conditiontype       = 'DRV1'
            "conditiontype       = 'XXXX'
            conditionrateamount = ls_discount-amount_v * ( -1 )
            conditioncurrency   = ls_discount-amount_c ) ) ) )
        FAILED   DATA(ls_modify_failed)
        REPORTED DATA(ls_modify_reported).

      failed   = CORRESPONDING #( APPENDING BASE ( failed   ) ls_modify_failed   ).
      reported = CORRESPONDING #( APPENDING BASE ( reported ) ls_modify_reported ).

    ENDLOOP.

    READ ENTITIES OF i_salesordertp IN LOCAL MODE
      ENTITY salesorder
         ALL FIELDS WITH
         CORRESPONDING #( it_keys )
       RESULT DATA(lt_salesorder).

    result = VALUE #( FOR salesorder IN lt_salesorder ( %tky   = salesorder-%tky
                                                        %param = CORRESPONDING #( salesorder ) ) ).


  ENDMETHOD.

ENDCLASS.

CLASS lsc_R_SALESORDERTP DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_R_SALESORDERTP IMPLEMENTATION.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

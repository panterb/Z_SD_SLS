CLASS lhc_salesorder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING it_keys REQUEST requested_features FOR SalesOrder RESULT result.
    METHODS zz_review_order FOR MODIFY
      IMPORTING it_keys FOR ACTION SalesOrder~zz_review_order RESULT result.

ENDCLASS.

CLASS lhc_salesorder IMPLEMENTATION.

METHOD get_instance_features.

    READ ENTITIES OF i_salesordertp IN LOCAL MODE
      ENTITY salesorder
         FIELDS ( YY1_CrByIncidentMgmt_SDH DeliveryBlockReason ) WITH
         CORRESPONDING #( it_keys )
       RESULT DATA(lt_salesorder).

    result = VALUE #( FOR ls_salesorder IN lt_salesorder
                      ( %tky = ls_salesorder-%tky
                        %features-%action-zz_review_order = COND #(
                          WHEN ls_salesorder-YY1_CrByIncidentMgmt_SDH = abap_true AND
                               ls_salesorder-DeliveryBlockReason IS NOT INITIAL
                          THEN if_abap_behv=>fc-o-enabled
                          ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

  METHOD zz_review_order.

    TYPES:
      BEGIN OF tcs_customer,
        customer               TYPE i_customer-Customer,
        CustomerClassification TYPE i_customer-CustomerClassification,
      END OF tcs_customer,

      BEGIN OF tcs_prfrdsrvc,
        CustomerClassification TYPE zi_prfrdsrvc4custcn-CustomerClassification,
        prfrdsrvc              TYPE zi_prfrdsrvc4custcn-Prfrdsrvc,
      END OF tcs_prfrdsrvc,

      BEGIN OF tcs_prfrdsrvc_surcharge,
        prfrdsrvc TYPE ZI_PrfrdSrvSurchrg-Prfrdsrvc,
        surchrg   TYPE ZI_PrfrdSrvSurchrg-Surchrg,
      END OF tcs_prfrdsrvc_surcharge,

      tct_customer            TYPE SORTED TABLE OF tcs_customer WITH UNIQUE KEY customer,
      tct_prfrdsrvc           TYPE SORTED TABLE OF tcs_prfrdsrvc WITH UNIQUE KEY CustomerClassification,
      tct_prfrdsrvc_surcharge TYPE SORTED TABLE OF tcs_prfrdsrvc_surcharge WITH UNIQUE KEY prfrdsrvc.

    DATA:
      lt_customer            TYPE tct_customer,
      lt_prfrdsrvc           TYPE tct_prfrdsrvc,
      lt_prfrdsrvc_surcharge TYPE tct_prfrdsrvc_surcharge,
      lt_header_surcharge    TYPE TABLE FOR CREATE I_SalesOrderTP\_PricingElement,
      lt_header_text         TYPE TABLE FOR CREATE I_SalesOrderTP\_Text,
      lt_update              TYPE TABLE FOR UPDATE I_SalesOrderTP,
      lv_conditionrateamount TYPE I_SalesOrderPricingElementTP-ConditionRateAmount.

    READ ENTITIES OF i_salesordertp IN LOCAL MODE
      ENTITY salesorder
         FIELDS ( SoldToParty TransactionCurrency TotalNetAmount ) WITH
         CORRESPONDING #( it_keys )
       RESULT DATA(lt_salesorder_pre)
       FAILED failed.

    CHECK lt_salesorder_pre IS NOT INITIAL.
    SELECT customer, CustomerClassification
      FROM I_customer WITH PRIVILEGED ACCESS
      FOR ALL ENTRIES IN @lt_salesorder_pre
      WHERE Customer = @lt_salesorder_pre-SoldToParty
      INTO TABLE @lt_customer.

*   No need to check for empty lt_customer as every sales order should have a sold-to party
                                                   "#EC CI_NO_TRANSFORM
    SELECT CustomerClassification, prfrdsrvc  "#EC CI_FAE_LINES_ENSURED
      FROM zi_prfrdsrvc4custcn WITH PRIVILEGED ACCESS
      FOR ALL ENTRIES IN @lt_customer              "#EC CI_NO_TRANSFORM
      WHERE CustomerClassification = @lt_customer-customerclassification
      INTO TABLE @lt_prfrdsrvc.

    IF lt_prfrdsrvc IS NOT INITIAL.
      SELECT prfrdsrvc, surchrg                    "#EC CI_NO_TRANSFORM
        FROM ZI_PrfrdSrvSurchrg WITH PRIVILEGED ACCESS
        FOR ALL ENTRIES IN @lt_prfrdsrvc
        WHERE prfrdsrvc = @lt_prfrdsrvc-prfrdsrvc
        INTO TABLE @lt_prfrdsrvc_surcharge.
    ENDIF.

    LOOP AT lt_salesorder_pre ASSIGNING FIELD-SYMBOL(<ls_salesorder_pre>).

      READ TABLE lt_customer ASSIGNING FIELD-SYMBOL(<ls_customer>)
        WITH KEY customer = <ls_salesorder_pre>-SoldToParty.
      IF <ls_customer>-customerclassification IS NOT INITIAL.

        READ TABLE lt_prfrdsrvc ASSIGNING FIELD-SYMBOL(<ls_prfrdsrvc>)
          WITH KEY customerclassification = <ls_customer>-customerclassification.
        IF sy-subrc = 0.
          READ TABLE lt_prfrdsrvc_surcharge ASSIGNING FIELD-SYMBOL(<ls_prfrdsrvc_surcharge>)
            WITH KEY prfrdsrvc = <ls_prfrdsrvc>-prfrdsrvc.

          IF <ls_prfrdsrvc_surcharge>-surchrg IS NOT INITIAL.
            lv_conditionrateamount = <ls_salesorder_pre>-TotalNetAmount * <ls_prfrdsrvc_surcharge>-surchrg DIV 100.

            INSERT VALUE #( %tky = <ls_salesorder_pre>-%tky
                            %target             = VALUE #( (
                            %data               = VALUE #( conditiontype       = 'DRV1' "Surcharge price condition
                                                           conditionrateamount = lv_conditionrateamount
                                                           conditioncurrency   = <ls_salesorder_pre>-TransactionCurrency )
                           ) ) ) INTO TABLE lt_header_surcharge.
          ENDIF.
        ENDIF.
      ENDIF.

      INSERT VALUE #( %tky = <ls_salesorder_pre>-%tky
                      %data-DeliveryBlockReason = space )
                    INTO TABLE lt_update.

      "header text
      INSERT VALUE #( %tky = <ls_salesorder_pre>-%tky
                      %target             = VALUE #( (
                      %data               = VALUE #( languageforedit   = 'EN'
                                                     longtextidforedit = 'TX01'
                                                      longtext          = 'Order has been reviewed.' )
                     ) ) ) INTO TABLE lt_header_text.

    ENDLOOP.

    MODIFY ENTITIES OF i_salesordertp IN LOCAL MODE
      ENTITY SalesOrder
         CREATE BY \_pricingelement AUTO FILL CID FIELDS ( conditiontype
                                                           conditionrateamount
                                                           conditioncurrency ) WITH lt_header_surcharge
         CREATE BY \_Text AUTO FILL CID FIELDS ( languageforedit
                                                 longtextidforedit
                                                 longtext ) WITH lt_header_text
         UPDATE FIELDS ( DeliveryBlockReason ) WITH lt_update
    "response parameters
    MAPPED   DATA(ls_mapped)
    FAILED   DATA(ls_failed)                                                                                                          ##NEEDED
    REPORTED DATA(ls_reported).

    READ ENTITIES OF i_salesordertp IN LOCAL MODE
      ENTITY salesorder
         ALL FIELDS WITH
         CORRESPONDING #( it_keys )
       RESULT DATA(lt_salesorder).

    result = VALUE #( FOR salesorder IN lt_salesorder ( %tky   = salesorder-%tky
                                                        %param = CORRESPONDING #( salesorder ) ) ).

  ENDMETHOD.


ENDCLASS.

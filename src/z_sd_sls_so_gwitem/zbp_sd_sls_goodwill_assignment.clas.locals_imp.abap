CLASS lhc_salesorder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF co_goodwillitemstatus,
        not_relevant   TYPE zsd_sls_goodwillitem_status VALUE 'A',
        to_be_reviewed TYPE zsd_sls_goodwillitem_status VALUE 'B',
        granted        TYPE zsd_sls_goodwillitem_status VALUE 'C',
      END OF co_goodwillitemstatus.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR SalesOrder RESULT result.
    METHODS zz_add_goodwill_item FOR MODIFY
      IMPORTING it_keys FOR ACTION SalesOrder~zz_add_goodwill_item RESULT result.

ENDCLASS.

CLASS lhc_salesorder IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF I_SalesOrderTP IN LOCAL MODE
      ENTITY SalesOrder
      FIELDS ( zz_goodwillitemstatus_sdh )
        WITH CORRESPONDING #( keys )
          RESULT DATA(lt_result_salesorder).

    result = VALUE #( FOR ls_salesorder IN lt_result_salesorder ( %tky = ls_salesorder-%tky
                                                                  %features-%action-zz_add_goodwill_item = COND #( WHEN ls_salesorder-zz_goodwillitemstatus_sdh = co_goodwillitemstatus-to_be_reviewed
                                                                                                               THEN if_abap_behv=>fc-o-enabled
                                                                                                               ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.


  METHOD zz_add_goodwill_item.

    LOOP AT it_keys REFERENCE INTO DATA(lr_key).

      MODIFY ENTITIES OF i_salesordertp IN LOCAL MODE
        ENTITY SalesOrder
          CREATE BY \_item
            FIELDS ( Product
                     RequestedQuantity
                     SalesOrderItemCategory )
            WITH VALUE #( ( SalesOrder = lr_key->%tky-SalesOrder
                            %target    = VALUE #( ( %cid                   = 'free_item_id'
                                                    Product                = lr_key->%param-Product
                                                    RequestedQuantity      = '1'
                                                    SalesOrderItemCategory = 'CBLN' ) ) ) ) "Free of Expense Item
        UPDATE FIELDS ( zz_goodwillitemstatus_sdh ) WITH VALUE #(
                     ( %tky                            = lr_key->%tky
                       %data-zz_goodwillitemstatus_sdh = co_goodwillitemstatus-granted
                     ) )
      "response parameters
      MAPPED   DATA(ls_mapped)
      FAILED   DATA(ls_failed)                                                                                                          ##NEEDED
      REPORTED DATA(ls_reported).
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

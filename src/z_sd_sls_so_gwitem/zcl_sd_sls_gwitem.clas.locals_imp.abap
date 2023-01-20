CLASS lhc_goodwillitem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES:
      productlist TYPE SORTED TABLE OF i_product WITH UNIQUE KEY Product.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR GoodwillItem
        RESULT result,
      validateProduct FOR VALIDATE ON SAVE
        IMPORTING keys FOR GoodwillItem~validateProduct,
      check_product_exists
        IMPORTING product      TYPE zsd_sls_i_gwitemtp-Product
        RETURNING VALUE(exist) TYPE abap_boolean.
ENDCLASS.

CLASS lhc_goodwillitem IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD validateProduct.

    DATA lt_product TYPE SORTED TABLE OF i_product WITH UNIQUE KEY Product.

    READ ENTITIES OF zsd_sls_i_gwitemtp IN LOCAL MODE
      ENTITY GoodwillItem
        FIELDS ( Product )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_gwitem_product).

    " Optimization of DB select: extract distinct non-initial product IDs
    lt_product = CORRESPONDING #( lt_gwitem_product DISCARDING DUPLICATES MAPPING Product = Product EXCEPT * ).
    DELETE lt_product WHERE Product IS INITIAL.


    " Raise message for non existing product id
    LOOP AT lt_gwitem_product INTO DATA(ls_gwitem_product).

      APPEND VALUE #(  %tky                 = ls_gwitem_product-%tky
                       %state_area          = 'VALIDATE_PRODUCT' ) TO reported-goodwillitem.

      IF ls_gwitem_product-Product IS INITIAL.

        APPEND VALUE #(  %tky = ls_gwitem_product-%tky ) TO failed-goodwillitem.

        APPEND VALUE #(  %tky                 = ls_gwitem_product-%tky
                         %state_area          = 'VALIDATE_PRODUCT'
                         %msg                 = new_message( id       = 'ZSD_SLS_GWITEM_MSG'
                                                             number   = '002'
                                                             severity = if_abap_behv_message=>severity-error )
                         %element-Product  = if_abap_behv=>mk-on ) TO reported-goodwillitem.

      ELSEIF NOT check_product_exists( ls_gwitem_product-Product ).

        APPEND VALUE #(  %tky = ls_gwitem_product-%tky ) TO failed-goodwillitem.

        APPEND VALUE #(  %tky                 = ls_gwitem_product-%tky
                         %state_area          = 'VALIDATE_PRODUCT'
                         %msg                 = new_message( id       = 'ZSD_SLS_GWITEM_MSG'
                                                             number   = '001'
                                                             v1       = ls_gwitem_product-Product
                                                             severity = if_abap_behv_message=>severity-error )
                         %element-Product  = if_abap_behv=>mk-on ) TO reported-goodwillitem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD check_product_exists. "imports the goodwill item product

    SELECT SINGLE 'X'
    FROM I_Product WITH PRIVILEGED ACCESS
    WHERE Product = @product
    INTO @exist.


  ENDMETHOD.

ENDCLASS.

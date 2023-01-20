CLASS zcl_sd_sls_modify_head DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_sd_sls_modify_head .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sd_sls_modify_head IMPLEMENTATION.


  METHOD if_sd_sls_modify_head~modify_fields.

    move-CORRESPONDING salesdocument_extension_in to salesdocument_extension_out.


    clear salesdocument_extension_out-zz_grossamount_sdh.

    LOOP at salesdocumentitems ASSIGNING FIELD-SYMBOL(<item>).
      salesdocument_extension_out-zz_grossamount_sdh += <item>-netamount.
    endloop.

    salesdocument_extension_out-zz_grossamount_sdh += '0.19' * salesdocument_extension_out-zz_grossamount_sdh.

    salesdocument_extension_out-zz_grossamountcurrency_sdh = salesdocument-transactioncurrency.

  ENDMETHOD.
ENDCLASS.

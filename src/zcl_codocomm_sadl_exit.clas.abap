CLASS zcl_codocomm_sadl_exit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  interfaces: IF_SADL_EXIT_CALC_ELEMENT_READ.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_codocomm_sadl_exit IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
   LOOP AT it_original_data ASSIGNING FIELD-SYMBOL(<fs_orgiginal_data>).
      ASSIGN COMPONENT 'ZZ_CreateThread_SDH' OF STRUCTURE ct_calculated_data[ sy-tabix ] TO FIELD-SYMBOL(<fs_temp>).
      <fs_temp> = 'Hallo'.

    ENDLOOP.
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.

ENDCLASS.

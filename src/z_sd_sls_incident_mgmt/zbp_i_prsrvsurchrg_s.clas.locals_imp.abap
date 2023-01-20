CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TABLE_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_table_cts( table_entity_relations = VALUE #(
                                         ( entity = 'PrfrdSrvSurchrg' table = 'ZSDPRSRVSURCHRG' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_PRFRDSRVSURCHRG_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR PreferredServiceAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION PreferredServiceAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR PreferredServiceAll
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_PRFRDSRVSURCHRG_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
        iv_objectname = 'ZSDPRSRVSURCHRG'
        iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    DATA(transport_service) = cl_bcfg_cd_reuse_api_factory=>get_transport_service_instance(
                                iv_objectname = 'ZSDPRSRVSURCHRG'
                                iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table ).
    IF transport_service->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF ZI_PrfrdSrvSurchrg_S IN LOCAL MODE
    ENTITY PreferredServiceAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_PrfrdSrvSurchrg = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_PrfrdSrvSurchrg_S IN LOCAL MODE
      ENTITY PreferredServiceAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF ZI_PrfrdSrvSurchrg_S IN LOCAL MODE
      ENTITY PreferredServiceAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_PRFRDSRVSURCHRG' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_PRFRDSRVSURCHRG_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_PRFRDSRVSURCHRG_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-PreferredServiceAll INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_PRFRDSRVSURCHRG DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR PrfrdSrvSurchrg~ValidateTransportRequest,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR PrfrdSrvSurchrg
        RESULT result,
      COPYPRFRDSRVSURCHRG FOR MODIFY
        IMPORTING
          KEYS FOR ACTION PrfrdSrvSurchrg~CopyPrfrdSrvSurchrg,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR PrfrdSrvSurchrg
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR PrfrdSrvSurchrg
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_PRFRDSRVSURCHRG IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE ZI_PrfrdSrvSurchrg_S.
    SELECT SINGLE TransportRequestID
      FROM ZSDPRSRVSURC_D_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = 'ZSDPRSRVSURCHRG'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-PrfrdSrvSurchrg ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = 'ZSDPRSRVSURCHRG'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
  METHOD COPYPRFRDSRVSURCHRG.
    DATA new_PrfrdSrvSurchrg TYPE TABLE FOR CREATE ZI_PrfrdSrvSurchrg_S\_PrfrdSrvSurchrg.

    READ ENTITIES OF ZI_PrfrdSrvSurchrg_S IN LOCAL MODE
      ENTITY PrfrdSrvSurchrg
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ref_PrfrdSrvSurchrg)
      FAILED DATA(read_failed).

    LOOP AT ref_PrfrdSrvSurchrg ASSIGNING FIELD-SYMBOL(<ref_PrfrdSrvSurchrg>).
      DATA(key) = keys[ KEY draft %TKY = <ref_PrfrdSrvSurchrg>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_PrfrdSrvSurchrg>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_PrfrdSrvSurchrg>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_PrfrdSrvSurchrg> EXCEPT
            Lastchangedat
            Lastchangedby
            Locallastchangedat
            Prfrdsrvc
            SingletonID
        ) ) )
      ) TO new_PrfrdSrvSurchrg ASSIGNING FIELD-SYMBOL(<new_PrfrdSrvSurchrg>).
      <new_PrfrdSrvSurchrg>-%TARGET[ 1 ]-Prfrdsrvc = key-%PARAM-Prfrdsrvc.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_PrfrdSrvSurchrg_S IN LOCAL MODE
      ENTITY PreferredServiceAll CREATE BY \_PrfrdSrvSurchrg
      FIELDS (
               Prfrdsrvc
               Surchrg
             ) WITH new_PrfrdSrvSurchrg
      MAPPED DATA(mapped_create)
      FAILED failed
      REPORTED reported.

    mapped-PrfrdSrvSurchrg = mapped_create-PrfrdSrvSurchrg.
    INSERT LINES OF read_failed-PrfrdSrvSurchrg INTO TABLE failed-PrfrdSrvSurchrg.

    reported-PrfrdSrvSurchrg = VALUE #( FOR created IN mapped-PrfrdSrvSurchrg (
                                               %CID = created-%CID
                                               %ACTION-CopyPrfrdSrvSurchrg = if_abap_behv=>mk-on
                                               %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                               %PATH-PreferredServiceAll-%IS_DRAFT = created-%IS_DRAFT
                                               %PATH-PreferredServiceAll-SingletonID = 1 ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_PRFRDSRVSURCHRG' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-CopyPrfrdSrvSurchrg = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    result = VALUE #( FOR row IN keys ( %TKY = row-%TKY
                                        %ACTION-CopyPrfrdSrvSurchrg = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
   ) ).
  ENDMETHOD.
ENDCLASS.

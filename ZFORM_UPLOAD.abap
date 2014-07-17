*&---------------------------------------------------------------------*
*&  Include           ZFORM_UPLOAD
*&---------------------------------------------------------------------*
FORM matchcode_explorateur_windows .

  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      def_filename     = space
      def_path         = p_fic
      mask             = ',*.csv  ,*.csv.'
    IMPORTING
      filename         = p_fic
    EXCEPTIONS
      inv_winsys       = 04
      no_batch         = 08
      selection_cancel = 12
      selection_error  = 16.

ENDFORM.                    " MATCHCODE_EXPLORATEUR_WINDOWS
*&---------------------------------------------------------------------*
*&      Form  EXTRACTION_VALEURS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM extraction_valeurs .

  DATA: i_text_data       TYPE truxs_t_text_data,
        v_filename_string TYPE string.

  v_filename_string = p_fic.

  CALL FUNCTION 'GUI_UPLOAD'
  EXPORTING
    filename                     = v_filename_string
    filetype                      = 'ASC'
    has_field_separator           = 'X'
*       HEADER_LENGTH                 = 0
*       READ_BY_LINE                  = 'X'
*       DAT_MODE                      = ' '
*       CODEPAGE                      = ' '
*       IGNORE_CERR                   = ABAP_TRUE
*       REPLACEMENT                   = '#'
*       CHECK_BOM                     = ' '
*       VIRUS_SCAN_PROFILE            =
*       NO_AUTH_CHECK                 = ' '
*     IMPORTING
*       FILELENGTH                    =
*       HEADER                        =
  TABLES
    data_tab                      = i_text_data
     EXCEPTIONS
       file_open_error               = 1
       file_read_error               = 2
       no_batch                      = 3
       gui_refuse_filetransfer       = 4
       invalid_type                  = 5
       no_authority                  = 6
       unknown_error                 = 7
       bad_data_format               = 8
       header_not_allowed            = 9
       separator_not_allowed         = 10
       header_too_long               = 11
       unknown_dp_error              = 12
       access_denied                 = 13
       dp_out_of_memory              = 14
       disk_full                     = 15
       dp_timeout                    = 16
       OTHERS                        = 17
          .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'TEXT_CONVERT_CSV_TO_SAP'
    EXPORTING
     i_field_seperator          = ';'
*     I_LINE_HEADER              =
      i_tab_raw_data             = i_text_data
*     I_FILENAME                 =
    TABLES
      i_tab_converted_data       = wt_tab
*   EXCEPTIONS
*     CONVERSION_FAILED          = 1
*     OTHERS                     = 2
            .
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.


ENDFORM.                    " EXTRACTION_VALEURS
*&---------------------------------------------------------------------*
*&      Form  ENREGISTRER_VALUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM enregistrer_value .

  LOOP AT wt_tab INTO wa_tab.

    CLEAR wa_resultat.
    MOVE wa_tab-p_num_a TO wa_resultat-material.
    MOVE wa_tab-p_type_a TO wa_resultat-matl_type.
    MOVE '1' TO wa_resultat-ind_sector.
    MOVE 'X' TO wa_resultat-basic_view.

    CLEAR wa_resultatbis.
    MOVE wa_tab-p_des_a TO wa_resultatbis-matl_desc.
    wa_resultatbis-langu = 'F'.


    APPEND wa_resultatbis TO wt_resultatbis.

    CLEAR wa_clientdata.
    wa_clientdata-base_uom_iso = 'PCE'.

    CLEAR wa_clientdatax.
    wa_clientdatax-base_uom_iso = 'X'.

*Utiliser ces données pour renseigner les structures du module
    CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
      EXPORTING
        headdata             = wa_resultat
        clientdata           = wa_clientdata
        clientdatax          = wa_clientdatax
*       PLANTDATA            =
*       PLANTDATAX           =
*       FORECASTPARAMETERS   =
*       FORECASTPARAMETERSX  =
*       PLANNINGDATA         =
*       PLANNINGDATAX        =
*       STORAGELOCATIONDATA  =
*       STORAGELOCATIONDATAX =
*       VALUATIONDATA        =
*       VALUATIONDATAX       =
*       WAREHOUSENUMBERDATA  =
*       WAREHOUSENUMBERDATAX =
*       SALESDATA            =
*       SALESDATAX           =
*       STORAGETYPEDATA      =
*       STORAGETYPEDATAX     =
*       FLAG_ONLINE          = ' '
*       FLAG_CAD_CALL        = ' '
*       NO_DEQUEUE           = ' '
*       NO_ROLLBACK_WORK     = ' '
      IMPORTING
        return               = wa_return
      TABLES
        materialdescription  = wt_resultatbis
*       UNITSOFMEASURE       =
*       UNITSOFMEASUREX      =
*       INTERNATIONALARTNOS  =
*       MATERIALLONGTEXT     =
*       TAXCLASSIFICATIONS   =
*       RETURNMESSAGES       =
*       PRTDATA              =
*       PRTDATAX             =
*       EXTENSIONIN          =
*       EXTENSIONINX         =
      .

  ENDLOOP.

  IF sy-subrc = 0.
    MESSAGE s001(00) WITH 'BRAVOOOO !!!!'.
  ENDIF.

ENDFORM.                    " ENREGISTRER_VALUE

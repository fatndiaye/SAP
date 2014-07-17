*&---------------------------------------------------------------------*
*& Report  ZGUI_UPLOAD_USR02
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zgui_upload_usr02.

INCLUDE zinclude_variable_upload.

INCLUDE zinclude_sc_upload.

INCLUDE zform_upload.

LOAD-OF-PROGRAM.

INITIALIZATION.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fic.

  PERFORM matchcode_explorateur_windows.

AT SELECTION-SCREEN OUTPUT.

AT USER-COMMAND.

START-OF-SELECTION.

  IF p_fic IS NOT INITIAL.

    PERFORM extraction_valeurs.
    PERFORM enregistrer_value.

  ENDIF.

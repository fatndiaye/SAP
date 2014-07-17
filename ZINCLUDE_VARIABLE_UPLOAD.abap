*&---------------------------------------------------------------------*
*&  Include           ZINCLUDE_VARIABLE_UPLOAD
*&---------------------------------------------------------------------*

DATA: BEGIN OF wt_tab OCCURS 0,
        p_num_a LIKE mara-matnr,
        p_type_a LIKE mara-mtart,
        p_des_a LIKE makt-maktx,
        END OF wt_tab.

DATA : wa_tab LIKE LINE OF wt_tab.

DATA : wt_resultatbis TYPE ztab_art,
       wa_resultatbis TYPE bapi_makt.
DATA : wa_return TYPE bapiret2.
DATA : wa_resultat TYPE bapimathead.
DATA : wa_clientdata TYPE bapi_mara.
DATA : wa_clientdatax TYPE bapi_marax.

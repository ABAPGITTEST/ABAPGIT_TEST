class ZTEST_PLANT definition
  public
  final
  create public .

public section.

  types:
    ty_materials TYPE STANDARD TABLE OF marc-matnr WITH EMPTY KEY .
  types:
    ty_descriptions TYPE STANDARD TABLE OF makt-maktx WITH EMPTY KEY .
  types:
    BEGIN OF ty_material_with_description,
        material    TYPE marc-matnr,
        description TYPE makt-maktx,
      END OF ty_material_with_description .
  types:
    ty_materials_with_description TYPE STANDARD TABLE OF ty_material_with_description WITH KEY material .

  methods CONSTRUCTOR
    importing
      !IM_PLANT type MARC-WERKS .
  methods SHOW_MATERIALS .
  PROTECTED SECTION.
private section.

  data PLANT type MARC-WERKS .
  data MATERIALS type TY_MATERIALS .
  data DESCRIPTIONS type TY_DESCRIPTIONS .
  data MATERIALS_WITH_DESCRIPTION type TY_MATERIALS_WITH_DESCRIPTION .
  data ALV type ref to CL_SALV_TABLE .

  methods GET_DESCRIPTIONS
    returning
      value(RT_DESCRIPTIONS) type TY_DESCRIPTIONS .
  methods GET_MATERIALS .
  methods PREPARE_ALV .
ENDCLASS.



CLASS ZTEST_PLANT IMPLEMENTATION.


  METHOD constructor.
    me->plant = im_plant.
  ENDMETHOD.


  METHOD get_descriptions.

    IF descriptions IS INITIAL.
      SELECT FROM makt
      FIELDS maktx
         FOR ALL ENTRIES IN @materials
       WHERE matnr = @materials-table_line
         AND spras = @sy-langu
        INTO TABLE @descriptions.
    ENDIF.

    rt_descriptions = descriptions.

  ENDMETHOD.


  METHOD get_materials.

    SELECT FROM marc
      FIELDS matnr
      WHERE werks = @plant
      INTO TABLE @materials.

  ENDMETHOD.


  METHOD prepare_alv.
*  TRY.
    cl_salv_table=>factory(
    IMPORTING
      r_salv_table = alv
    CHANGING
      t_table      = materials_with_description ).
*    CATCH cx_salv_msg.
*      RETURN.
*  ENDTRY.
  ENDMETHOD.


  METHOD SHOW_MATERIALS.

    DATA temp TYPE i.

    IF materials IS INITIAL.
      get_materials( ).
    ENDIF.

    IF descriptions IS INITIAL.
      get_descriptions( ).
    ENDIF.

    CLEAR materials_with_description.
    LOOP AT materials REFERENCE INTO DATA(material).
      DATA(index) = sy-tabix.

      INSERT INITIAL LINE
        INTO TABLE materials_with_description
        REFERENCE INTO DATA(material_with_description).

      material_with_description->description =
        VALUE #( descriptions[ index ] OPTIONAL ).
      material_with_description->material = material->*.

    ENDLOOP.

    prepare_alv( ).

    TEST-SEAM display_alv.
      alv->display( ).
    END-TEST-SEAM.

  ENDMETHOD.
ENDCLASS.

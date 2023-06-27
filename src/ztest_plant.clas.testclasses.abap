CLASS ztest_Plant_Aut DEFINITION
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CONSTANTS plant TYPE marc-werks VALUE 'TEST'.

    CLASS-DATA: test_enviroment  TYPE REF TO if_osql_test_environment.

    CLASS-METHODS: class_setup.

    DATA: expected_results TYPE ztest_plant=>ty_materials_with_description.

    METHODS:
      setup,
      get_Materials FOR TESTING,
      get_Descriptions FOR TESTING,
      get_Materials_With_Description FOR TESTING,
      show_Materials FOR TESTING.
ENDCLASS.
CLASS ztest_plant DEFINITION LOCAL FRIENDS ztest_Plant_Aut.

CLASS ztest_Plant_Aut IMPLEMENTATION.

  METHOD class_setup.
    test_enviroment = cl_osql_test_environment=>create(
      i_dependency_list =  VALUE #(
        ( 'MARC' )
        ( 'MAKT' )
      ) ).
  ENDMETHOD.

  METHOD setup.

    DATA: dummy_marc TYPE STANDARD TABLE OF marc,
          dummy_makt TYPE STANDARD TABLE OF makt.

    dummy_marc = VALUE #(
      ( matnr = 'MAT_1' werks = plant )
      ( matnr = 'MAT_2' werks = plant )
      ( matnr = 'MAT_3' werks = plant )
    ).

    dummy_makt = VALUE #(
      ( matnr = 'MAT_3' maktx = 'DESC_3' spras = sy-langu )
      ( matnr = 'MAT_2' maktx = 'DESC_2' spras = sy-langu )
      ( matnr = 'MAT_1_X' maktx = 'DESC_1_X' spras = 'DE' )
      ( matnr = 'MAT_1' maktx = 'DESC_1' spras = sy-langu )
    ).

    expected_results = VALUE #(
      ( material = 'MAT_1' description = 'DESC_1' )
      ( material = 'MAT_2' description = 'DESC_2' )
      ( material = 'MAT_3' description = 'DESC_3' )
    ).

    test_enviroment->clear_doubles( ).

    test_enviroment->insert_test_data( dummy_makt ).
    test_enviroment->insert_test_data( dummy_marc ).

  ENDMETHOD.

  METHOD get_Descriptions.

    DATA(ztest_plant_instance) = NEW ztest_plant( plant ).

    ztest_plant_instance->get_materials( ).
    ztest_plant_instance->get_descriptions( ).

    "Check if all descriptions gathered are also in the expected results
    LOOP AT ztest_plant_instance->descriptions REFERENCE INTO DATA(description).
      cl_abap_unit_assert=>assert_equals(
        act = VALUE #( expected_results[ description = description->* ]-description OPTIONAL )
        exp = description->*
        msg = 'Description "' && description->* && '" was not expected'
      ).
    ENDLOOP.


  ENDMETHOD.


  METHOD get_Materials.

    DATA(ztest_plant_instance) = NEW ztest_plant( plant ).

    ztest_plant_instance->get_materials( ).

    "Check if all materials gathered are also in the expected results
    LOOP AT ztest_plant_instance->materials REFERENCE INTO DATA(material).
      cl_abap_unit_assert=>assert_equals(
        act = VALUE #( expected_results[ material = material->* ]-material OPTIONAL )
        exp = material->*
        msg = 'Material "' && material->* && '" was not expected'
      ).
    ENDLOOP.

  ENDMETHOD.

  METHOD get_Materials_With_Description.

    DATA(ztest_plant_instance) = NEW ztest_plant( plant ).
    ztest_plant_instance->get_materials( ).
    ztest_plant_instance->get_descriptions( ).
    ztest_plant_instance->get_materials_with_description( ).

    LOOP AT ztest_plant_instance->materials_with_description
      REFERENCE INTO DATA(material_with_description).
      cl_abap_unit_assert=>assert_not_initial(
        act = VALUE #(
                expected_results[
                  material = material_with_description->material
                  description = material_with_description->description ] OPTIONAL )
        msg = 'Material description combination is wrong'
      ).
    ENDLOOP.

  ENDMETHOD.

  METHOD show_Materials.
    DATA(ztest_plant_instance) = NEW ztest_plant( plant ).

    TEST-INJECTION display_alv.

    END-TEST-INJECTION.

    ztest_plant_instance->show_materials( ).

    cl_abap_unit_assert=>assert_not_initial(
      EXPORTING
        act              = ztest_plant_instance->alv
        msg              = 'Failed to create ALV' ).

  ENDMETHOD.

ENDCLASS.

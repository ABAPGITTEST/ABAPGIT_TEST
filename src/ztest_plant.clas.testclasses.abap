CLASS ztest_Plant_Aut DEFINITION
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CONSTANTS plant TYPE marc-werks VALUE 'TEST'.

    DATA: ztest_plant_instance TYPE REF TO ztest_plant,
          test_enviroment      TYPE REF TO if_osql_test_environment.

    METHODS: setup,
      get_Descriptions FOR TESTING,
      get_Materials FOR TESTING,
      get_Materials_With_Description FOR TESTING.
ENDCLASS.


CLASS ztest_Plant_Aut IMPLEMENTATION.

  METHOD setup.

    DATA: dummy_marc TYPE STANDARD TABLE OF marc,
          dummy_makt TYPE STANDARD TABLE OF makt.

    ztest_plant_instance = NEW ztest_plant( plant ).

    test_enviroment = cl_osql_test_environment=>create(
      i_dependency_list =  VALUE #(
        ( 'MARC' )
        ( 'MAKT' )
      ) ).

    dummy_marc = VALUE #(
      ( matnr = 'MAT_1' werks = plant )
      ( matnr = 'MAT_2' werks = plant )
      ( matnr = 'MAT_3' werks = plant )
    ).

    dummy_makt = VALUE #(
      ( matnr = 'MAT_1' maktx = 'DESC_1' spras = sy-langu )
      ( matnr = 'MAT_1_X' maktx = 'DESC_1_X' spras = 'DE' )
      ( matnr = 'MAT_3' maktx = 'DESC_3' spras = sy-langu )
      ( matnr = 'MAT_2' maktx = 'DESC_2' spras = sy-langu )
    ).

    test_enviroment->insert_test_data( dummy_makt ).
    test_enviroment->insert_test_data( dummy_marc ).

  ENDMETHOD.

  METHOD get_Descriptions.



  ENDMETHOD.


  METHOD get_Materials.



  ENDMETHOD.


  METHOD get_Materials_With_Description.



  ENDMETHOD.




ENDCLASS.

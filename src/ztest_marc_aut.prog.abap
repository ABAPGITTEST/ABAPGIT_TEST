*&---------------------------------------------------------------------*
*& Include          ZTEST_MARC_AUT
*&---------------------------------------------------------------------*

CLASS ztest_marc_aut DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.

  PRIVATE SECTION.
    DATA:
      f_Cut TYPE REF TO ztest_Plant.  "class under test

    METHODS: get_Descriptions FOR TESTING.
    METHODS: get_Materials FOR TESTING.
    METHODS: get_Materials_With_Description FOR TESTING.
ENDCLASS.       "ztest_Plant_Aut


CLASS ztest_marc_aut IMPLEMENTATION.

  METHOD get_Descriptions.



  ENDMETHOD.


  METHOD get_Materials.



  ENDMETHOD.


  METHOD get_Materials_With_Description.



  ENDMETHOD.




ENDCLASS.

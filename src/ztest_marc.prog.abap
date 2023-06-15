*&---------------------------------------------------------------------*
*& Report ZTEST_MARC
*&---------------------------------------------------------------------*
*& This is a test report to showcase ATC checks and Unit testing
*$ Don't take as a reference, logic is not correct
*&---------------------------------------------------------------------*
REPORT ztest_marc.

INCLUDE ztest_marc_aut.

PARAMETERS: plant TYPE marc-werks.


START-OF-SELECTION.

  DATA(ztest_plant) = NEW ztest_plant( plant ).

  ztest_plant->show_materials( ).

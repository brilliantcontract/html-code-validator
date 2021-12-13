create or replace NONEDITIONABLE PACKAGE tidy_html_snippet_test_pkg AS 

    --%suite(Test tidy HTML snippet package.)
    
    --%test(Test remove intellectual property symbols or codes.)
    PROCEDURE test_remove_intellectual_property_symbols_or_codes;
    
    --%test(Remove not allowed HTML tag attributes.)
    PROCEDURE test_remove_not_allowed_html_tag_attributes;
    
    --%test(Remove not allowed HTML tags.)
    PROCEDURE test_remove_not_allowed_html_tags;
    
    --%test(Unify HTML head tag levels.)
    PROCEDURE test_unify_html_head_tag_levels;
    
    --%test(Lower case all HTML tags and their attributes.)
    --%disabled
    PROCEDURE test_lower_case_all_html_tags_and_their_attributes;
    
    --%test(Remove empty HTML tags.)
    PROCEDURE test_remove_empty_html_tags;
    
    --#test(Convert UL list to HTML table.)
    PROCEDURE test_convert_ul_list_to_html_table;
    
    --#test(Tidy HTML table.)
    PROCEDURE test_tidy_html_table;
    
    --#test(Create headres.)
    PROCEDURE test_create_headers;

END tidy_html_snippet_test_pkg;
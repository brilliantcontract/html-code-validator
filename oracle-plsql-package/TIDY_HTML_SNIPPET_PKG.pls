create or replace NONEDITIONABLE PACKAGE tidy_html_snippet_pkg AS 

    FUNCTION tidy(i_html_snippet IN CLOB) RETURN CLOB;

    FUNCTION tidy(i_html_snippet IN VARCHAR2) RETURN CLOB;

END tidy_html_snippet_pkg;
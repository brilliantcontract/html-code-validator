create or replace NONEDITIONABLE PACKAGE BODY TIDY_HTML_SNIPPET_TEST_PKG AS

    PROCEDURE test_remove_intellectual_property_symbols_or_codes AS
        l_tided_html_snippet CLOB;
    BEGIN
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('Oracle™');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('Oracle'));
        
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('Oracle&reg;');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('Oracle'));
    END test_remove_intellectual_property_symbols_or_codes;

    PROCEDURE test_remove_not_allowed_html_tag_attributes AS
        l_tided_html_snippet CLOB;
    BEGIN
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<p id="p1">Hello Wold!</p>');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('<p>Hello Wold!</p>'));
        
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<p style="color: red;">Hello Wold!</p>');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('<p>Hello Wold!</p>'));
    END test_remove_not_allowed_html_tag_attributes;

    PROCEDURE test_remove_not_allowed_html_tags AS
        l_tided_html_snippet CLOB;
    BEGIN
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<p id="p1">Hello Wold!</p>');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('<p>Hello Wold!</p>'));
        
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<dt style="color: red;">Hello Wold!</dt><img src="picture.jpg" />');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('Hello Wold!'));
    END test_remove_not_allowed_html_tags;

    PROCEDURE test_unify_html_head_tag_levels AS
        l_tided_html_snippet CLOB;
    BEGIN
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<h5>Hello Wold!</h5>');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('<h5>Hello Wold!</h5>'));
        
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<h6 style="color: red;">Hello Wold!</h6><img src="picture.jpg" />');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('<h5>Hello Wold!</h5>'));
    END test_unify_html_head_tag_levels;

    PROCEDURE test_lower_case_all_html_tags_and_their_attributes AS
        l_tided_html_snippet CLOB;
    BEGIN
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<P>Hello Wold!</P>');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('<p>Hello Wold!</p>'));
        
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<P Style="color: red;">Hello Wold!</p><Img src="picture.jpg" />');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('<p>Hello Wold!</p>'));
    END test_lower_case_all_html_tags_and_their_attributes;

    PROCEDURE test_remove_empty_html_tags AS
        l_tided_html_snippet CLOB;
    BEGIN
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<p></p>');
        ut.expect(l_tided_html_snippet).to_be_empty();
        
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<p>Hello Wold!</p><p></p>');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('<p>Hello Wold!</p>'));
    END test_remove_empty_html_tags;

    PROCEDURE test_convert_ul_list_to_html_table AS
        l_tided_html_snippet CLOB;
    BEGIN
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<ul><li>Size: 7"</li></ul>');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('<table><tr><th>Size</th><td>7"</td></tr></table>'));
    END test_convert_ul_list_to_html_table;

    PROCEDURE test_tidy_html_table AS
        l_tided_html_snippet CLOB;
    BEGIN
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<table> <tr> <td>Size</td> <td>7"</td> </tr> </table>');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('<table class="description-table"><tr><th>Size</th><td>7"</td></tr></table>'));
    END test_tidy_html_table;

    PROCEDURE test_create_headers AS
        l_tided_html_snippet CLOB;
    BEGIN
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<p>Features</p><ul><li>The item</li></ul>');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('<p>Features</p><ul><li>The item</li></ul>'));
        
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('Features<ul><li>The item</li></ul>');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('<h5>Features</h5><ul><li>The item</li></ul>'));
        
        l_tided_html_snippet := tidy_html_snippet_pkg.tidy('<h5>Features</h5><ul><li>The item</li></ul>');
        ut.expect(l_tided_html_snippet).to_equal(to_clob('<h5>Features</h5><ul><li>The item</li></ul>'));
    END test_create_headers;

END TIDY_HTML_SNIPPET_TEST_PKG;
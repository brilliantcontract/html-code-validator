create or replace NONEDITIONABLE PACKAGE BODY tidy_html_snippet_pkg AS

    TYPE strings_tp IS TABLE OF VARCHAR2(4000);
    
    g_not_allowed_html_tag_attributes strings_tp := strings_tp();
    g_not_allowed_html_tags strings_tp := strings_tp();
    
    FUNCTION remove_intellectual_property_symbols_or_codes(i_html_snippet IN CLOB) RETURN CLOB;
    FUNCTION remove_not_allowed_html_tag_attributes(i_html_snippet IN CLOB) RETURN CLOB;
    FUNCTION remove_not_allowed_html_tags(i_html_snippet IN CLOB) RETURN CLOB;
    FUNCTION normalize_spaces(i_html_snippet IN CLOB) RETURN CLOB;
    FUNCTION unify_html_head_tag_levels(i_html_snippet IN CLOB) RETURN CLOB;
    FUNCTION lower_case_all_html_tags_and_their_attributes(i_html_snippet IN CLOB) RETURN CLOB;
    FUNCTION remove_empty_html_tags(i_html_snippet IN CLOB) RETURN CLOB;
    FUNCTION convert_text_to_ul_list(i_html_snippet IN CLOB) RETURN CLOB;
    FUNCTION convert_ul_list_to_html_table(i_html_snippet IN CLOB) RETURN CLOB;
    FUNCTION create_headers(i_html_snippet IN CLOB) RETURN CLOB;
    FUNCTION remove_twice_escaped_html_symbol_code(i_html_snippet IN CLOB) RETURN CLOB;
    FUNCTION tidy_html_table(i_html_snippet IN CLOB) RETURN CLOB;
    
    FUNCTION tidy(i_html_snippet IN CLOB) RETURN CLOB
    IS
        l_html_snippet CLOB;
    BEGIN
        l_html_snippet := i_html_snippet;
        
        -- Preparation data before HTML tidy.
        l_html_snippet := lower_case_all_html_tags_and_their_attributes(l_html_snippet);
        
        -- HTML tidy process.
        l_html_snippet := remove_intellectual_property_symbols_or_codes(l_html_snippet);
        l_html_snippet := remove_not_allowed_html_tag_attributes(l_html_snippet);
        l_html_snippet := unify_html_head_tag_levels(l_html_snippet);
        l_html_snippet := remove_not_allowed_html_tags(l_html_snippet);
        l_html_snippet := remove_empty_html_tags(l_html_snippet);
        l_html_snippet := remove_twice_escaped_html_symbol_code(l_html_snippet);
        l_html_snippet := convert_text_to_ul_list(l_html_snippet);
        l_html_snippet := convert_ul_list_to_html_table(l_html_snippet);
        l_html_snippet := tidy_html_table(l_html_snippet);
        l_html_snippet := tidy_html_table(l_html_snippet);
        l_html_snippet := create_headers(l_html_snippet);
        
        -- Format code for output.
        l_html_snippet := normalize_spaces(l_html_snippet);
        
        RETURN l_html_snippet;
    END tidy;
    
    FUNCTION tidy(i_html_snippet IN VARCHAR2) RETURN CLOB
    IS
        l_html_snippet CLOB;
    BEGIN
        l_html_snippet := tidy(TO_CLOB(i_html_snippet));
        
        RETURN l_html_snippet;
    END tidy;
    
    FUNCTION remove_twice_escaped_html_symbol_code(i_html_snippet IN CLOB) RETURN CLOB
    IS
        l_html_snippet CLOB;
    BEGIN
        l_html_snippet := i_html_snippet;
        
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '&amp;#([0-9a-zA-Z]{1,8});', '&#\1;', 1, 0, 'i');
        
        RETURN l_html_snippet;
    END remove_twice_escaped_html_symbol_code;
    
    FUNCTION remove_intellectual_property_symbols_or_codes(i_html_snippet IN CLOB) RETURN CLOB
    IS
        l_html_snippet CLOB;
    BEGIN
        l_html_snippet := i_html_snippet;
        
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '™|&trade;|&#8482;|&#x2122;|®|&reg;|&#174;|©|&copy;|&#169;|&#00A9;|℗|&#8471;|&#2117;|℠|&#8480;|&#2120;', '', 1, 0, 'i');
        
        RETURN l_html_snippet;
    END remove_intellectual_property_symbols_or_codes;
    
    FUNCTION remove_not_allowed_html_tag_attributes(i_html_snippet IN CLOB) RETURN CLOB
    IS
        l_html_snippet CLOB;
        l_attribute_name VARCHAR2(4000);
    BEGIN
        l_html_snippet := i_html_snippet;
        
        FOR l_index IN g_not_allowed_html_tag_attributes.FIRST .. g_not_allowed_html_tag_attributes.LAST
        LOOP
            l_attribute_name := g_not_allowed_html_tag_attributes(l_index);
            l_html_snippet := REGEXP_REPLACE(l_html_snippet, ' ' || l_attribute_name || '="[^"]+"| ' || l_attribute_name || '=''[^'']+''| ' || l_attribute_name || '=[^ ]+', '', 1, 0, 'i');
            l_html_snippet := REGEXP_REPLACE(l_html_snippet, '(<[^>]+ )' || l_attribute_name || '(.*>)', '\1\2', 1, 0, 'i');
        END LOOP;
        
        RETURN l_html_snippet;
    END remove_not_allowed_html_tag_attributes;
    
    FUNCTION remove_not_allowed_html_tags(i_html_snippet IN CLOB) RETURN CLOB
    IS
        l_html_snippet CLOB;
        l_tag_name VARCHAR2(4000);
    BEGIN
        l_html_snippet := i_html_snippet;
        
        FOR l_index IN g_not_allowed_html_tags.FIRST .. g_not_allowed_html_tags.LAST
        LOOP
            l_tag_name := g_not_allowed_html_tags(l_index);
            l_html_snippet := REGEXP_REPLACE(l_html_snippet, '</?' || l_tag_name || '( [^>]*)?>', ' ', 1, 0, 'i');
        END LOOP;
        
        RETURN l_html_snippet;
    END remove_not_allowed_html_tags;
    
    FUNCTION normalize_spaces(i_html_snippet IN CLOB) RETURN CLOB
    IS
        l_html_snippet CLOB;
    BEGIN
        l_html_snippet := i_html_snippet;
        
        l_html_snippet := TRIM(REGEXP_REPLACE(l_html_snippet, '\s*:\s*', ': '));
        l_html_snippet := TRIM(REGEXP_REPLACE(l_html_snippet, '\s*\.\s*', '. '));
        l_html_snippet := TRIM(REGEXP_REPLACE(l_html_snippet, '\s*,\s*', ', '));
        l_html_snippet := TRIM(REGEXP_REPLACE(l_html_snippet, '\s+', ' '));
        
        RETURN l_html_snippet;
    END normalize_spaces;
    
    FUNCTION unify_html_head_tag_levels(i_html_snippet IN CLOB) RETURN CLOB
    IS
        l_html_snippet CLOB;
    BEGIN
        l_html_snippet := i_html_snippet;
        
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '<(/?)h[0-9]( [^>]*)?>', '<\1h5>', 1, 0, 'i');
        
        RETURN l_html_snippet;
    END unify_html_head_tag_levels;
    
    -- Lower case all HTML tags and their attributes.
    -- Example: tag <P Class="The-Paragraph"> will be replaced with <p class="the-paragraph"> tag.
    FUNCTION lower_case_all_html_tags_and_their_attributes(i_html_snippet IN CLOB) RETURN CLOB
    IS
        l_html_snippet CLOB;
    BEGIN
        l_html_snippet := i_html_snippet;
        
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '(<[^>]+>)', LOWER('\1'), 1, 0, 'i');
        
        RETURN l_html_snippet;
    END lower_case_all_html_tags_and_their_attributes;
    
    -- Remove empty HTML tags.
    -- Example: <p></p>.
    FUNCTION remove_empty_html_tags(i_html_snippet IN CLOB) RETURN CLOB
    IS
        l_html_snippet CLOB;
    BEGIN
        l_html_snippet := i_html_snippet;
        
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*<p>(&nbsp;|\s*)*</p>\s*', ' ', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*<ul>(&nbsp;|\s*)*</ul>\s*', ' ', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*<li>(&nbsp;|\s*)*</li>\s*', ' ', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*<span>(&nbsp;|\s*)*</span>\s*', ' ', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*<div>(&nbsp;|\s*)*</div>\s*', ' ', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*<script>(&nbsp;|\s*)*</script>\s*', ' ', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*<noscript>(&nbsp;|\s*)*</noscript>\s*', ' ', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*<dt>(&nbsp;|\s*)*</dt>\s*', ' ', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*<dd>(&nbsp;|\s*)*</dd>\s*', ' ', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*<tbody>(&nbsp;|\s*)*</tbody>\s*', ' ', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*<tfoot>(&nbsp;|\s*)*</tfoot>\s*', ' ', 1, 0, 'i');
        
        RETURN l_html_snippet;
    END remove_empty_html_tags;
    
    FUNCTION convert_ul_list_to_html_table(i_html_snippet IN CLOB) RETURN CLOB
    IS
        l_html_snippet CLOB;
    BEGIN
        l_html_snippet := i_html_snippet;
        l_html_snippet := REPLACE(l_html_snippet, '<ul>', '<table>');
        l_html_snippet := REPLACE(l_html_snippet, '</ul>', '</table>');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '<li>([^:]+)\s*:\s*([^<]+)</li>', '<tr><th>\1</th><td>\2</td></tr>', 1, 0, 'i');
        
        -- Return UL if LI wasn't replaced with TH and TD tags.
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '<table>\s*<li', '<ul><li');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '</li>\s*</table>', '</li></ul>');
        
        RETURN l_html_snippet;
    END convert_ul_list_to_html_table;
    
    FUNCTION convert_text_to_ul_list(i_html_snippet IN CLOB) RETURN CLOB
    IS
        l_html_snippet CLOB;
    BEGIN
        l_html_snippet := i_html_snippet;
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '(&bull;|•)([^<]+?)<br( [^>]*)?>', '<li>\2</li>', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '(&bull;|•)([^<]+?)</p>', '<li>\2</li></p>', 1, 0, 'i');
        
        RETURN l_html_snippet;
    END convert_text_to_ul_list;
    
    FUNCTION create_headers(i_html_snippet IN CLOB) RETURN CLOB
    IS
        l_html_snippet CLOB;
    BEGIN
        l_html_snippet := i_html_snippet;
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '(^|>)([^<]+?[^>[:space:]])<ul( [^>]*)?>', '\1<h5>\2</h5><ul\3>', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '(^|>)([^<]+?[^>[:space:]])<table( [^>]*)?>', '\1<h5>\2</h5><table\3>', 1, 0, 'i');
        
        RETURN l_html_snippet;
    END create_headers;
    
    FUNCTION tidy_html_table(i_html_snippet IN CLOB) RETURN CLOB
    IS
        l_html_snippet CLOB;
    BEGIN
        l_html_snippet := i_html_snippet;
        
        -- Space normalization.
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*(</?table( [^>]*)?>)\s*', '\1', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*(</?thead( [^>]*)?>)\s*', '\1', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*(</?tbody( [^>]*)?>)\s*', '\1', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*(</?tfood( [^>]*)?>)\s*', '\1', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*(</?th( [^>]*)?>)\s*', '\1', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*(</?tr( [^>]*)?>)\s*', '\1', 1, 0, 'i');
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '\s*(</?td( [^>]*)?>)\s*', '\1', 1, 0, 'i');
        
        -- Replace <td> with <th> in HTML table.
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '<tr( [^>]*)?><td( [^>]*)?>([^<]*)</td>[\s\n]*<td( [^>]*)?>([^<]*)</td></tr>', '<tr\1><th\2>\3</th><td\4>\5</td></tr>', 1, 0, 'i');
        
        -- Add CSS class to HTML table.
        l_html_snippet := REGEXP_REPLACE(l_html_snippet, '<table( [^>]*)?>', '<table class="description-table">', 1, 0, 'i');
        
        RETURN l_html_snippet;
    END tidy_html_table;
    
    PROCEDURE push_attribute_into_not_allowed_html_tag_attributes(i_new_attribute VARCHAR2) AS
    BEGIN
        g_not_allowed_html_tag_attributes.EXTEND;
        g_not_allowed_html_tag_attributes(g_not_allowed_html_tag_attributes.LAST) := i_new_attribute;
    END push_attribute_into_not_allowed_html_tag_attributes;
    
    PROCEDURE push_tag_into_not_allowed_html_tags(i_new_tag VARCHAR2) AS
    BEGIN
        g_not_allowed_html_tags.EXTEND;
        g_not_allowed_html_tags(g_not_allowed_html_tags.LAST) := i_new_tag;
    END push_tag_into_not_allowed_html_tags;
    
    BEGIN
        -- Global attributes.
        push_attribute_into_not_allowed_html_tag_attributes('accesskey');
        push_attribute_into_not_allowed_html_tag_attributes('class');
        push_attribute_into_not_allowed_html_tag_attributes('contenteditable');
        push_attribute_into_not_allowed_html_tag_attributes('dir');
        push_attribute_into_not_allowed_html_tag_attributes('draggable');
        push_attribute_into_not_allowed_html_tag_attributes('hidden');
        push_attribute_into_not_allowed_html_tag_attributes('id');
        push_attribute_into_not_allowed_html_tag_attributes('lang');
        push_attribute_into_not_allowed_html_tag_attributes('spellcheck');
        push_attribute_into_not_allowed_html_tag_attributes('style');
        push_attribute_into_not_allowed_html_tag_attributes('tabindex');
        push_attribute_into_not_allowed_html_tag_attributes('title');
        push_attribute_into_not_allowed_html_tag_attributes('translate');
    
        -- XML attributes.
        push_attribute_into_not_allowed_html_tag_attributes('xmlns');
        
        -- Event handler content attributes.
        push_attribute_into_not_allowed_html_tag_attributes('onabort');
        push_attribute_into_not_allowed_html_tag_attributes('onauxclick');
        push_attribute_into_not_allowed_html_tag_attributes('onblur');
        push_attribute_into_not_allowed_html_tag_attributes('oncancel');
        push_attribute_into_not_allowed_html_tag_attributes('oncanplay');
        push_attribute_into_not_allowed_html_tag_attributes('oncanplaythrough');
        push_attribute_into_not_allowed_html_tag_attributes('onchange');
        push_attribute_into_not_allowed_html_tag_attributes('onclick');
        push_attribute_into_not_allowed_html_tag_attributes('onclose');
        push_attribute_into_not_allowed_html_tag_attributes('oncuechange');
        push_attribute_into_not_allowed_html_tag_attributes('ondblclick');
        push_attribute_into_not_allowed_html_tag_attributes('ondrag');
        push_attribute_into_not_allowed_html_tag_attributes('ondragend');
        push_attribute_into_not_allowed_html_tag_attributes('ondragenter');
        push_attribute_into_not_allowed_html_tag_attributes('ondragexit');
        push_attribute_into_not_allowed_html_tag_attributes('ondragleave');
        push_attribute_into_not_allowed_html_tag_attributes('ondragover');
        push_attribute_into_not_allowed_html_tag_attributes('ondragstart');
        push_attribute_into_not_allowed_html_tag_attributes('ondrop');
        push_attribute_into_not_allowed_html_tag_attributes('ondurationchange');
        push_attribute_into_not_allowed_html_tag_attributes('onemptied');
        push_attribute_into_not_allowed_html_tag_attributes('onended');
        push_attribute_into_not_allowed_html_tag_attributes('onerror');
        push_attribute_into_not_allowed_html_tag_attributes('onfocus');
        push_attribute_into_not_allowed_html_tag_attributes('oninput');
        push_attribute_into_not_allowed_html_tag_attributes('oninvalid');
        push_attribute_into_not_allowed_html_tag_attributes('onkeydown');
        push_attribute_into_not_allowed_html_tag_attributes('onkeypress');
        push_attribute_into_not_allowed_html_tag_attributes('onkeyup');
        push_attribute_into_not_allowed_html_tag_attributes('onload');
        push_attribute_into_not_allowed_html_tag_attributes('onloadeddata');
        push_attribute_into_not_allowed_html_tag_attributes('onloadedmetadata');
        push_attribute_into_not_allowed_html_tag_attributes('onloadend');
        push_attribute_into_not_allowed_html_tag_attributes('onloadstart');
        push_attribute_into_not_allowed_html_tag_attributes('onmousedown');
        push_attribute_into_not_allowed_html_tag_attributes('onmouseenter');
        push_attribute_into_not_allowed_html_tag_attributes('onmouseleave');
        push_attribute_into_not_allowed_html_tag_attributes('onmousemove');
        push_attribute_into_not_allowed_html_tag_attributes('onmouseout');
        push_attribute_into_not_allowed_html_tag_attributes('onmouseover');
        push_attribute_into_not_allowed_html_tag_attributes('onmouseup');
        push_attribute_into_not_allowed_html_tag_attributes('onwheel');
        push_attribute_into_not_allowed_html_tag_attributes('onpause');
        push_attribute_into_not_allowed_html_tag_attributes('onplay');
        push_attribute_into_not_allowed_html_tag_attributes('onplaying');
        push_attribute_into_not_allowed_html_tag_attributes('onprogress');
        push_attribute_into_not_allowed_html_tag_attributes('onratechange');
        push_attribute_into_not_allowed_html_tag_attributes('onreset');
        push_attribute_into_not_allowed_html_tag_attributes('onresize');
        push_attribute_into_not_allowed_html_tag_attributes('onscroll');
        push_attribute_into_not_allowed_html_tag_attributes('onseeked');
        push_attribute_into_not_allowed_html_tag_attributes('onseeking');
        push_attribute_into_not_allowed_html_tag_attributes('onselect');
        push_attribute_into_not_allowed_html_tag_attributes('onshow');
        push_attribute_into_not_allowed_html_tag_attributes('onstalled');
        push_attribute_into_not_allowed_html_tag_attributes('onsubmit');
        push_attribute_into_not_allowed_html_tag_attributes('onsuspend');
        push_attribute_into_not_allowed_html_tag_attributes('ontimeupdate');
        push_attribute_into_not_allowed_html_tag_attributes('ontoggle');
        push_attribute_into_not_allowed_html_tag_attributes('onvolumechange');
        push_attribute_into_not_allowed_html_tag_attributes('onwaiting');
        
        -- Attributes
        push_attribute_into_not_allowed_html_tag_attributes('abbr');
        push_attribute_into_not_allowed_html_tag_attributes('accept');
        push_attribute_into_not_allowed_html_tag_attributes('accept-charset ');
        push_attribute_into_not_allowed_html_tag_attributes('action');
        push_attribute_into_not_allowed_html_tag_attributes('allowfullscreen');
        push_attribute_into_not_allowed_html_tag_attributes('allowpaymentrequest');
        push_attribute_into_not_allowed_html_tag_attributes('alt');
        push_attribute_into_not_allowed_html_tag_attributes('async');
        push_attribute_into_not_allowed_html_tag_attributes('autocomplete');
        push_attribute_into_not_allowed_html_tag_attributes('autocomplete');
        push_attribute_into_not_allowed_html_tag_attributes('autofocus');
        push_attribute_into_not_allowed_html_tag_attributes('autoplay');
        push_attribute_into_not_allowed_html_tag_attributes('border');
        push_attribute_into_not_allowed_html_tag_attributes('charset');
        push_attribute_into_not_allowed_html_tag_attributes('checked');
        push_attribute_into_not_allowed_html_tag_attributes('cite');
        push_attribute_into_not_allowed_html_tag_attributes('cols');
        --push_attribute_into_not_allowed_html_tag_attributes('colspan');
        push_attribute_into_not_allowed_html_tag_attributes('content');
        push_attribute_into_not_allowed_html_tag_attributes('controls');
        push_attribute_into_not_allowed_html_tag_attributes('coords');
        push_attribute_into_not_allowed_html_tag_attributes('crossorigin');
        push_attribute_into_not_allowed_html_tag_attributes('data');
        push_attribute_into_not_allowed_html_tag_attributes('datetime');
        push_attribute_into_not_allowed_html_tag_attributes('default');
        push_attribute_into_not_allowed_html_tag_attributes('defer');
        push_attribute_into_not_allowed_html_tag_attributes('dirname');
        push_attribute_into_not_allowed_html_tag_attributes('disabled');
        push_attribute_into_not_allowed_html_tag_attributes('download');
        push_attribute_into_not_allowed_html_tag_attributes('enctype');
        push_attribute_into_not_allowed_html_tag_attributes('for');
        push_attribute_into_not_allowed_html_tag_attributes('form');
        push_attribute_into_not_allowed_html_tag_attributes('formaction');
        push_attribute_into_not_allowed_html_tag_attributes('formenctype');
        push_attribute_into_not_allowed_html_tag_attributes('formmethod');
        push_attribute_into_not_allowed_html_tag_attributes('formnovalidate');
        push_attribute_into_not_allowed_html_tag_attributes('formtarget');
        push_attribute_into_not_allowed_html_tag_attributes('headers');
        push_attribute_into_not_allowed_html_tag_attributes('height');
        push_attribute_into_not_allowed_html_tag_attributes('high');
        push_attribute_into_not_allowed_html_tag_attributes('href');
        push_attribute_into_not_allowed_html_tag_attributes('hreflang');
        push_attribute_into_not_allowed_html_tag_attributes('http-equiv');
        push_attribute_into_not_allowed_html_tag_attributes('ismap');
        push_attribute_into_not_allowed_html_tag_attributes('kind');
        push_attribute_into_not_allowed_html_tag_attributes('label');
        push_attribute_into_not_allowed_html_tag_attributes('list');
        push_attribute_into_not_allowed_html_tag_attributes('longdesc');
        push_attribute_into_not_allowed_html_tag_attributes('loop');
        push_attribute_into_not_allowed_html_tag_attributes('low');
        push_attribute_into_not_allowed_html_tag_attributes('manifest');
        push_attribute_into_not_allowed_html_tag_attributes('max');
        push_attribute_into_not_allowed_html_tag_attributes('maxlength');
        push_attribute_into_not_allowed_html_tag_attributes('media');
        push_attribute_into_not_allowed_html_tag_attributes('method');
        push_attribute_into_not_allowed_html_tag_attributes('min');
        push_attribute_into_not_allowed_html_tag_attributes('minlength');
        push_attribute_into_not_allowed_html_tag_attributes('multiple');
        push_attribute_into_not_allowed_html_tag_attributes('muted');
        push_attribute_into_not_allowed_html_tag_attributes('name');
        push_attribute_into_not_allowed_html_tag_attributes('nonce');
        push_attribute_into_not_allowed_html_tag_attributes('novalidate');
        push_attribute_into_not_allowed_html_tag_attributes('open');
        push_attribute_into_not_allowed_html_tag_attributes('optimum');
        push_attribute_into_not_allowed_html_tag_attributes('pattern');
        push_attribute_into_not_allowed_html_tag_attributes('placeholder');
        push_attribute_into_not_allowed_html_tag_attributes('poster');
        push_attribute_into_not_allowed_html_tag_attributes('preload');
        push_attribute_into_not_allowed_html_tag_attributes('readonly');
        push_attribute_into_not_allowed_html_tag_attributes('referrerpolicy');
        push_attribute_into_not_allowed_html_tag_attributes('rel');
        push_attribute_into_not_allowed_html_tag_attributes('required');
        push_attribute_into_not_allowed_html_tag_attributes('rev');
        push_attribute_into_not_allowed_html_tag_attributes('reversed');
        push_attribute_into_not_allowed_html_tag_attributes('rows');
        --push_attribute_into_not_allowed_html_tag_attributes('rowspan');
        push_attribute_into_not_allowed_html_tag_attributes('sandbox');
        push_attribute_into_not_allowed_html_tag_attributes('scope');
        push_attribute_into_not_allowed_html_tag_attributes('selected');
        push_attribute_into_not_allowed_html_tag_attributes('shape');
        push_attribute_into_not_allowed_html_tag_attributes('size');
        push_attribute_into_not_allowed_html_tag_attributes('sizes');
        --push_attribute_into_not_allowed_html_tag_attributes('span');
        push_attribute_into_not_allowed_html_tag_attributes('src');
        push_attribute_into_not_allowed_html_tag_attributes('srcdoc');
        push_attribute_into_not_allowed_html_tag_attributes('srclang');
        push_attribute_into_not_allowed_html_tag_attributes('srcset');
        push_attribute_into_not_allowed_html_tag_attributes('start');
        push_attribute_into_not_allowed_html_tag_attributes('step');
        push_attribute_into_not_allowed_html_tag_attributes('target');
        push_attribute_into_not_allowed_html_tag_attributes('type');
        push_attribute_into_not_allowed_html_tag_attributes('typemustmatch');
        push_attribute_into_not_allowed_html_tag_attributes('usemap');
        push_attribute_into_not_allowed_html_tag_attributes('value');
        push_attribute_into_not_allowed_html_tag_attributes('width');
        push_attribute_into_not_allowed_html_tag_attributes('wrap');
        
        -- Custom tag attributes.
        push_attribute_into_not_allowed_html_tag_attributes('itemscope');
        push_attribute_into_not_allowed_html_tag_attributes('itemprop');
        push_attribute_into_not_allowed_html_tag_attributes('itemtype');
        push_attribute_into_not_allowed_html_tag_attributes('data-url');
        push_attribute_into_not_allowed_html_tag_attributes('pan');
        
        
        
        push_tag_into_not_allowed_html_tags('a');             -- Hyperlink.
        push_tag_into_not_allowed_html_tags('abbr');          -- Abbreviation.
        push_tag_into_not_allowed_html_tags('address');       -- Contact information.
        push_tag_into_not_allowed_html_tags('area');          -- Hyperlink or dead area on an image map.
        push_tag_into_not_allowed_html_tags('article');       -- Self-contained syndicatable or reusable composition.
        push_tag_into_not_allowed_html_tags('aside');         -- Sidebar for tangentially related content.
        push_tag_into_not_allowed_html_tags('audio');         -- Audio player.
        push_tag_into_not_allowed_html_tags('b');             -- Keywords.
        push_tag_into_not_allowed_html_tags('base');          -- Base URL and default target browsing context for hyperlinks and forms.
        push_tag_into_not_allowed_html_tags('bdi');           -- Text directionality isolation.
        push_tag_into_not_allowed_html_tags('bdo');           -- Text directionality formatting.
        push_tag_into_not_allowed_html_tags('blockquote');    -- A section quoted from another source.
        push_tag_into_not_allowed_html_tags('body');          -- Document body.
        --push_tag_into_not_allowed_html_tags('br');          -- Line break, e.g., in poem or postal address.
        push_tag_into_not_allowed_html_tags('button');        -- Button control.
        push_tag_into_not_allowed_html_tags('canvas');        -- Scriptable bitmap canvas.
        push_tag_into_not_allowed_html_tags('caption');       -- Table caption.
        push_tag_into_not_allowed_html_tags('cite');          -- Title of a work.
        push_tag_into_not_allowed_html_tags('code');          -- Computer code.
        push_tag_into_not_allowed_html_tags('col');           -- Table column.
        push_tag_into_not_allowed_html_tags('colgroup');      -- Group of columns in a table.
        push_tag_into_not_allowed_html_tags('data');          -- Machine-readable equivalent.
        push_tag_into_not_allowed_html_tags('datalist');      -- Container for options for combo box control.
        push_tag_into_not_allowed_html_tags('dd');            -- Content for corresponding <dt> element(s).
        push_tag_into_not_allowed_html_tags('del');           -- A removal from the document.
        push_tag_into_not_allowed_html_tags('details');       -- Disclosure control for hiding details.
        push_tag_into_not_allowed_html_tags('dfn');           -- Defining instance.
        push_tag_into_not_allowed_html_tags('dialog');        -- Dialog box or window.
        push_tag_into_not_allowed_html_tags('div');           -- Generic flow container.
        push_tag_into_not_allowed_html_tags('dl');            -- Association list consisting of zero or more name-value groups.
        push_tag_into_not_allowed_html_tags('dt');            -- Legend for corresponding <dd> element(s).
        push_tag_into_not_allowed_html_tags('em');            -- Stress emphasis.
        push_tag_into_not_allowed_html_tags('embed');         -- Plugin.
        push_tag_into_not_allowed_html_tags('fieldset');      -- Group of form controls.
        push_tag_into_not_allowed_html_tags('figcaption');    -- Caption for <figure>.
        push_tag_into_not_allowed_html_tags('figure');        -- Figure with optional caption.
        push_tag_into_not_allowed_html_tags('footer');        -- Footer for a page or section.
        push_tag_into_not_allowed_html_tags('form');          -- User-submittable form.
        push_tag_into_not_allowed_html_tags('h1');            -- Section heading.
        push_tag_into_not_allowed_html_tags('h2');            -- Section heading.
        push_tag_into_not_allowed_html_tags('h3');            -- Section heading.
        push_tag_into_not_allowed_html_tags('h4');            -- Section heading.
        --push_tag_into_not_allowed_html_tags('h5');          -- Section heading.
        push_tag_into_not_allowed_html_tags('h6');            -- Section heading.
        push_tag_into_not_allowed_html_tags('head');          -- Container for document metadata.
        push_tag_into_not_allowed_html_tags('header');        -- Introductory or navigational aids for a page or section.
        push_tag_into_not_allowed_html_tags('hr');            -- Thematic break.
        push_tag_into_not_allowed_html_tags('html');          -- Root element.
        push_tag_into_not_allowed_html_tags('i');             -- Alternate voice.
        push_tag_into_not_allowed_html_tags('iframe');        -- Nested browsing context.
        push_tag_into_not_allowed_html_tags('img');           -- Image.
        push_tag_into_not_allowed_html_tags('input');         -- Form control.
        push_tag_into_not_allowed_html_tags('ins');           -- An addition to the document.
        push_tag_into_not_allowed_html_tags('kbd');           -- User input.
        push_tag_into_not_allowed_html_tags('label');         -- Caption for a form control.
        push_tag_into_not_allowed_html_tags('legend');        -- Caption for <fieldset>.
        --push_tag_into_not_allowed_html_tags('li');          -- List item.
        push_tag_into_not_allowed_html_tags('link');          -- Link metadata.
        push_tag_into_not_allowed_html_tags('main');          -- Main content of a document.
        push_tag_into_not_allowed_html_tags('map');           -- Image map.
        push_tag_into_not_allowed_html_tags('mark');          -- Highlight.
        push_tag_into_not_allowed_html_tags('meta');          -- Text metadata.
        push_tag_into_not_allowed_html_tags('meter');         -- Gauge.
        push_tag_into_not_allowed_html_tags('nav');           -- Section with navigational links.
        push_tag_into_not_allowed_html_tags('noscript');      -- Fallback content for script.
        push_tag_into_not_allowed_html_tags('object');        -- Image, nested browsing context, or plugin.
        push_tag_into_not_allowed_html_tags('ol');            -- Ordered list.
        push_tag_into_not_allowed_html_tags('optgroup');      -- Group of options in a list box.
        push_tag_into_not_allowed_html_tags('option');        -- Option in a list box or combo box control.
        push_tag_into_not_allowed_html_tags('output');        -- Calculated output value.
        --push_tag_into_not_allowed_html_tags('p');           -- Paragraph.
        push_tag_into_not_allowed_html_tags('param');         -- Parameter for <object>.
        push_tag_into_not_allowed_html_tags('picture');       -- Image.
        push_tag_into_not_allowed_html_tags('pre');           -- Block of preformatted text.
        push_tag_into_not_allowed_html_tags('progress');      -- Progress bar.
        push_tag_into_not_allowed_html_tags('q');             -- Quotation.
        push_tag_into_not_allowed_html_tags('rb');            -- Ruby base.
        push_tag_into_not_allowed_html_tags('rp');            -- Parenthesis for ruby annotation text.
        push_tag_into_not_allowed_html_tags('rt');            -- Ruby annotation text.
        push_tag_into_not_allowed_html_tags('rtc');           -- Ruby annotation text container.
        push_tag_into_not_allowed_html_tags('ruby');          -- Ruby annotation(s).
        push_tag_into_not_allowed_html_tags('s');             -- Inaccurate text.
        push_tag_into_not_allowed_html_tags('samp');          -- Computer output.
        push_tag_into_not_allowed_html_tags('script');        -- Embedded script.
        push_tag_into_not_allowed_html_tags('section');       -- Generic document or application section.
        push_tag_into_not_allowed_html_tags('select');        -- List box control.
        push_tag_into_not_allowed_html_tags('small');         -- Side comment.
        push_tag_into_not_allowed_html_tags('source');        -- Media source for <video> or <audio> or as image source for <picture>.
        push_tag_into_not_allowed_html_tags('span');          -- Generic phrasing container.
        push_tag_into_not_allowed_html_tags('strong');        -- Importance.
        push_tag_into_not_allowed_html_tags('style');         -- Embedded styling information.
        push_tag_into_not_allowed_html_tags('sub');           -- Subscript.
        push_tag_into_not_allowed_html_tags('summary');       -- Caption for <details>.
        push_tag_into_not_allowed_html_tags('sup');           -- Superscript
        --push_tag_into_not_allowed_html_tags('table');       -- Table.
        --push_tag_into_not_allowed_html_tags('tbody');       -- Group of rows in a table.
        --push_tag_into_not_allowed_html_tags('td');          -- Table cell.
        push_tag_into_not_allowed_html_tags('template');      -- Template.
        push_tag_into_not_allowed_html_tags('textarea');      -- Multiline text field.
        --push_tag_into_not_allowed_html_tags('tfoot');       -- Group of footer rows in a table.
        --push_tag_into_not_allowed_html_tags('th');          -- Table header cell.
        --push_tag_into_not_allowed_html_tags('thead');       -- Group of heading rows in a table.
        push_tag_into_not_allowed_html_tags('time');          -- Machine-readable equivalent of date- or time-related data.
        push_tag_into_not_allowed_html_tags('title');         -- Document title.
        --push_tag_into_not_allowed_html_tags('tr');          -- Table row.
        push_tag_into_not_allowed_html_tags('track');         -- Timed text track.
        push_tag_into_not_allowed_html_tags('u');             -- Keywords.
        --push_tag_into_not_allowed_html_tags('ul');          -- List.
        push_tag_into_not_allowed_html_tags('var');           -- Variable.
        push_tag_into_not_allowed_html_tags('video');         -- Video player.
        push_tag_into_not_allowed_html_tags('wbr');           -- Line breaking opportunity.
        
END tidy_html_snippet_pkg;

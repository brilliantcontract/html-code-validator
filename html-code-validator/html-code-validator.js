/**
 * This code is compatible with ECMAScript-262 Edition 5.1.
 * 
 * In order to validate HTML code you should call validateHtmlCode(htmlCode) function
 * with argument of HTML code. validateHtmlCode() will return an array of text messages 
 * where each message is found distinct issue in validated HTML code. If the array
 * is empty then no issues were found hence HTML code is valid.
 */
class HtmlCodeValidator {

    /**
     * Validate given HTML code against all rules.
     * 
     * @param {type} htmlCode
     * @return {Array|undefined|HtmlCodeValidator.validateHtmlCode.foundIssues}
     */
    validateHtmlCode(htmlCode) {
        var foundIssues = new Array();
        htmlCode = htmlCode.toUpperCase();

        // Look for miscellaneous issues in the HTML code.
        foundIssues.push(this.isHtmlCodeContainsIntellectualPropertySymbolsOrCodes(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsEmptyTags(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsTwiceEscapedHtmlSymbolCode(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsHiddenElements(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsBrokenCharacterEncoding(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsNotClosedTags(htmlCode));

        // Check validity of complex Table HTML tags in the HTML code.
        foundIssues.push(this.isTableTagHasRequiredCssClass(htmlCode));
        foundIssues.push(this.isTableTagHasTdStrongTagsSequence(htmlCode));
        foundIssues.push(this.isTableTagHasTdTagInsideTheadTag(htmlCode));

        // Look for restricted HTML tags in the HTML code.
        foundIssues.push(this.isHtmlCodeContainsDivTag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsSpanTag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsSTag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsStrongTag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsBTag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsIframeTag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsFrameTag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsObjectTag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsEmbedTag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsScriptTag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsNoscriptTag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsH1Tag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsH2Tag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsH3Tag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsH4Tag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsH6Tag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsImgTag(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsATag(htmlCode));

        // Look for restricted HTML attributes in the HTML code.
        foundIssues.push(this.isHtmlCodeContainsClassAttribute(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsIdAttribute(htmlCode));
        foundIssues.push(this.isHtmlCodeContainsStyleAttribute(htmlCode));

        // Remove empty elements from the result array.
        foundIssues = foundIssues.filter(Boolean);

        return foundIssues;
    }

    /**
     * Table tag have to have a Class attribute with "description-table" value.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isTableTagHasRequiredCssClass(htmlCode) {
        var message = "- HTML code contains a Table tag without mandatory \"description-table\" CSS class.";
        var regularExpressionOfTable = new RegExp("<TABLE");
        var regularExpressionOfMandatoryClass = new RegExp("<TABLE CLASS=(\"|'|)DESCRIPTION\-TABLE(\"|'|)");
        if (regularExpressionOfTable.test(htmlCode)
                && !regularExpressionOfMandatoryClass.test(htmlCode)) {
            return message;
        }

        return null;
    }

    /**
     * Check if HTML code contains a Table tag "<td><strong>" tags sequence inside it.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isTableTagHasTdStrongTagsSequence(htmlCode) {
        var message = "- HTML code contains a Table tag with \"<td><strong>\" tags sequence that have to be replaced with Th tag.";
        var regularExpression = new RegExp("<TD><STRONG>|</STRONG></TD>");
        if (regularExpression.test(htmlCode)) {
            return message;
        }

        return null;
    }

    /**
     * Check if HTML code contains a Table tag with Thead tag and Td tag inside it.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isTableTagHasTdTagInsideTheadTag(htmlCode) {
        var message = "- HTML code contains a Table tag with Thead tag and Td tag inside it.";
        var regularExpression = new RegExp("<THEAD[^>]*>.*<TR[^>]*>.*<TD[^>]*>", "s");
        if (regularExpression.test(htmlCode)) {
            return message;
        }

        return null;
    }

    /**
     * Check if HTML code contains twice escaped HTML symbol codes like &amp;#160;.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsTwiceEscapedHtmlSymbolCode(htmlCode) {
        var message = "- HTML code contains twice escaped symbol codes like &amp;#160; that should be replaced with &#160;.";
        var regularExpression = new RegExp("&AMP;#[0-9a-zA-Z]{1,8};");
        if (regularExpression.test(htmlCode)) {
            return message;
        }

        return null;
    }

    /**
     * Check if HTML code contains hidden elements like &lt;span style="display: none;">.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsHiddenElements(htmlCode) {
        var message = "- HTML code contains hidden elements like <span style=\"display: none;\">. Such elements should be removed.";
        var regularExpression = new RegExp("DISPLAY\\s*:\\s*NONE");
        if (regularExpression.test(htmlCode)) {
            return message;
        }

        return null;
    }

    /**
     * Detect broken character encoding like "�drive".
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsBrokenCharacterEncoding(htmlCode) {
        var message = "- HTML code contains broken character encoding like \"�drive\".";
        var regularExpression = new RegExp("�");
        if (regularExpression.test(htmlCode)) {
            return message;
        }

        return null;
    }

    /**
     * Detect not closed pair of tags like "<p><p>Hello wordl</p>".
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsNotClosedTags(htmlCode) {
        var message = "- HTML code contains not closed pair of tags like \"<p><p>Hello wordl</p>\".";
        for (let tagName of ["P", "A", "UL", "LI", "SPAN", "DIV", "TD", "TR", "TABLE",
            "TH", "DD", "DT"]) {
            if (!this.isAllTagsClosed(tagName, htmlCode)) {
                return message;
            }
        }

        return null;
    }

    isAllTagsClosed(tagName, htmlCode) {
        let openTagsRegexp = new RegExp("<" + tagName + "[ >]", "g");
        let openTagsMatch = htmlCode.match(openTagsRegexp);
        let numberOfOpenTags = 0;
        if(openTagsMatch !== null) {
            numberOfOpenTags = openTagsMatch.length;
        }
        
        let closeTagsRegexp = new RegExp("</" + tagName + ">", "g");
        let closedTagsMatch = htmlCode.match(closeTagsRegexp);
        let numberOfClosedTags = 0;
        if(closedTagsMatch !== null) {
            numberOfClosedTags = closedTagsMatch.length;
        }
        
        console.log("Open: " + numberOfOpenTags);
        console.log("Closed: " + numberOfClosedTags)

        if (numberOfOpenTags !== numberOfClosedTags) {
            return false;
        }

        return true;
    }

    /**
     * Check if HTML code contains intellectual property symbols or codes.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsIntellectualPropertySymbolsOrCodes(htmlCode) {
        var message = "- HTML code contains intellectual property symbols or codes.";
        var regularExpression = new RegExp("™|&TRADE;|&#8482;|&#X2122;|®|&REG;|&#174;|©|&COPY;|&#169;|&#00A9;|℗|&#8471;|&#2117;|℠|&#8480;|&#2120;");
        if (regularExpression.test(htmlCode)) {
            return message;
        }

        return null;
    }

    /**
     * Check if HTML code contains P tag.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsEmptyTags(htmlCode) {
        var message = "- HTML code contains empty tags like \"<p></p>\".";
        var regularExpression = new RegExp("<P[^>]*>\\s*</P>|<SPAN[^>]*>\\s*</SPAN>|<DIV[^>]*>\\s*</DIV>|<UL[^>]*>\\s*</UL>|<LI[^>]*>\\s*</LI>|<DD[^>]*>\\s*</DD>|<DT[^>]*>\\s*</DT>");
        if (regularExpression.test(htmlCode)) {
            return message;
        }

        return null;
    }

    /**
     * Check if HTML code contains Img tag.
     * 
     * @param {type} htmlCode
     * @return {HtmlCodeValidator.isHtmlCodeContainsImgTag@call;isHtmlCodeContainsTheTag}
     */
    isHtmlCodeContainsImgTag(htmlCode) {
        var response = this.isHtmlCodeContainsTheTag(htmlCode, "IMG");
        if (response !== null) {
            response += " If image(s) seem to be important (diagrams, CAD drawings, etc), then extract their urls and put them in a file for the documents section.";
        }

        return response;
    }

    /**
     * Check if HTML code contains A tag.
     * 
     * @param {type} htmlCode
     * @return {HtmlCodeValidator.isHtmlCodeContainsATag@call;isHtmlCodeContainsTheTag}
     */
    isHtmlCodeContainsATag(htmlCode) {
        var response = this.isHtmlCodeContainsTheTag(htmlCode, "A");
        if (response !== null) {
            response += " Links should be removed/transformed taking into consideration their surrounding context.";
        }

        return response;
    }

    /**
     * Check if HTML code contains H1 tag.
     * 
     * @param {type} htmlCode
     * @return {HtmlCodeValidator.isHtmlCodeContainsH1Tag@call;isHtmlCodeContainsTheTag}
     */
    isHtmlCodeContainsH1Tag(htmlCode) {
        var response = this.isHtmlCodeContainsTheTag(htmlCode, "H1");
        if (response !== null) {
            response += " Header(s) should be replaced with H5 tag.";
        }

        return response;
    }

    /**
     * Check if HTML code contains H2 tag.
     * 
     * @param {type} htmlCode
     * @return {HtmlCodeValidator.isHtmlCodeContainsH2Tag@call;isHtmlCodeContainsTheTag}
     */
    isHtmlCodeContainsH2Tag(htmlCode) {
        var response = this.isHtmlCodeContainsTheTag(htmlCode, "H2");
        if (response !== null) {
            response += " Header(s) should be replaced with H5 tag.";
        }

        return response;
    }

    /**
     * Check if HTML code contains H3 tag.
     * 
     * @param {type} htmlCode
     * @return {HtmlCodeValidator.isHtmlCodeContainsH3Tag@call;isHtmlCodeContainsTheTag}
     */
    isHtmlCodeContainsH3Tag(htmlCode) {
        var response = this.isHtmlCodeContainsTheTag(htmlCode, "H3");
        if (response !== null) {
            response += " Header(s) should be replaced with H5 tag.";
        }

        return response;
    }

    /**
     * Check if HTML code contains H4 tag.
     * 
     * @param {type} htmlCode
     * @return {HtmlCodeValidator.isHtmlCodeContainsH4Tag@call;isHtmlCodeContainsTheTag}
     */
    isHtmlCodeContainsH4Tag(htmlCode) {
        var response = this.isHtmlCodeContainsTheTag(htmlCode, "H4");
        if (response !== null) {
            response += " Header(s) should be replaced with H5 tag.";
        }

        return response;
    }

    /**
     * Check if HTML code contains H6 tag.
     * 
     * @param {type} htmlCode
     * @return {HtmlCodeValidator.isHtmlCodeContainsH6Tag@call;isHtmlCodeContainsTheTag}
     */
    isHtmlCodeContainsH6Tag(htmlCode) {
        var response = this.isHtmlCodeContainsTheTag(htmlCode, "H6");
        if (response !== null) {
            response += " Header(s) should be replaced with H5 tag.";
        }

        return response;
    }

    /**
     * Check if HTML code contains Div tag.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsDivTag(htmlCode) {
        return this.isHtmlCodeContainsTheTag(htmlCode, "DIV");
    }

    /**
     * Check if HTML code contains Iframe tag.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsIframeTag(htmlCode) {
        return this.isHtmlCodeContainsTheTag(htmlCode, "IFRAME");
    }

    /**
     * Check if HTML code contains Frame tag.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsFrameTag(htmlCode) {
        return this.isHtmlCodeContainsTheTag(htmlCode, "FRAME");
    }

    /**
     * Check if HTML code contains Object tag.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsObjectTag(htmlCode) {
        return this.isHtmlCodeContainsTheTag(htmlCode, "OBJECT");
    }

    /**
     * Check if HTML code contains Embed tag.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsEmbedTag(htmlCode) {
        return this.isHtmlCodeContainsTheTag(htmlCode, "EMBED");
    }

    /**
     * Check if HTML code contains Script tag.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsScriptTag(htmlCode) {
        return this.isHtmlCodeContainsTheTag(htmlCode, "SCRIPT");
    }

    /**
     * Check if HTML code contains Noscript tag.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsNoscriptTag(htmlCode) {
        return this.isHtmlCodeContainsTheTag(htmlCode, "NOSCRIPT");
    }

    /**
     * Check if HTML code contains Span tag.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsSpanTag(htmlCode) {
        return this.isHtmlCodeContainsTheTag(htmlCode, "SPAN");
    }

    /**
     * Check if HTML code contains S tag.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsSTag(htmlCode) {
        return this.isHtmlCodeContainsTheTag(htmlCode, "S");
    }

    /**
     * Check if HTML code contains Strong tag.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsStrongTag(htmlCode) {
        return this.isHtmlCodeContainsTheTag(htmlCode, "STRONG");
    }

    /**
     * Check if HTML code contains B tag.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsBTag(htmlCode) {
        return this.isHtmlCodeContainsTheTag(htmlCode, "B");
    }

    /**
     * Check if HTML code contains Class tag attribute.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsClassAttribute(htmlCode) {
// Table tag allowed to have a Class attribute with "description-table" value.
        htmlCode = htmlCode.replace(/<TABLE CLASS=(\"|'|)DESCRIPTION\-TABLE(\"|'|)/, "");
        return this.isHtmlCodeContainsTheAttribute(htmlCode, "CLASS");
    }

    /**
     * Check if HTML code contains Id tag attribute.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsIdAttribute(htmlCode) {
        return this.isHtmlCodeContainsTheAttribute(htmlCode, "ID");
    }

    /**
     * Check if HTML code contains Style tag attribute.
     * 
     * @param {type} htmlCode
     * @return {String}
     */
    isHtmlCodeContainsStyleAttribute(htmlCode) {
        return this.isHtmlCodeContainsTheAttribute(htmlCode, "STYLE");
    }

    /**
     * Generic function that checks if given HTML code contains given tag.
     * 
     * @param {type} htmlCode
     * @param {type} tagName
     * @return {String}
     */
    isHtmlCodeContainsTheTag(htmlCode, tagName) {
        var message = "- HTML code contains "
                + this.capitalizeFirstLetter(tagName) + " tag(s).";
        if (htmlCode.includes("<" + tagName + " ") // Match tag with attributes like <p id="p27">.
                || htmlCode.includes("<" + tagName + ">")) // Match empty tag like <p>.
        {
            return message;
        }
        if (htmlCode.includes("</" + tagName + ">")) {
            return message;
        }

        return null;
    }

    /**
     * Generic function that checks if given HTML code contains given tag attribute.
     * @param {type} htmlCode
     * @param {type} attributeName
     * @return {String}
     */
    isHtmlCodeContainsTheAttribute(htmlCode, attributeName) {
        var message = "- HTML code contains "
                + this.capitalizeFirstLetter(attributeName) + " attribute(s).";
        var regularExpression = new RegExp(" " + attributeName + "=\"[^\"]+\"| " + attributeName + "=''[^'']+''| " + attributeName + "=[^ ]+");
        if (regularExpression.test(htmlCode)) {
            return message;
        }

        return null;
    }

    capitalizeFirstLetter(string) {
        return string[0].toUpperCase() + string.substring(1).toLowerCase();
    }

}
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous" />

        <title>HTML code tide</title>

        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
    </head>
    <body>
        <div class="container mt-3">
            <div class="row">
                <div class="col-4">
                    <h1 class="h4">HTML&nbsp;Code&nbsp;Tide</h1>
                </div>
                <div class="col-8 text-md-right">
                    <a href="#" onclick="event.preventDefault();" id="load-html-code-example">Load&nbsp;HTML&nbsp;code&nbsp;example</a>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <form>
                        <div class="row">
                            <div class="col">
                                <div style="border: 1px #cccccc solid;"><textarea name="html-code" id="html-code" class="form-control" rows="15"></textarea></div>
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-4">
                                <input type="button" id="run-html-code-tide" value="Tide code" />
                            </div>
                            <div class="col-4">
                                Status: <span id="html-code-tide-status"></span>
                            </div>
                        </div>
                        <div class="row mt-4">
                            <div class="col">
                                <h4 class="h4">Tide HTML</h4>
                                <textarea name="tide-html-code" id="tide-html-code" class="form-control" rows="15" readonly="true"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <footer class="row mt-5">
                <div class="col"></div>
            </footer>
        </div>

        <script>
            $("#run-html-code-tide").on("click", function () {
                $("#html-code-tide-status").text("Processing HTML code ...");
                htmlCode = $("#html-code").val();
                
                $.post("/utilities/utilities/html-code-tide.do", {"html-code": htmlCode})
                        .done(function (tideHtmlCode) {
                            $("#tide-html-code").val(tideHtmlCode);
                            $("#html-code-tide-status").text("HTML code processed.");
                        })
                        .fail(function () {
                            $("#tide-html-code").val("");
                            $("#html-code-tide-status").text("HTML code process failed.");
                        });
            });
        </script>

        <!-- Load HTML code example into textarea element. -->
        <script>
            $("#load-html-code-example").on("click", function () {
                $("#html-code").val("<h1 id=\"the-header\">Href&amp;#160;Attribute&amp;#160;Example</h1>\r\n" +
                        "<p class=\"awesome-css-style\">\r\n" +
                        "    <a href=\"https://www.w3.org\">The W3 Page</a> shows you how and where you can use a link.\r\n" +
                        "</p>\r\n" +
                        "<div style=\"display: none;\"> </div>\r\n" +
                        "<p style=\"color: red;\">Microsoft® has invented own bicycle, it was named <strong>Silverlight&trade;</strong></p>\r\n" +
                        "<div><img src=\"https://tinyurl.com/4tdm4uah\" /> Now Silverlight is dead?</div>\r\n" +
                        "\r\n" +
                        "<table>\r\n" +
                        "    <thead>\r\n" +
                        "        <tr>\r\n" +
                        "            <td>Parameter</td>\r\n" +
                        "            <td>Value</td>\r\n" +
                        "        </tr>\r\n" +
                        "    </thead>\r\n" +
                        "    <tbody>\r\n" +
                        "        <tr>\r\n" +
                        "            <td><strong>RPM</strong></td>\r\n" +
                        "            <td>1200</td>\r\n" +
                        "        </tr>\r\n" +
                        "    </tbody>\r\n" +
                        "</table>");
                location.reload();
            });
        </script>

        <!-- Apply CodeMirror to textarea. -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.63.3/codemirror.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.63.3/codemirror.min.css" />

        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.63.3/mode/xml/xml.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.63.3/mode/javascript/javascript.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.63.3/mode/css/css.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.63.3/mode/vbscript/vbscript.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.63.3/mode/htmlmixed/htmlmixed.min.js"></script>
        <script type="text/javascript">
            var mixedMode = {
                name: "htmlmixed",
                scriptTypes: [
                    {
                        matches: /\/x-handlebars-template|\/x-mustache/i,
                        mode: null
                    },
                    {
                        matches: /(text|application)\/(x-)?vb(a|script)/i,
                        mode: "vbscript"
                    }
                ]
            };
            var editor = CodeMirror.fromTextArea($("#html-code")[0], {
                mode: mixedMode,
                selectionPointer: true,
                lineNumbers: true,
                tabSize: 4,
                smartIndent: true,
                indentWithTabs: true,
                lineWrapping: true
            }).on('change', editor => {
                $("#html-code").val(editor.getValue());
            });
        </script>
    </body>
</html>
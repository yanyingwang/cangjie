#!/usr/bin/bash

FONT_BASE64="$(base64 -w 0 cangjie-regular.ttf)"

cat > cangjie-chatgpt.user.js <<EOF
// ==UserScript==
// @name         Cangjie Font for ChatGPT
// @namespace    https://github.com/yanyingwang/cangjie
// @version      0.1.0
// @description  Use the Cangjie font for Ming characters in ChatGPT.
// @match        https://chatgpt.com/*
// @match        https://chat.openai.com/*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    const FONT_FAMILY = 'cangjie';

    const FONT_DATA =
        'data:font/truetype;base64,${FONT_BASE64}';

    const font = new FontFace(
        FONT_FAMILY,
        \`url("\${FONT_DATA}") format("truetype")\`
    );

    font.load()
        .then(function (loadedFont) {
            document.fonts.add(loadedFont);

            console.log(
                '[Cangjie] Font loaded:',
                FONT_FAMILY
            );

            installCSS();
        })
        .catch(function (error) {
            console.error(
                '[Cangjie] Font loading failed:',
                error
            );
        });


    function installCSS() {
        if (document.getElementById('cangjie-font-style')) {
            return;
        }

        const style = document.createElement('style');

        style.id = 'cangjie-font-style';

        style.textContent = \`
            [contenteditable="true"] {
                font-family:
                    "cangjie",
                    "-apple-system-body",
                    "ui-sans-serif",
                    "-apple-system",
                    "system-ui",
                    "Segoe UI",
                    "Helvetica",
                    "Apple Color Emoji",
                    "Arial",
                    "sans-serif",
                    "Segoe UI Emoji",
                    "Segoe UI Symbol" !important;
            }
        \`;

        document.documentElement.appendChild(style);

        console.log('[Cangjie] CSS installed.');
    }

})();
EOF

echo "Generated cangjie-chatgpt.user.js"

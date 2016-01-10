import QtQuick 2.5
import QtQuick.Controls 1.4
import QtWebEngine 1.1

WebEngineView {
    id: webview
    url: "https://metaverse.highfidelity.com/directory"

    Component.onDestruction: webview.stop()

    onLoadingChanged: {
        // Required to support clicking on "hifi://" links
        if (WebEngineView.LoadStartedStatus == loadRequest.status) {
            var url = loadRequest.url.toString();
            if (urlHandler.canHandleUrl(url)) {
                if (urlHandler.handleUrl(url)) {
                    webview.stop();
                }
            }
        }
    }

    property var originalUrl
    property var lastFixupTime: 0

    onUrlChanged: {
        var currentUrl = url.toString();
        var newUrl = urlHandler.fixupUrl(currentUrl).toString();
        if (newUrl !== currentUrl) {
            var now = new Date().valueOf();
            if (url === originalUrl && (now - lastFixupTime < 100))  {
                console.warn("URL fixup loop detected")
                return;
            }
            console.log("Changing URL from " + currentUrl + " to " + newUrl)
            originalUrl = url
            lastFixupTime = now
            url = newUrl;
        }
    }

    profile: WebEngineProfile {
        id: webviewProfile
        httpUserAgent: "Mozilla/5.0 (HighFidelityInterface)"
        storageName: "qmlWebEngine"
    }
}

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtWebEngine 1.1

WebEngineView {
    id: webview
    url: "https://metaverse.highfidelity.com/directory"

    onLoadingChanged: {
        // Required to support clicking on "hifi://" links
        if (WebEngineView.LoadStartedStatus == loadRequest.status) {
            var url = loadRequest.url.toString();
            console.log("Checking handability of URL " + url)
            if (urlHandler.canHandleUrl(url)) {
                console.log("Attempting to handle URL " + url)
                if (urlHandler.handleUrl(url)) {
                    console.log("Handled URL " + url + " stopping web load")
                    webview.stop();
                    console.log("Stopped")
                }
            }
        }
    }

    onUrlChanged: {
        var currentUrl = url.toString();
        var newUrl = urlHandler.fixupUrl(currentUrl);
        if (newUrl != currentUrl) {
            console.log("Changing URL frm " + currentUrl + " to " + newUrl)
            url = newUrl;
        }
    }

    profile: WebEngineProfile {
        id: webviewProfile
        httpUserAgent: "Mozilla/5.0 (HighFidelityInterface)"
        storageName: "qmlWebEngine"
    }
}

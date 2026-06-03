import QtQuick
import Quickshell.Services.Pam

Item {
    id: auth

    property string user: ""
    readonly property bool authenticating: pam.active

    signal failed
    signal succeeded

    property string pendingPassword: ""

    function submit(password) {
        if (pam.active)
            return;
        auth.pendingPassword = password;
        pam.start();
    }

    PamContext {
        id: pam
        config: "login"
        user: auth.user

        onResponseRequiredChanged: {
            if (responseRequired)
                respond(auth.pendingPassword);
        }

        onCompleted: result => {
            auth.pendingPassword = "";
            if (result === PamResult.Success)
                auth.succeeded();
            else
                auth.failed();
        }

        onError: {
            auth.pendingPassword = "";
            auth.failed();
        }
    }
}

var uiController = (function () {
    var UI_BUTTON_URL = Script.resolvePath("images/chip.svg");
    var BUTTON_WIDTH = 50, BUTTON_HEIGHT = 50, BUTTON_MARGIN = 8;
    var MAPPING_NAME = "com.highfidelity.ui.navigation";
    var uiWindow;
    var uiButton;
    var viewport;

    function onMousePressEvent(event) {
        var clickedOverlay = Overlays.getOverlayAtPoint({ x: event.x, y: event.y });
        if (clickedOverlay === uiButton) {
            toggleUi();
        }
    }

    function onDomainChanged() {
        uiWindow.setVisible(false);
    }

    function onScriptUpdate() {
        var oldViewport = viewport;
        viewport = Controller.getViewportDimensions();
    }
    
    function toggleUi() {
        if (!uiWindow.visible) {
            uiWindow.setVisible(true);
            uiWindow.raise();
        } else {
            uiWindow.setVisible(false);
        }
    }

    function setUp() {
        viewport = Controller.getViewportDimensions();
        uiWindow = new OverlayWindow({
            title: 'Running Scripts', 
            source: Script.resolvePath("qml/RunningScripts.qml"), 
            width: 400, height: 720, 
            visible: false
        });

        uiButton = Overlays.addOverlay("image", {
            imageURL: UI_BUTTON_URL,
            width: BUTTON_WIDTH,
            height: BUTTON_HEIGHT,
            x: 10, y: 400 + 2 * BUTTON_HEIGHT,
            visible: true
        });

        var mapping = Controller.newMapping(MAPPING_NAME);
        mapping.from(Controller.Standard.Back).to(function(value){
            if (value) {
                toggleUi();
            }
        });
        mapping.from(Controller.Standard.Start).to(function(value){
            if (value) {
                toggleUi();
            }
        });
        mapping.from(Controller.Standard.LeftSecondaryThumb).to(function(value){
            if (value) {
                toggleUi();
            }
        });
        mapping.from(Controller.Standard.RightSecondaryThumb).to(function(value){
            if (value) {
                toggleUi();
            }
        });
        Controller.enableMapping(MAPPING_NAME);        

        Controller.mousePressEvent.connect(onMousePressEvent);
        Window.domainChanged.connect(onDomainChanged);
        Script.update.connect(onScriptUpdate);
    }

    function tearDown() {
        Controller.disableMapping(MAPPING_NAME);        
        Overlays.deleteOverlay(uiButton);
    }

    setUp();
    Script.scriptEnding.connect(tearDown);
}());

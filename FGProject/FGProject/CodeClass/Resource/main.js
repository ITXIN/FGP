require("AIVoiceMathematicsViewController");

defineClass("RootViewController", {
    tomBtnClick: function(sender) {
        self.dateView().setHidden(YES);
        var aiVoiceVC = AIVoiceMathematicsViewController.alloc().init();
        self.navigationController().pushViewController_animated(aiVoiceVC, YES);
    }
}, {});

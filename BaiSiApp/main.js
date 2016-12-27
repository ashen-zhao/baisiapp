//本文件为本地测试文件，若要上线,本文件需要在项目中移除
defineClass('BaiSiApp.ASTBController', {
    tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
            var alertView = require('UIAlertView').alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("悄悄话","悄悄的告诉你这是热更新哦", self, "二货，朕早就知道了",, null);
            alertView.show()
    }
})

//本文件为本地测试文件，若要上线,本文件需要在项目中移除
console.log('run success')
defineClass('BaiSiApp.ASTBController', {
    tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
            console.log('Get')
            var alertView = require('UIAlertView').alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("悄悄话","悄悄的告诉你这是热更新哦", self, "男","女",null);
            alertView.show()
    }
})

defineClass('BaiSiApp.ASMainController', {
            sayHi: function() {
                console.log('Hello')
            }
            
})

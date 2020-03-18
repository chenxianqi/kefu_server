const electron = require('electron')
const app = electron.app
const dialog = electron.dialog;
const BrowserWindow = electron.BrowserWindow
const Menu = electron.Menu
const path = require('path')
if (process.mas) app.setName('客服系统')

let mainWindow
function createWindow () {
  let windowOptions = {
    width: 1330,
    height: 780,
    title: app.getName()
  }
  
  if (process.platform === 'linux') {
    windowOptions.icon = path.join(__dirname, '/logo.ico')
  }

  mainWindow = new BrowserWindow(windowOptions);
  mainWindow.loadURL(path.join('file://', __dirname, '/dist/index.html'))

  mainWindow.on('closed', function () {
    mainWindow = null
  })
  
  mainWindow.on('close', function (e) {
    const options = {
        type: 'warning',
        title: '温馨提示！',
        message: "您确定关闭应用程序吗？",
        buttons: ['我点错了', '窗口最小化', '确定关闭']
    }
    dialog.showMessageBox(options, function (index) {
        if(index == 2) app.exit();
        if(index == 1) mainWindow.minimize()
    })
    e.preventDefault()
  })    

}

app.on('ready', function() {
  const menu = Menu.buildFromTemplate(template)
  Menu.setApplicationMenu(menu)
  createWindow()
})

app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') app.quit()
})

app.on('activate', function () {
  if (mainWindow === null) createWindow()
})

app.on('browser-window-created', function () {
    let reopenMenuItem = findReopenMenuItem()
    if (reopenMenuItem) reopenMenuItem.enabled = false
})

app.on('window-all-closed', function () {
    let reopenMenuItem = findReopenMenuItem()
    if (reopenMenuItem) reopenMenuItem.enabled = true
    app.quit()
})


/**
 * 注册键盘快捷键
 */
let template = [
    {
        label: '操作',
        submenu: [{
            label: '重新加载',
            accelerator: 'CmdOrCtrl+R',
            click: function (item, focusedWindow) {
            if (focusedWindow) {
                if (focusedWindow.id === 1) {
                    BrowserWindow.getAllWindows().forEach(function (win) {
                        if (win.id > 1) {
                            win.close()
                        }
                    })
                }
                focusedWindow.loadURL(path.join('file://', __dirname, '/dist/index.html'))
            }
            }
        },
        {
          label: "选项",
          submenu: [
            { label: "复制", accelerator: "CmdOrCtrl+C", selector: "copy:" },
            { label: "粘贴", accelerator: "CmdOrCtrl+V", selector: "paste:" },
          ]
        }]
    },
    {
        label: '窗口设置',
        role: 'window',
        submenu: [{
            label: '最小化',
            accelerator: 'CmdOrCtrl+M',
            role: 'minimize'
        },{
            label: '切换开发者工具',
            accelerator: (function () {
              if (process.platform === 'darwin') {
                return 'Alt+Command+I'
              } else {
                return 'Ctrl+Shift+I'
              }
            })(),
            click: function (item, focusedWindow) {
              if (focusedWindow) {
                focusedWindow.toggleDevTools()
              }
            }
          }]
    },
  {
        label: '关于',
        role: 'help',
        submenu: [{
            label: '客服',
            click: function () {
                electron.shell.openExternal('http://kf.aissz.com:666')
            }
        }]
    }
]

/**
 * 增加更新相关的菜单选项
 */
function addUpdateMenuItems (items, position) {
    if (process.mas) return

    const version = electron.app.getVersion()
    let updateItems = [{
        label: `当前版本 ${version}`,
        enabled: false
    }]

    items.splice.apply(items, [position, 0].concat(updateItems))
}

function findReopenMenuItem () {
    const menu = Menu.getApplicationMenu()
    if (!menu) return

    let reopenMenuItem
    menu.items.forEach(function (item) {
        if (item.submenu) {
            item.submenu.items.forEach(function (item) {
                if (item.key === 'reopenMenuItem') {
                    reopenMenuItem = item
                }
            })
        }
    })
    return reopenMenuItem
}

// 针对Mac端的一些配置
if (process.platform === 'darwin') {
    const name = electron.app.getName()
    template.unshift({
        label: name,
        submenu: [{
            label: '退出应用',
            accelerator: 'Command+Q',
            click: function () {
                app.exit()
            }
        }]
    })

    // Window menu.
    template[3].submenu.push({
        type: 'separator'
    })

    addUpdateMenuItems(template[0].submenu, 1)
}

// 针对Windows端的一些配置
if (process.platform === 'win32') {
    const helpMenu = template[template.length - 1].submenu
    addUpdateMenuItems(helpMenu, 0)
}

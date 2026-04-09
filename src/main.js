const { app, BrowserWindow, Menu, shell, ipcMain } = require('electron');
const path = require('path');

// Keep a global reference of the window object
let mainWindow;

const isMac = process.platform === 'darwin';

// ── Platform-specific Chromium flags ──
// Must be set BEFORE app.ready
if (process.platform === 'linux') {
  app.commandLine.appendSwitch('enable-transparent-visuals');
  app.commandLine.appendSwitch('disable-gpu-compositing');
}

function createWindow() {
  // Window size: 800px canvas + surrounding UI + 32px body padding (16px x 2)
  mainWindow = new BrowserWindow({
    width: 1060,
    height: 920,
    minWidth: 860,
    minHeight: 700,
    frame: false,
    transparent: true,
    backgroundColor: '#00000000',
    hasShadow: false,
    resizable: true,
    roundedCorners: true,
    ...(isMac ? { titleBarStyle: 'hiddenInset' } : {}),
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js'),
      sandbox: true,
    },
    show: false,
    icon: isMac
      ? path.join(__dirname, '..', 'resources', 'icons', 'icon.icns')
      : path.join(__dirname, '..', 'resources', 'icons', 'icon.png'),
  });

  mainWindow.loadFile(path.join(__dirname, 'index.html'))
    .then(() => console.log('Main window loaded successfully'))
    .catch(err => {
      console.error('Failed to load index.html:', err);
      app.quit();
    });

  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
    if (process.argv.includes('--dev')) {
      mainWindow.webContents.openDevTools();
    }
  });

  mainWindow.on('closed', () => {
    mainWindow = null;
  });

  // IPC Handlers for custom window controls
  const windowHandlers = {
    'window-minimize': () => mainWindow?.minimize(),
    'window-maximize': () => {
      if (mainWindow) {
        mainWindow.isMaximized()
          ? mainWindow.unmaximize()
          : mainWindow.maximize();
      }
    },
    'window-close': () => mainWindow?.close()
  };

  // Register IPC handlers
  Object.entries(windowHandlers).forEach(([channel, handler]) => {
    ipcMain.handle(channel, handler);
  });

  // Cleanup IPC handlers on close
  mainWindow.on('closed', () => {
    Object.keys(windowHandlers).forEach(channel => {
      ipcMain.removeHandler(channel);
    });
  });

  // Handle external links with protocol validation
  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    const allowed = ['https:', 'http:', 'mailto:'];
    try {
      if (allowed.includes(new URL(url).protocol)) {
        shell.openExternal(url);
      }
    } catch (e) {
      console.error('Window open handler rejected invalid URL:', url, e.message);
    }
    return { action: 'deny' };
  });

  createMenu();
}

function createMenu() {
  const template = [
    {
      label: 'Game',
      submenu: [
        {
          label: 'New Game',
          accelerator: 'CmdOrCtrl+N',
          click: () => { if (mainWindow) mainWindow.reload(); }
        },
        {
          label: 'Toggle Fullscreen',
          accelerator: 'F11',
          click: () => { if (mainWindow) mainWindow.setFullScreen(!mainWindow.isFullScreen()); }
        },
        { type: 'separator' },
        {
          label: 'Quit',
          accelerator: process.platform === 'darwin' ? 'Cmd+Q' : 'Ctrl+Q',
          click: () => { app.quit(); }
        }
      ]
    },
    {
      label: 'View',
      submenu: [
        { role: 'reload' },
        { role: 'forceReload' },
        { role: 'toggleDevTools' },
        { type: 'separator' },
        { role: 'resetZoom' },
        { role: 'zoomIn' },
        { role: 'zoomOut' },
        { type: 'separator' },
        { role: 'togglefullscreen' }
      ]
    },
    {
      label: 'Window',
      submenu: [
        { role: 'minimize' },
        { role: 'close' }
      ]
    }
  ];

  if (isMac) {
    template.unshift({
      label: app.getName(),
      submenu: [
        { role: 'about' },
        { type: 'separator' },
        { role: 'services' },
        { type: 'separator' },
        { role: 'hide' },
        { role: 'hideOthers' },
        { role: 'unhide' },
        { type: 'separator' },
        { role: 'quit' }
      ]
    });
  }

  const menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);
}

// App event handlers
app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});


# VS Code Workspace Settings for MCME Plugin Development

This configuration provides:
- Java 21 support
- Maven integration
- Proper Paper API autocomplete
- Debugging support

## Extensions Recommended

Install these VS Code extensions for the best development experience:

1. **Extension Pack for Java** (vscjava.vscode-java-pack)
   - Language Support for Java
   - Debugger for Java
   - Test Runner for Java
   - Maven for Java
   - Project Manager for Java

2. **Lombok Annotations Support** (GabrielBB.vscode-lombok)

3. **XML** (redhat.vscode-xml) - For POM file editing

## Launch Configuration

Create `.vscode/launch.json`:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "java",
            "name": "Debug Minecraft Server",
            "request": "attach",
            "hostName": "localhost",
            "port": 5005
        }
    ]
}
```

Then start server with debug enabled:
```powershell
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 -Xmx2G -Xms2G -jar paper.jar nogui
```

## Java Settings

Create `.vscode/settings.json`:

```json
{
    "java.configuration.updateBuildConfiguration": "automatic",
    "java.compile.nullAnalysis.mode": "automatic",
    "java.jdt.ls.java.home": "C:\\Program Files\\Java\\jdk-24",
    "maven.executable.path": "C:\\Users\\dntst\\AppData\\Local\\Temp\\apache-maven-3.9.9\\bin\\mvn.cmd",
    "files.exclude": {
        "**/target": true,
        "**/.settings": true,
        "**/.project": true,
        "**/.classpath": true
    }
}
```

## Workspace Tasks

Create `.vscode/tasks.json`:

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Build All Plugins",
            "type": "shell",
            "command": "./build-all.ps1",
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "reveal": "always",
                "panel": "new"
            }
        },
        {
            "label": "Deploy Plugins",
            "type": "shell",
            "command": "./deploy.ps1",
            "group": "build",
            "presentation": {
                "reveal": "always",
                "panel": "new"
            }
        },
        {
            "label": "Build PluginUtils",
            "type": "shell",
            "command": "cd PluginUtils; mvn clean install",
            "group": "build"
        },
        {
            "label": "Build MCME-Architect",
            "type": "shell",
            "command": "cd MCME-Architect; mvn clean package",
            "group": "build"
        },
        {
            "label": "Start Server",
            "type": "shell",
            "command": "cd ..; java -Xmx2G -Xms2G -jar paper.jar nogui",
            "group": "test",
            "isBackground": true,
            "problemMatcher": []
        }
    ]
}
```

## Keyboard Shortcuts

- `Ctrl+Shift+B` - Build all plugins
- `F5` - Start debugging (if server running with debug port)
- `Ctrl+Shift+P` then "Maven: Update Project" - Refresh dependencies

## Tips

1. **Code Navigation**: `F12` to go to definition, `Shift+F12` for references
2. **Refactoring**: Right-click > Refactor for rename, extract method, etc.
3. **Maven Commands**: Click Maven icon in sidebar for lifecycle commands
4. **Git Integration**: Built-in source control in left sidebar
5. **Problems Panel**: `Ctrl+Shift+M` to view compilation errors

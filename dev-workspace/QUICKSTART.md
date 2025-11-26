# Quick Start Guide - MCME Plugin Development

## First Time Setup

### 1. Verify Prerequisites

```powershell
# Check Java version (should be 21+)
java -version

# Check Maven (from temp directory)
& "C:\Users\dntst\AppData\Local\Temp\apache-maven-3.9.9\bin\mvn.cmd" --version
```

### 2. Build All Plugins

```powershell
cd c:\Users\dntst\minecraft-paper-server\dev-workspace
.\build-all.ps1
```

This will:
1. Build PluginUtils and install to local Maven repo
2. Build MCME-Architect  
3. Build MCME-Connect

**Build time**: ~2-5 minutes for first build (downloads dependencies)

### 3. Deploy to Server

```powershell
.\deploy.ps1
```

This copies built JARs to `../plugins/` directory.

### 4. Start Server

```powershell
cd ..
java -Xmx2G -Xms2G -jar paper.jar nogui
```

## Daily Development Workflow

### Making Changes

1. **Edit code** in `src/main/java/`
2. **Build**: `.\build-all.ps1` (or build individual plugin)
3. **Deploy**: `.\deploy.ps1`
4. **Test**: Restart server and check logs

### Quick Build Individual Plugin

```powershell
$mvn = "C:\Users\dntst\AppData\Local\Temp\apache-maven-3.9.9\bin\mvn.cmd"

# PluginUtils
cd PluginUtils
& $mvn clean install

# MCME-Architect
cd ..\MCME-Architect
& $mvn clean package

# MCME-Connect  
cd ..\MCME-Connect
& $mvn clean package
```

### Hot Reload (No Restart Required)

Some plugins support hot reload with PlugManX:
```
/plugman reload PluginName
```

Otherwise, restart server for changes.

## Common Tasks

### Add a New Command

1. Create command class in `src/main/java/.../commands/`
2. Register in `plugin.yml` under `commands:`
3. Register executor in main plugin class
4. Build and test

### Add a New Event Listener

1. Create listener class implementing `Listener`
2. Add `@EventHandler` methods
3. Register in `onEnable()`: `getServer().getPluginManager().registerEvents(listener, this)`
4. Build and test

### Add a New Dependency

1. Find dependency in Maven Central or other repo
2. Add `<dependency>` to `pom.xml`
3. Run `mvn dependency:tree` to verify
4. Build and test

### Debug with Logs

```java
getLogger().info("Debug message");
getLogger().warning("Warning message");
getLogger().severe("Error message");
```

Logs appear in `../logs/latest.log`

## Troubleshooting

### Build Fails

```powershell
# Clean everything and rebuild
cd PluginUtils
& $mvn clean
cd ..\MCME-Architect
& $mvn clean
cd ..\MCME-Connect
& $mvn clean

# Then rebuild
cd ..
.\build-all.ps1
```

### NMS Compilation Errors

These plugins use Minecraft internals (NMS). If you get NMS errors:

1. Ensure Paper API version matches server version
2. Check if NMS classes have changed in new Minecraft version
3. Consult Paper's migration guide

### Plugin Won't Load

Check server startup logs:
```powershell
Get-Content ..\logs\latest.log | Select-String "PluginUtils|MCME"
```

Common issues:
- Missing dependency (PluginUtils not loaded first)
- Wrong API version in plugin.yml
- Java version mismatch

### Changes Not Appearing

1. Verify build succeeded (check for errors)
2. Confirm JAR was copied to plugins folder
3. Restart server completely (not just reload)
4. Clear plugin cache if necessary

## Project Structure Reference

```
PluginUtils/
├── src/main/java/com/mcmiddleearth/pluginutil/
│   ├── message/     - Chat and message utilities
│   ├── region/      - Region/selection utilities  
│   ├── nms/         - NMS (internal Minecraft) access
│   └── [util classes]
└── src/main/resources/
    └── plugin.yml   - Plugin metadata

MCME-Architect/
├── src/main/java/com/mcmiddleearth/architect/
│   ├── commands/    - Command implementations
│   ├── listeners/   - Event handlers
│   └── [features]
└── src/main/resources/
    └── plugin.yml

MCME-Connect/
├── src/main/java/com/mcmiddleearth/connect/
│   ├── bungee/      - BungeeCord integration
│   └── [features]
└── src/main/resources/
    ├── plugin.yml
    └── bungee.yml
```

## Tips & Best Practices

1. **Always build PluginUtils first** - Other plugins depend on it
2. **Test on a copy** - Never develop on production world
3. **Use version control** - Commit working changes regularly  
4. **Check Paper docs** - Many features have Paper-specific APIs
5. **Read server logs** - They tell you what went wrong
6. **Incremental changes** - Test small changes before big refactors

## Next Steps

- Read full README.md for detailed documentation
- Check VSCODE-SETUP.md for IDE configuration
- Browse source code to understand plugin architecture
- Try making a small change and rebuilding

## Getting Help

- **Paper Discord**: https://discord.gg/papermc
- **Paper Docs**: https://docs.papermc.io/
- **Spigot Forums**: https://www.spigotmc.org/
- **MCME GitHub**: https://github.com/MCME

## Useful Commands Reference

```powershell
# Build everything
.\build-all.ps1

# Deploy plugins
.\deploy.ps1

# Start server
cd ..; java -Xmx2G -Xms2G -jar paper.jar nogui

# View logs
Get-Content ..\logs\latest.log -Tail 50 -Wait

# Check for updates
cd PluginUtils; mvn versions:display-dependency-updates
```

# MCME Plugin Development Environment

This directory contains the development workspace for MCME (Minecraft Middle Earth) plugins.

## ⚠️ IMPORTANT: NMS Compatibility Issue

**These plugins currently DO NOT compile on Paper 1.21.4** due to extensive NMS (Net Minecraft Server) dependencies.

The plugins directly access Minecraft server internals that are not exposed through Paper API. **See [NMS-MIGRATION-GUIDE.md](NMS-MIGRATION-GUIDE.md) for:**
- Why the plugins don't compile
- What code needs updating  
- Migration options (Gradle + paperweight recommended)
- Alternative approaches

## Structure

```
dev-workspace/
├── PluginUtils/      - Core utility library (build this first)
├── MCME-Architect/   - Building and world manipulation plugin
├── MCME-Connect/     - Network/BungeeCord plugin
└── paper-dev.jar     - Paper server JAR for testing
```

## Prerequisites

- **Java 21** (JDK 21 or higher)
- **Apache Maven 3.9+** (located at: `C:\Users\dntst\AppData\Local\Temp\apache-maven-3.9.9`)
- **Git** (for version control)

## Building Plugins

### Build Order (Important!)

Plugins must be built in this order due to dependencies:

1. **PluginUtils** (required by other plugins)
2. **MCME-Architect**
3. **MCME-Connect**

### Build Commands

Using Maven from temp directory:

```powershell
# Set Maven path
$mvn = "C:\Users\dntst\AppData\Local\Temp\apache-maven-3.9.9\bin\mvn.cmd"

# Build PluginUtils first
cd PluginUtils
& $mvn clean install

# Build MCME-Architect
cd ..\MCME-Architect
& $mvn clean package

# Build MCME-Connect
cd ..\MCME-Connect
& $mvn clean package
```

### Quick Build Script

Run `build-all.ps1` to build all plugins in order:

```powershell
.\build-all.ps1
```

## Development Workflow

1. **Make Changes**: Edit source code in `src/main/java/`
2. **Build**: Run Maven build command
3. **Test**: Copy JAR from `target/` to `../plugins/`
4. **Debug**: Check server logs in `../logs/`

## Project Configuration

### PluginUtils (v1.9.1)
- **API**: Paper 1.21.4
- **Java**: 21
- **Dependencies**: WorldEdit, Dynmap API, Guava

### MCME-Architect (v2.10.6)
- **API**: Paper 1.21.4
- **Java**: 21
- **Dependencies**: PluginUtils, ProtocolLib, ViaVersion

### MCME-Connect (v1.1.5)
- **Type**: BungeeCord Plugin
- **Java**: 21
- **Dependencies**: Adventure API, PluginUtils

## NMS (Net Minecraft Server) Access

These plugins use NMS for deep Minecraft internals access. Note:

- **Paper API** provides most needed functionality
- **NMS classes** are used sparingly for advanced features
- NMS code may need updates when Minecraft versions change

### NMS Classes Used

Common NMS packages accessed:
- `net.minecraft.core` - Core data structures
- `net.minecraft.world.entity` - Entity management
- `net.minecraft.world.level` - World/chunk access
- `net.minecraft.nbt` - NBT data handling
- `org.bukkit.craftbukkit` - CraftBukkit internals

## Troubleshooting

### Maven Not Found
```powershell
# Add Maven to PATH temporarily
$env:PATH += ";C:\Users\dntst\AppData\Local\Temp\apache-maven-3.9.9\bin"
mvn --version
```

### Compilation Errors with NMS
- Ensure Paper API is properly resolved
- Check that Java 21 is being used
- Verify Maven repositories are accessible

### Dependency Issues
```powershell
# Clear Maven cache and rebuild
mvn clean
mvn dependency:purge-local-repository
mvn install
```

### Missing PluginUtils Dependency
MCME-Architect and MCME-Connect depend on PluginUtils. Always build PluginUtils first with `mvn install` (not just `package`).

## IDE Setup

### IntelliJ IDEA
1. Open dev-workspace folder
2. Import as Maven project
3. Set JDK to Java 21
4. Let Maven download dependencies
5. Build > Build Project

### VS Code
1. Install Java Extension Pack
2. Install Maven for Java extension
3. Open dev-workspace folder
4. Maven commands available in Command Palette

### Eclipse
1. File > Import > Maven > Existing Maven Projects
2. Select dev-workspace folder
3. Configure Java 21 JRE
4. Project > Clean and Build

## Testing Server

Start test server:
```powershell
cd ..
java -Xmx2G -Xms2G -jar paper.jar nogui
```

## Deployment

After successful build, JAR files are located in:
- `PluginUtils/target/PluginUtils-1.9.1.jar`
- `MCME-Architect/target/MCME-Architect-2.10.6.jar`
- `MCME-Connect/target/MCME-Connect-1.1.5.jar`

Copy to server's `plugins/` directory and restart server.

## Resources

- [Paper API Documentation](https://docs.papermc.io/)
- [Spigot Plugin Development](https://www.spigotmc.org/wiki/spigot-plugin-development/)
- [WorldEdit API](https://worldedit.enginehub.org/en/latest/api/)
- [MCME GitHub](https://github.com/MCME)

## Notes

- **Paper Mappings**: Paper uses Mojang mappings since 1.20.5
- **API Changes**: Check Paper's changelogs for breaking changes
- **Version Updates**: When updating Minecraft version, update all POMs
- **Testing**: Always test on a copy of production world

## Quick Reference

### Maven Lifecycle
- `mvn clean` - Delete target directory
- `mvn compile` - Compile source code
- `mvn test` - Run tests
- `mvn package` - Create JAR file
- `mvn install` - Install to local Maven repository
- `mvn clean install` - Full clean build and install

### Useful Commands
```powershell
# Check for dependency updates
mvn versions:display-dependency-updates

# View dependency tree
mvn dependency:tree

# Skip tests during build
mvn clean package -DskipTests
```

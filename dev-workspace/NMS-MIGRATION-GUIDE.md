# NMS Migration Guide for Paper 1.21.4

## Current Status

The MCME plugins (PluginUtils, MCME-Architect, MCME-Connect) use direct NMS (Net Minecraft Server) access through classes in the `com.mcmiddleearth.pluginutil.nms` package. These plugins were built for older Minecraft versions and need updates for Paper 1.21.4.

## Why the Plugins Don't Compile

The plugins fail to compile because they directly import NMS classes that are not available in Paper API:

```
ERROR: package net.minecraft.nbt does not exist
ERROR: package net.minecraft.core does not exist
ERROR: package org.bukkit.craftbukkit does not exist
```

These packages are part of the Minecraft server internals (NMS) which are:
1. Not exposed through Paper API
2. Obfuscated in production builds
3. Subject to change between versions

## NMS Classes Used by These Plugins

The plugins extensively use NMS through these files:
- `AccessNBT.java` - Direct NBT manipulation
- `AccessWorld.java` - World/chunk/entity access
- `AccessCraftBukkit.java` - CraftBukkit internals
- `AccessCore.java` - Core Minecraft classes (BlockPos, etc.)
- `AccessServer.java` - Server-level operations
- `AccessInventory.java` - Inventory internals
- `NBTTagBuilder.java` - NBT tag construction
- `MessageUtil.java` - Network protocol packets

## Migration Options

### Option 1: Use Paper API Alternatives (RECOMMENDED)

Replace NMS code with Paper API equivalents:

**NBT Access:**
```java
// Old NMS way
CompoundTag nbt = new CompoundTag();

// New Paper way
org.bukkit.persistence.PersistentDataContainer pdc = entity.getPersistentDataContainer();
pdc.set(key, PersistentDataType.STRING, value);
```

**Block/World Operations:**
```java
// Old NMS way
ServerLevel level = ((CraftWorld)world).getHandle();

// New Paper way  
world.getBlockAt(x, y, z).setType(Material.STONE);
```

**Entity Spawning:**
```java
// Old NMS way
Entity nmsEntity = EntityType.loadEntityRecursive(nbt, level, EntitySpawnReason.COMMAND);

// New Paper way
world.spawnEntity(location, EntityType.ZOMBIE);
```

### Option 2: Use Paper's Reflection API

For cases where Paper API doesn't provide functionality:

```java
// Access NMS classes through reflection
Class<?> nmsClass = MinecraftServer.class;  // Paper exposes some NMS classes
```

### Option 3: Migrate to Gradle + Paperweight

Paper's official NMS access requires Gradle and the paperweight plugin:

1. Convert project from Maven to Gradle
2. Add paperweight-userdev plugin
3. Use remapped NMS classes

**build.gradle.kts example:**
```kotlin
plugins {
    id("io.papermc.paperweight.userdev") version "1.7.7"
}

dependencies {
    paperweight.paperDevBundle("1.21.4-R0.1-SNAPSHOT")
}
```

This provides:
- Properly remapped NMS classes
- Compile-time access to server internals
- Automatic reobfuscation for production

### Option 4: Keep Maven + Use Reflection

Stay with Maven but access NMS through reflection:

1. Use Paper API where possible
2. Use reflection for unavoidable NMS access
3. Handle version-specific code paths

**Example:**
```java
public class NMSAccess {
    private static final String VERSION = Bukkit.getServer().getClass().getPackage().getName().split("\\.")[3];
    
    public static Object getHandle(World world) {
        try {
            Method m = world.getClass().getMethod("getHandle");
            return m.invoke(world);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
```

## Recommended Approach for MCME Plugins

Given the extensive NMS usage in these plugins, I recommend:

1. **Short-term**: Comment out NMS-dependent features and get plugins loading
2. **Medium-term**: Migrate to Gradle + paperweight for proper NMS access
3. **Long-term**: Refactor to use Paper API where possible

## Alternative: Use Older Paper Version

If immediate functionality is needed, you could:
1. Downgrade to Paper 1.20.x (the version these plugins were built for)
2. Build the plugins successfully
3. Plan migration while having working plugins

## Next Steps

### To Get Plugins Building Now:

1. Comment out NMS code in:
   - `PluginUtils/src/main/java/com/mcmiddleearth/pluginutil/nms/*`
   - `PluginUtils/src/main/java/com/mcmiddleearth/pluginutil/message/MessageUtil.java`

2. Build plugins with: `.\build-all.ps1`

3. Test which features still work without NMS

### To Properly Fix:

1. Convert to Gradle build system
2. Add paperweight-userdev plugin
3. Update NMS code for 1.21.4 changes
4. Test thoroughly

## Resources

- [Paper API Documentation](https://jd.papermc.io/paper/1.21/)
- [Paperweight Userdev Guide](https://docs.papermc.io/paper/dev/userdev)
- [Paper Discord](https://discord.gg/papermc) - Get help from Paper developers
- [Spigot to Paper Migration](https://docs.papermc.io/paper/migration)

## Contact MCME Plugin Authors

These plugins are maintained by the MCME (Minecraft Middle Earth) team. Consider:
1. Checking their GitHub for updates
2. Opening an issue about 1.21.4 compatibility
3. Contributing a pull request with fixes

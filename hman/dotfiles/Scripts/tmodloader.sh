#!/usr/bin/env bash
(
  export __GL_THREADED_OPTIMIZATIONS=1
  export __GL_SYNC_TO_VBLANK=0
  export __GL_YIELD="USLEEP"
  export __GL_ALLOW_UNLIMITED_COMMAND_BUFFERS=1
  export __GL_MaxFramesAllowed=1
  export vblank_mode=0
  
  # Shader Cache
  export __GL_SHADER_DISK_CACHE=1
  export __GL_SHADER_DISK_CACHE_PATH="$HOME/.nv-shader-cache"


  gamemoderun ~/.local/share/Steam/steamapps/common/tModLoader/start-tModLoader.sh
)

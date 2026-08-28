#!/bin/bash
cd "$(dirname "$0")"
export PATH="/c/Users/marya/AppData/Local/Programs/Python/Python311:/c/Users/marya/AppData/Local/Programs/Python/Python311/Scripts:$PATH"

# Auto-discover ffmpeg
for d in /c/Users/marya/AppData/Local/Microsoft/WinGet/Packages/Gyan.FFmpeg_*/ffmpeg-*/bin; do
  export PATH="$d:$PATH"
done

exec .venv/Scripts/python -u app.py

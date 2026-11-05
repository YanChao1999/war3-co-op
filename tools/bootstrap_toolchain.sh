#!/usr/bin/env bash
# Downloads Wurst compiler 2.0.0 + stdlib into .tools / _build (gitignored).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
mkdir -p .tools _build/dependencies

COMPILER_URL="https://github.com/wurstscript/WurstScript/releases/download/v2.0.0/wurst-compiler-2.0.0-linux-x64.zip"
STDLIB_URL="https://codeload.github.com/wurstscript/wurstStdlib2/zip/refs/heads/master"
TEMPLATE_URL="https://codeload.github.com/wurstscript/wurst-project-template/zip/refs/heads/master"

if [[ ! -x .tools/wurst-compiler/wurstscript ]]; then
  echo "Downloading Wurst compiler..."
  curl -L --fail -o /tmp/wurst-compiler.zip "$COMPILER_URL"
  rm -rf .tools/wurst-compiler
  mkdir -p .tools/wurst-compiler
  python3 - <<PY
import zipfile
zipfile.ZipFile('/tmp/wurst-compiler.zip').extractall('$ROOT/.tools/wurst-compiler')
PY
  chmod +x .tools/wurst-compiler/wurstscript .tools/wurst-compiler/grill .tools/wurst-compiler/wurst-runtime/bin/java || true
fi

mkdir -p .tools/jass .tools/jass/1.27a
python3 - <<PY
import zipfile, os
root = '$ROOT'
jar = os.path.join(root, '.tools/wurst-compiler/wurst-compiler/wurstscript.jar')
if not os.path.isfile(jar):
    jar = os.path.join(root, '.tools/wurst-compiler/wurstscript.jar')
z = zipfile.ZipFile(jar)
for name in ['common.j', 'blizzard.j']:
    open(os.path.join(root, '.tools/jass', name), 'wb').write(z.read(name))
    print('extracted jar', name)
PY

# Classic 1.27a natives (no Blz*) — required for 1.27a clients.
echo "Downloading TFT 1.27a common.j / Blizzard.j ..."
curl -fsSL --max-time 60 \
  "https://raw.githubusercontent.com/wurstscript/jass-history/master/war3extract/TFT-v1.27a-ru/Scripts/common.j" \
  -o .tools/jass/1.27a/common.j
curl -fsSL --max-time 60 \
  "https://raw.githubusercontent.com/wurstscript/jass-history/master/war3extract/TFT-v1.27a-ru/Scripts/Blizzard.j" \
  -o .tools/jass/1.27a/blizzard.j
cp -f .tools/jass/1.27a/common.j .tools/jass/common.j
cp -f .tools/jass/1.27a/blizzard.j .tools/jass/blizzard.j
echo "1.27a jass ready."

if [[ ! -d _build/dependencies/wurstStdlib2/wurst ]]; then
  echo "Downloading WurstStdlib2..."
  curl -L --fail -o /tmp/wurst-stdlib.zip "$STDLIB_URL"
  python3 - <<PY
import zipfile, shutil, os
root = '$ROOT'
zipfile.ZipFile('/tmp/wurst-stdlib.zip').extractall('/tmp')
dst = os.path.join(root, '_build/dependencies/wurstStdlib2')
shutil.rmtree(dst, ignore_errors=True)
shutil.move('/tmp/WurstStdlib2-master', dst)
print('stdlib ->', dst)
PY
fi

if [[ ! -f LastFortress.w3x ]]; then
  echo "Downloading starter map template..."
  curl -L --fail -o /tmp/wurst-tpl.zip "$TEMPLATE_URL"
  python3 - <<PY
import zipfile, shutil, os
root = '$ROOT'
zipfile.ZipFile('/tmp/wurst-tpl.zip').extractall('/tmp')
src = '/tmp/wurst-project-template-master/ExampleMap.w3x'
shutil.copy(src, os.path.join(root, 'LastFortress.w3x'))
os.makedirs(os.path.join(root, 'maps/last_fortress'), exist_ok=True)
shutil.copy(src, os.path.join(root, 'maps/last_fortress/template.w3x'))
print('map template ready')
PY
fi

echo "Toolchain ready."
.tools/wurst-compiler/wurstscript -version

  #!/bin/zsh
set -euo pipefail

project_dir="${0:A:h}"
build_dir="$project_dir/work/build"
cache_dir="$project_dir/work/clang-cache"
output_dir="$project_dir/outputs"
app_dir="$output_dir/FloatView.app"

mkdir -p "$cache_dir" "$output_dir"

SWIFTPM_MODULECACHE_OVERRIDE="$cache_dir" \
CLANG_MODULE_CACHE_PATH="$cache_dir" \
swift build \
    --package-path "$project_dir" \
    --scratch-path "$build_dir" \
    --disable-sandbox \
    --arch arm64 \
    --arch x86_64 \
    -c release

mkdir -p "$app_dir/Contents/MacOS" "$app_dir/Contents/Resources"
cp "$build_dir/apple/Products/Release/FloatView" "$app_dir/Contents/MacOS/FloatView"
cp "$project_dir/Resources/Info.plist" "$app_dir/Contents/Info.plist"
chmod 755 "$app_dir/Contents/MacOS/FloatView"

xcrun actool "$project_dir/Resources/Assets.xcassets" \
    --compile "$app_dir/Contents/Resources" \
    --platform macosx \
    --minimum-deployment-target 13.0 \
    --app-icon AppIcon \
    --output-partial-info-plist "$build_dir/AppIcon-partial.plist" \
    >/dev/null

codesign --force --deep --sign - \
    -r='designated => identifier "app.codex.FloatView"' \
    "$app_dir"
echo "$app_dir"

#!/bin/bash
set -euo pipefail

PRODUCT_NAME="zdock"
APP_BUNDLE="${PRODUCT_NAME}.app"

SDKROOT="$(xcrun --show-sdk-path)"
DEPLOYMENT_TARGET="14.0"

SOURCES=(
    Sources/zdock/zdockApp.swift
    Sources/zdock/ContentView.swift
    Sources/zdock/Models/AppInfo.swift
    Sources/zdock/Services/AppService.swift
    Sources/zdock/Services/Config.swift
    Sources/zdock/ViewModels/ViewModel.swift
    Sources/zdock/Views/SettingsView.swift
)

echo "==> Compiling..."
mkdir -p .build
swiftc \
    -o ".build/$PRODUCT_NAME" \
    -target "arm64-apple-macosx$DEPLOYMENT_TARGET" \
    -sdk "$SDKROOT" \
    -module-name "$PRODUCT_NAME" \
    -framework SwiftUI \
    -framework AppKit \
    -O \
    "${SOURCES[@]}"

echo "==> Creating $APP_BUNDLE..."
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

cp ".build/$PRODUCT_NAME" "$APP_BUNDLE/Contents/MacOS/$PRODUCT_NAME"
cp "Info.plist" "$APP_BUNDLE/Contents/Info.plist"

if [ -f "AppIcon.icns" ]; then
    cp "AppIcon.icns" "$APP_BUNDLE/Contents/Resources/"
fi

echo "==> Signing..."
codesign --force --deep --sign - "$APP_BUNDLE"

echo ""
echo "==> Done! Run with: open \"$APP_BUNDLE\""

function vst3_doctor() {
  # Usage: vst3_doctor "Plugin.vst3"  OR  vst3_doctor "/Library/Audio/Plug-Ins/VST3/Plugin.vst3"
  local input="$*"
  if [[ -z "$input" ]]; then
    echo "Usage: vst3_doctor <plugin .vst3 path or name>"
    return 1
  fi

  # Pretty section header
  _vst3hdr() { printf "\n\033[1m==> %s\033[0m\n" "$1"; }

  # Resolve plugin path (PWD, user VST3, system VST3)
  local plugin="$input"
  if [[ ! -e "$plugin" ]]; then
    if [[ -e "$PWD/$input" ]]; then
      plugin="$PWD/$input"
    elif [[ -e "$HOME/Library/Audio/Plug-Ins/VST3/$input" ]]; then
      plugin="$HOME/Library/Audio/Plug-Ins/VST3/$input"
    elif [[ -e "/Library/Audio/Plug-Ins/VST3/$input" ]]; then
      plugin="/Library/Audio/Plug-Ins/VST3/$input"
    else
      echo "❌ Could not find: $input"
      echo "   Checked:"
      echo "     - $PWD/$input"
      echo "     - $HOME/Library/Audio/Plug-Ins/VST3/$input"
      echo "     - /Library/Audio/Plug-Ins/VST3/$input"
      return 1
    fi
  fi

  # Require .vst3 bundle
  if [[ "${plugin##*.}" != "vst3" ]]; then
    echo "❌ Not a .vst3 bundle: $plugin"
    return 1
  fi

  # Sudo when touching system bundle
  local asudo=""
  if [[ "$plugin" == /Library/* ]] && [[ ! -w "$plugin" ]]; then
    asudo="sudo"
  fi

  _vst3hdr "Target"
  echo "Bundle: $plugin"

  # Expect standard structure
  local contents="$plugin/Contents"
  local macos="$contents/MacOS"
  local info="$contents/Info.plist"
  if [[ ! -d "$contents" || ! -d "$macos" || ! -f "$info" ]]; then
    echo "❌ Malformed bundle. Expected:"
    echo "   $plugin/Contents/"
    echo "   $plugin/Contents/MacOS/<binary>"
    echo "   $plugin/Contents/Info.plist"
    return 1
  fi

  _vst3hdr "Info.plist sanity"
  /usr/bin/plutil -p "$info" 2>/dev/null | /usr/bin/egrep 'CFBundleIdentifier|CFBundleExecutable|CFBundlePackageType|CFBundleVersion' || true

  # Read executable name
  local exe
  exe=$(/usr/bin/defaults read "${contents}/Info" CFBundleExecutable 2>/dev/null)
  if [[ -z "$exe" ]]; then
    echo "❌ CFBundleExecutable missing in Info.plist"
    return 1
  fi
  local exepath="$macos/$exe"
  echo "Executable: $exepath"

  # Ensure executable exists and is +x
  if [[ ! -f "$exepath" ]]; then
    echo "❌ Executable file not found at $exepath"
    return 1
  fi
  if [[ ! -x "$exepath" ]]; then
    _vst3hdr "Fix: make executable"
    $asudo /bin/chmod +x "$exepath" || {
      echo "❌ chmod failed"
      return 1
    }
  fi

  _vst3hdr "Architectures"
  /usr/bin/file "$macos"/* || true
  local host_arch
  host_arch=$(/usr/bin/uname -m)
  echo "Host shell arch: $host_arch"
  echo "Note: Your DAW may run under Rosetta (x86_64) even on Apple Silicon."

  _vst3hdr "Clear quarantine / extended attributes"
  if ! $asudo /usr/bin/xattr -cr "$plugin"; then
    echo "⚠️  xattr failed (may be harmless)"
  else
    echo "✓ xattr cleared"
  fi

  _vst3hdr "Ad-hoc code sign"
  # Try deep ad-hoc sign; if it fails, try without --deep as fallback
  if $asudo /usr/bin/codesign --force --deep --sign - "$plugin" 2>/dev/null; then
    echo "✓ codesign (deep) OK"
  else
    echo "… retrying without --deep"
    if ! $asudo /usr/bin/codesign --force --sign - "$plugin"; then
      echo "❌ codesign failed"
      return 1
    fi
  fi

  _vst3hdr "Verify signature"
  if /usr/bin/codesign -dv --verbose=4 "$plugin" >/dev/null 2>&1; then
    /usr/bin/codesign -dv --verbose=4 "$plugin" 2>&1 | sed 's/^/  /'
  else
    echo "❌ Verification failed"
    return 1
  fi

  _vst3hdr "Gatekeeper assessment"
  # Assess the main executable (better signal than bundle)
  if /usr/sbin/spctl --assess --type execute -vv "$exepath" >/dev/null 2>&1; then
    /usr/sbin/spctl --assess --type execute -vv "$exepath" 2>&1 | sed 's/^/  /'
  else
    echo "⚠️  spctl reports rejected (often okay for ad-hoc signatures). Details:"
    /usr/sbin/spctl --assess --type execute -vv "$exepath" 2>&1 | sed 's/^/  /'
  fi

  _vst3hdr "Common blockers (quick hints)"
  echo "• If 'file' shows x86_64 only and your DAW is native arm64, launch the DAW with Rosetta (Get Info → Open using Rosetta) and rescan."
  echo "• Ensure the bundle is in one of these paths (most DAWs scan the system path by default):"
  echo "    ~/Library/Audio/Plug-Ins/VST3"
  echo "    /Library/Audio/Plug-Ins/VST3"
  echo "• After this, force a FULL rescan in your DAW's plug-in manager."

  _vst3hdr "Done"
  echo "If it still won’t appear, check your DAW’s scan log (e.g., Ableton: ~/Library/Preferences/Ableton/Live */Log.txt)."
}

# iBox — iPhone TV Box prototype

This repository contains:
- `iBox-source.zip`: native iOS project and TV-browser diagnostic PWA.
- GitHub Actions workflow to build an **unsigned** iOS IPA on macOS.
- GitHub Pages workflow to publish the Samsung TV browser test page.

## Intended use
The iPhone is the compute device. The Samsung TV is the display, initially through AirPlay. The iPhone app provides a touch remote; the TV browser page is a separate optional IR-remote diagnostic. If the Samsung browser does not expose the IR remote's keys to JavaScript, skip that path and use the iPhone touch controller.

## Build
Open **Actions → Build iBox unsigned IPA → Run workflow**. Download the `iBox-unsigned-ipa` artifact and submit it to Signulous for signing/installation. This workflow does not contain signing credentials and does not produce an installable signed IPA by itself.

## TV remote test
After GitHub Pages deployment, open the Pages URL in Samsung Internet and test Up/Down/Left/Right, OK and Back. If keys do not appear in the diagnostic panel, use the iPhone controller; no additional remote hardware is required.

## Important
iOS 27 external-display support uses `UISceneAccessory.externalNonInteractive`. AirPlay/HDMI external-display behavior must be verified on the physical iPhone and Samsung TV. The app is a prototype, not a full media player or tvOS replacement.

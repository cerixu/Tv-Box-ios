# iBox — iPhone TV Box prototype

**Repo:** https://github.com/cerixu/Tv-Box-ios

## What this build does
- Native iOS app: iPhone touch remote + separate full-screen TV view when iOS 27 provides an external display scene over AirPlay or cable.
- Six TV launcher tiles: Movies, Series, YouTube, Music, Photos, Apps. These are navigation placeholders, not finished streaming integrations.
- Samsung TV browser diagnostic page to test whether its browser forwards IR remote keys to JavaScript.
- Offline-capable TV web page (Service Worker + cache fallback).

## Your setup
- iPhone 17 Pro Max, iOS 27.2.1
- Samsung UE55TU7002KXXH
- AirPlay as the initial wireless display path
- iPhone touch controller is the primary input
- IR remote test is optional; if the TV browser does not expose keys, skip it
- Signulous is used to sign/install the unsigned IPA

## Build the IPA
1. Open **Actions → Build iBox unsigned IPA → Run workflow**.
2. Wait for the macOS runner to finish.
3. Open the completed run and download **iBox-unsigned-ipa** from Artifacts.
4. Upload the unsigned IPA to Signulous for signing, then install the signed build.

The workflow uses XcodeGen and Xcode on GitHub's macOS runner. It does not require a local Mac. It deliberately does not store signing certificates, provisioning profiles, or Apple credentials in this repository. The resulting IPA is **unsigned** until Signulous signs it.

## Test the optional IR remote path
1. In repository **Settings → Pages**, select **GitHub Actions** as the Pages build/deployment source if Pages has not been enabled yet.
2. Run **Actions → Deploy iBox TV test to GitHub Pages**.
3. Open the deployed Pages URL in the Samsung TV's Internet browser.
4. Press Up, Down, Left, Right, OK and Back on the IR remote.
5. The diagnostic panel shows the most recent key and key code if the browser exposes it to the page.

If the browser does not show the key events, stop testing IR. Use the iPhone's on-screen remote in the native app instead. The TV does not forward IR button presses over AirPlay to an iOS app.

## First AirPlay test
1. Install iBox on the iPhone through Signulous.
2. Connect iPhone and Samsung to the same Wi-Fi.
3. Start iBox on the iPhone.
4. Open Control Center → Screen Mirroring → select the Samsung TV.
5. The iPhone remains the controller. If iOS makes the registered external-display accessory available for that AirPlay session, iBox renders its separate TV interface on the Samsung.

## Technical notes
- iOS 27 external display path uses `UIViewController.registerSceneAccessory` with `UISceneAccessory.externalNonInteractive`.
- AirPlay support and the external-display accessory must be verified on the physical TV/phone pair; simulator or CI cannot prove the Samsung connection.
- This is an early launcher prototype, not tvOS, not a full streaming box yet. Media playback, provider integrations, DRM, and app deep links are later stages.

# iOS App Store release setup

The `release-ios.yml` workflow is intentionally safe for repositories without
an Apple Developer account. It runs the credential check first and exits
successfully with a clear skip message when any required secret is missing.
The workflow runs for manual dispatches and tags matching `v*`.

## Prerequisites

Before enabling a real release, the developer needs:

1. An active Apple Developer Program account.
2. The bundle identifier `com.ralvarezmar.vcheck` registered in the Apple
   Developer account.
3. Signing and provisioning configured for the app, with automatic signing
   allowed for the release runner.
4. An app record in App Store Connect whose bundle ID is
   `com.ralvarezmar.vcheck`.
5. App Store Connect access to upload builds to TestFlight.

The Xcode project is generated from `project.yml` by XcodeGen. The release
workflow archives the `VeganLens` scheme and uploads the resulting
`VeganLens.ipa`.

## GitHub secrets

Create these repository or environment secrets under **Settings → Secrets and
variables → Actions**:

| Secret | Value |
| --- | --- |
| `ASC_KEY_ID` | The 10-character key ID from App Store Connect. |
| `ASC_ISSUER_ID` | The issuer ID shown in App Store Connect API access. |
| `ASC_API_KEY_P8` | The complete `.p8` private-key file encoded as base64. |
| `ASC_TEAM_ID` | **Optional.** Your 10-character Apple Developer Team ID; set it if your account belongs to more than one team, otherwise leave unset. |

Do not commit the `.p8` file, its base64 value, or any credentials to the
repository.

Find the Team ID in App Store Connect or Apple Developer under **Membership
details**.

## Create the App Store Connect API key

An Account Holder or an administrator can create the key:

1. Sign in to [App Store Connect](https://appstoreconnect.apple.com/).
2. Open **Users and Access → Integrations → App Store Connect API**.
3. Open **Team Keys**, choose **Generate API Key**, enter a meaningful name,
   and choose an appropriate role that can upload builds to TestFlight.
4. Download the `.p8` file once. Apple does not make the private key available
   for a second download.
5. Copy the displayed **Key ID** into `ASC_KEY_ID`.
6. Copy the displayed **Issuer ID** into `ASC_ISSUER_ID`.
7. Base64-encode the downloaded key and store the output as `ASC_API_KEY_P8`.

On macOS or Linux, from the directory containing the downloaded key:

```sh
base64 < AuthKey_XXXXXXXXXX.p8 | tr -d '\n'
```

Paste the resulting single-line value into the `ASC_API_KEY_P8` secret. Keep
the original `.p8` file in a secure password manager or other protected
location.

## Running a release

- Push a tag such as `v1.0.0`, or use **Actions → iOS Release → Run workflow**.
- The workflow runs `xcodegen generate`, archives the app, exports an
  App-Store-Connect archive, and uploads the IPA with `xcrun altool`.
- Builds appear in App Store Connect under **TestFlight** after Apple's
  processing completes.
- On `main`, the release also creates or updates the App Store version,
  attaches the processed build, and writes Spanish `What's New` notes.
- The App Store review submission remains manual and is handled by the
  **iOS App Store Submit for Review** workflow.
- Run that workflow manually with an optional `versionString`; if it is empty,
  the workflow submits the latest editable App Store version.
- If one or more secrets are absent, the workflow reports that releases are
  skipped and exits successfully; it does not attempt to archive or upload.

The workflow uses the App Store Connect API key only on the ephemeral GitHub
Actions runner and removes the runner after the job.

## Versioned unsigned builds

The `release.yml` workflow produces an unsigned, versioned `.ipa` on every push
to `main`, analogous to the Android release workflow. It creates a GitHub
Release, stores `releases/VeganLens-unsigned.ipa` in the repository, and writes
the resolved version and build number to `VERSION`.

The signed App Store upload remains handled by `release-ios.yml` and requires
the `ASC_*` secrets. The unsigned IPA is a versioned build artifact and is not
installable on a device without signing.

# Releases

## Preparation

### Changed Dependency Libraries
If new libs were added in the `pubspec.yaml` (or if some were removed or changed):
* Add/remove/change them in the `licences.dart` file

### Changed Preferences
Since every preference results in a separate cookie in the web version:
* Add/remove/change cookie in the `cookie_policy.html`

### Write Changelog
* Check closed PRs and global commit history for new features (flag with `[new]`), big fixes (`[fix]`) or changes (`[chg]`)
* If a bugfix was externally reported you may want to add (`Thanks, XYZ`) to that entry
* Write changelog string as late as possible because the translations shouldn't get outdated if something will be added. And if so, translaters may not have the chance to update their translations.
* Wait for translators for translating the changelog; you gonna need them for the app stores
* Hide old changelog strings in Crowdin, it's not necessary to translate them furtherly
* In `changelogs.dart` add new version and probable release date

### Languages
* Upload sources files to Crowdin: `crowdin upload sources`
* Wait a few days for translaters
* Download translated: `crowdin download`
* In Crowdin check percentages for languages and put them into `supported_locales.dart`

### Update Flutter and Dependencies
* Update Flutter last time before final internal testing on both, your Android and your iOS machine
* Do this on both machines at the same point to ensure building with the same Flutter version
* If new Flutter version will be published later, it should be ignored since you are not able to test possible impacts anymore
* Same for Dependencies: Last check for outdated packages and upgrading to latest possible without risking too big changes

### Contributers/Testers
* Update about.dart for contributors and relevant translators (and maybe team member changes)
* Check mails, forums and social media and whatever for bug reporters (we gave the promise for them!) or relevant feature requests (less common, but in special cases e.g. for a good enhancement, some earned the Tester's badge here as well) to add these people to "Testers" in about.dart

### README.md
* Check if you want to update the `README.md`

### Legal Sites
* `cookie_policy.html` contains a list of cookies. Every "Pref" used in the code will be stored as a cookie. So if you added some in the new version, you need to add them in the websites
* `privacy_police.html` contains the permissions the app needs, like localisation or file access. It also lists the destinations of third party web links like OpenStreetMap or the Dow Jones API Check if the list is still up-to-date
* `impressum.html`: Your contact data is still up-to-date?
* Don't forget to update the "Last updated" section of the files
* Remember: For privacy reasons, the legal websites are not part of the public GitHub repository. So ensure to make the changes also in your back-up

### Preparing the App Stores

#### Android PlayStore Console
* https://play.google.com/console/
* A new language was added?
  * Create a new language
  * Add short descriptions (length is limited) for Normal and Gold
  * Add long descriptions for Normal and Gold. (Remember 500 character limitations per language)
  * Save and send to review (?)

#### iOS AppStore Connect
* Prepare new version:
* A new language was added?
  * Normal Version: 
    * Add Short Description (length is limited)
    * Add Long Description:
      * Country flag symbols make problems. Remove them
      * Check for automatically included empty lines and remove them if necessary
      * only 4000 characters
    * Optional: Screenshots in that language for both Normal and Gold
  * Gold Version:
    * Generally the same but different Short text and add the "Gold Long Description" part in front of normal Long Description Text (both, short and long part explain that this is pure donation, no additional features)
    * Save and Send To Review

### Code Optimization

#### Optimize Imports
* Project explorer, project root, right click -> Optimize Imports
* Commit with appropriate message text
#### Format Code
* `dart format lib -l 120`
* Commit with appropriate message text

### Social Media
* Prepare blog post for new version in EN and DE (currently done only for Major and Minor releases, not for Patch releases)
* Name it `Release X.Y.Z`
* Current structure:
  * Some introducing words
  * `Highlights of version X.Y.Z`: Introducing to most interesting new things with a section each
  * `Changelog`
* Link both language versions in the blog post's language setting

### Symbol Table PDFs
* Create the new PDF files for symbol tables for the supported Languages
* Upload the files to `./misc/symbol_tables` via FTP

### Additional Files
* Check that the valid Mapbox token file named `mapbox` is in `/assets/tokens/` directory

## Release

### Android

#### General workflow
* Release in Internal Testing (maybe use it to check if everything is alright)
*   *Promote  * this release (not creating a separate one, even not with the same build file!) to other stages:
  * Closed Testing (Alpha); One should think about moving the few users there to Open Testing. But currently they have to do the moving on their own. If you decide to end the close testing currently you would get rid of the very early users which are still quite active
  * Open Testing (Beta); Maybe you want to keep the release there for a few weeks to wait for first responses, maybe some critical issues
  * Production

#### Building
* Switch to x.y.z branch -> Pull
* Check new version (incl. build number) in Pubspec.yaml
* Check correct name in android/app/src/main/AndroidManifest.xml
* `flutter clean`
* `flutter build appbundle --release --target-platform android-arm,android-arm64`

#### Publishing
* https://play.google.com/console/
* Create new release as Internal Test
  * upload the new Build
  * Name: New version number
  * Add changelogs:
    * For every translated changelog string add a section
    * For each language section you have only limited space, so maybe you need to shorten the entries, remove the `Thanks...` parts, ...
    * For each available language which is not yet translated, you can remove the section
  * Wait for processing the new build package
  * Save and roll out
  * Wait for roll out in the actual PlayStore: Load it, check if it's working
* Create public test releases:
  * Go to Testing/Internal Testing -> Find your Internal Test release -> Release Summary
  * Promote to Closed Testing (check the build, Save and rollout)
  * Promote to Open Testing (check the build, Save and rollout)
  * Go to Review overview: Send to Review
  * Reviewing may take a few days
  * For Major/Minor Releases: Wait 1-2 weeks for maybe incoming crash reports
* Public Production Release
  * Go to Testing/Internal Testing -> Find your Internal Test release -> Release Summary
  * Promote to Production (check the build, Save and rollout)
  * Go to Review overview: Send to Review 
  * Reviewing may take a few days
  * Normally the production is set to only 20% release -> Set it to 100% instead

#### Gold Version
* Recommendation: Wait until Normal versions really passed the official reviews to be sure that nothing went wrong
* Replace normal icons in `android/app/src/main/res` with `android/app/src/main/res/icons_gold`
* change package name to `gc_wizard_gold`:
  * in file: `android/app/src/main/AndroidManifest.xml` (and `application/android`:label to "GC Wizard Gold", too)
  * twice in file: `android/app/build.gradle` -> `defaultConfig` and `android/namespace`
  * Redo the **Building** and **Publishing** parts
* After release: Restore local workspace repos from gold to normal version (`git reset --hard`)

### iOS

#### Building
* Go to the terminal
* Switch to x.y.z branch
  * `git fetch`
  * `git switch x.y.z`
  * `git pull`
* Check new version (incl. build number) in Pubspec.yaml
* `flutter clean`
* `flutter build ios`
* Open `./ios/Runner.xcworkspace` -> Should open XCode
  * check correct version and build number for the Runner Target (`General/Identity`)
  * maybe correct the bundleIdentifier in (`Signing and C...` section) to `de.sman42.gcWizard`
  * bundle for all iOS devices (`Product/Build For/Destinations/`)
  * archive bundle (takes some time, even if no progress visible) (`Product/Archive`)

#### Publishing
* When finishing Archive step it should raise a window:
  * Check that the new version is selected
  * Distribute to Apple App Store / Testflight
* Any Browser -> `https://appstoreconnect.apple.com/`
  * Testflight: wait for processing (takes ca. 30 min)
  * check "No Encryption Algorithms" (or similar)
  * Add "GCWizard Testers" as users to test version
  * Insert new changelogs for EN and DE
  * Now you created the Testflight's test version (important to publish to all who installed the app as Testers)
  * For Major/Minor releases you may want to wait a few days for any critical feedback
* Public Release
  * Go to normal AppStore
  * Create new version with correct version number
  * Add changelogs for all supported languages
    * If changelog translation in a supported language is not provided, add EN changelog manually
  * Add Build Version (from TestFlight)
  * Save/Send to Review -> now it's only on status "Ready for review"
  * Menu/General/App Reviews -> Transmit to Review
  * Reviewing may take a few days

#### Gold Version
* In Finder ("Explorer") replace normal icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset/` with `ios/Runner/Assets.xcassets/AppIcon.appiconset/icons_gold`
* In XCode:
  * change bundle identifier in XCode/Info.plist in ios/Runner (`Signing and C...` section) to `de.sman42.gcWizardGold`
  * change Display Name to "GC Wizard Gold" (`General/Identity`)
* Repeat the **Building** and **Publishing** steps
* After release: Restore local workspace repos from gold to normal version (`git reset --hard`)

### Web

#### Preparation
* Check the legal files for being updated as described above
#### Building
* `flutter clean`
* `flutter build web`
#### Publishing
* Open gcwizard.net web directory in FTP
* Create new directory with tempory name `/app_x.y.z` (with x.y.z is the new release number)
* Upload the new web build into this directory
* (Alternatively you can put it into `/app_test` and check the build beforehand in test.gcwizard.net)
* Rename the `/app` directory to `/app_a.b.c` (with a.b.c is the version which was published until now)
  * There should be 1-2 older version online for being able to make a really quick roll-back just by renaming the old version's directory to be restored to '/app'
* Rename `/app_x.y.z` to `/app` (or rename `/app_test` and create a new test directory instead)
* **Warning**:
  * You can only modify (remove, change) files and directory which were created by the FTP user you are currently logged in. So if some operations may not work because of "permission denied" it could be that this resource was created by another FTP user. So keep an eye on which user you are using.

### Pray
* Hopefully everything works fine. But prepare yourself for nasty issues like unsupported XCode or POD versions, new App/PlayStore restrictions, review denies, ...
* Any changes: Please update this document
* Any problems: Please document the solutions (currently in `cheat_sheet`)

## Aftermath
* Remind the release in forums and social media
* GitHub:
  * Merge your version branch into `master` branch
  * Tag the merge commit of the `master` with the version number
  * Remove feature branches
  * Maybe remove older version branches (just keep the 2-3 most recent version branches in case of uprising questions)
  * Create next main version branch and next bugfix branch on this commit from the `master` (if new version is 5.2.0, create 5.3.0 - or 6.0.0 for major plans - and 5.2.1)
  * Currently the next version branch is used as main branch on Github because most contributors don't check the destination branch for a PR and the reviewer misses this as well regularly ;) So, if this practise should be continued:
    * Go to GitHub settings and set relevant branch as main branch instead of master 
  * Propagate new status to developers
* Crowdin: Hide last "changelog" string (Past changelog don't need to be translated)
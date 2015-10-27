## 0.26.0/0.27.0 - CSS & OPLOG_URL
* Force a `top: 0` to `panel-body`: #45.
From @jazee 👏
* Setting for `OPLOG_URL` was defined but not used: #49.
* Package bumped.

## 0.25.0 - Meteor settings
From @coopermaruyama 👏
* Add field to settings panel to specify path to settings.json file.
* Uses absolute or relative path.
* Ensures the file exists before launching.

## 0.24.3 - Speeds up initialization
* #36

## 0.24.2 - Deprecation fixes
* `getPath` deprecation.

## 0.24.1 - Deprecation fixes
* Menu deprecation: Contributions from: @zimme and @nyaaao :clap:

## 0.24.0 - Multiple paths
* Better setting description from @johnschult and @nowakstefan.
* Multiple paths from @johnschult and @nowakstefan.
* FAQs in the README.

## 0.23.0 - Automatic activation
* Rely on automatic activation for Settings issues #32

## 0.22.0 - Atom's View
* Using SpacePen package for Settings issues #32

## 0.21.1 - Styles location deprecation warning
* Move stylesheets to styles #31 by @zimme :clap:
* Package bumped.

## 0.21.0 - Show or hide Meteor's pane
* Add a shortcut for showing or hiding Meteor's pane, thus avoiding mouse use.

## 0.20.1 - Visual fixes & Optimized Meteor logo
* Small CSS fixes :lipstick:
* 50% optimization on Meteor's logo.

## 0.20.0 - Fix workspace's view deprecation
* atom.workspaceView is no longer available (#26).

## 0.19.0 - Octicon fonts, deprecation warnings, OS specific shortcuts
* Deprecation warning fixes and OS specific shortcuts by @nyaaao :clap:
* Octicon icons instead of font-awesome.
* Updates of Velocity.

## 0.18.1 - Panel fixes
* Autoscroll fixes by @nyaaao :clap:
* Panel header size fixes :lipstick:

## 0.18.0 - Reset Meteor
* Use `ctrl-alt-r` for resetting your Meteor instance.

## 0.16.0 - Customized log colors
* Display Meteor's log using currently selected Atom theme.
* Remove date from logs for better readability (only conserving time).

## 0.15.0 - New Meteor logo
* Pure :lipstick:, but so nice. Logo is from [Ben Strahan](https://twitter.com/benjaminstrahan) :clap:

## 0.14.1 - Better exit support
* Now relying on window's events for killing Meteor process.

## 0.14.0 - Support for MONGO_OPLOG_URL
* Remove unnecessary actions in menu.
* Adding support for MONGO_OPLOG_URL.
* Some additional documentation.

## 0.13.1 - Compatibility with Atom-0.138-0
* Better isolation of Velocity.
* Removing q-io as it messes with the Node's module cache feature introduced in Atom-0.138.0.

## 0.13.0 - Per project configuration & debug
* Use the Meteor-0.9.4 debug capability: `meteor debug`.
* Per project configuration uses [Meteor Up](https://github.com/arunoda/meteor-up)'s configuration file.

## 0.12.0 - Adaptation to new configuration scheme
* Adapt to Atom changes on the configuration scheme: [Config API Improvements](http://blog.atom.io/2014/10/02/config-api-has-schema.html).

## 0.11.0 - Stack trace & console.log/error readability
* Use ansi-to-html to add new lines. Thank goes to [Joshua Horovitz](https://github.com/joshuahhh) for #10 :clap:.
* Report Meteor's `console.error` as errors. Thus firing up the error's pane.
* Keep previous status pane when Meteor is only reporting `console.log`.
* Split Meteor's output when Meteor's console are not flushed (multiple console logs received on `stdout`).

## 0.10.0 - Theming Meteor's console.log
* Customize your `console.log`'s color in the settings' (requested by [Andreas Fruth](http://crater.io/posts/W2Az8PQJ4aKTuf2ET)):lipstick:.

## 0.9.0 - Debug Meteor and custom MongoDB URL
* Launch Meteor in debug mode.
* Customize MongoDB's URL (see enhancement request #7).
* Dependencies update:
  * font-awesome: 4.1 to 4.2
  * velocity-animate: 0.4.1 to 1.0.0

## 0.8.1 - Default for Meteor
* As Meteorite is not anymore required, Meteor is set as the default :zap:.

## 0.8.0 - Better theming
* Better light and dark theme integration :lipstick:. Thank goes to [Bernardo Kuri](https://github.com/bkuri) :clap:.
* Fix fonts setting on Linux :penguin:. Thank goes to [Bernardo Kuri](https://github.com/bkuri) :clap:.

## 0.7.0 - Production checks
* Setting for adding the production flag :factory:

## 0.6.0 - Kill process on exit
* Small refactoring :cyclone:
* Kill Meteor's process and subprocess (Mongo): Fix issue #3 :boom:

## 0.5.0 - Change port setting
* Change the port on which Meteor is listening :ear:

## 0.4.1 - Meteorite quick fix for Atom call outside a terminal
* A simple fix that should work for OSX :apple: and Linux :penguin: (Meteorite isn't available on Windows)

## 0.4.0 - Published Release
* Removal of Bower dependencies

## 0.1.0 - Initial Release
* Simple process exec for launching Meteor :black_circle:  

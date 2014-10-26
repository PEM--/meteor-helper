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

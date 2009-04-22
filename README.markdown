# PHP.sugar

> Version 1.0b5

## Contributors

* Derek Reynolds <derekr@me.com>, [http://whatupderek.com](http://whatupderek.com), [http://gridlee.com](http://gridlee.com)
* Nicholas Penree <drudge@conceitedsoftware.com>, [http://conceitedsoftware.com/](http://conceitedsoftware.com/)

## About

The PHP.sugar is bundled with Espresso. The source is maintained here, and is the best place to check up on development/get bleeding edge versions.

Always looking for suggestions and ideas for improving the sugar. Feel free to drop by the ##Espresso irc channel, or submit them at [derekr.lighthouseapp.com](http://derekr.lighthouseapp.com/projects/29033-phpsugar/overview).

## Installation

The PHP.sugar project is built in XCode. To use the latest source you must:

1. Download the source
2. Open up the .xcodeproj file
3. Build the PHP bundle

If you just want the latest release, click on the "Downloads" tab at the top of this github page.

To install:

1. If you are using the source, the compiled package will be placed in the correct `Application Support` location. Otherwise double click any PHP.sugar file and it will be placed in `~/Library/Application Support/Espresso/Sugars` (place is in this location if not automatically placed) and restart Espresso when prompted.

## Features

* Syntax Highlighting (if we're missing something, let us know)
* Codesense for built-in PHP functions, global variables, magic variables (`__FILE__`)
* Classes, control blocks, function definitions, class properties and constants all show up in the code navigator
* Support for embedded languages
    * HTML (within php strings and outside of php blocks `<?php ... ?>`)
    * SQL (within php strings)

Thanks for [Nicholas](http://conceitedsoftware.com/) the PHP.sugar now offers

* Syntax checking (will check for basic syntax errors like missing semi-colons)
* Error-Log Console (need to set path to error-log file in the TextActions.xml file; defaults to MAMP's default location)
* PHP Reference lookup (via apple, google or php.net)

Thanks for checking it out! Hope you enjoy!
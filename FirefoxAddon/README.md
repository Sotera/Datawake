# Firefox/Tor Add-on

## To make the Firefox addon (.xpi) file
1. Download and install the Firefox SDK from: https://developer.mozilla.org/en-US/Add-ons/SDK/Tutorials/Installation
2. Download OAuthorizer from: https://github.com/mozilla/oauthorizer
3. Copy "oauthorizer-develop" onto the Firefox SDK's "packages" folder.
4. Get the latest copy of Datawake-Light from github.
5. Edit the "FirefoxAddon\package.json" IPAddresses to match the Datawake server's IP (line 12,20,27,34).  Additionally, if you plan to use Google Authentication you will need to configure "useGoogleAuth" "value": 1, "googleClientId"  "value": "<your clientid>", and googleClientSecret "value": "<your secret>".
6. From the SDK directory start with "bin\activate" (Windows) or the appropriate command for your OS.  Your command prompt will now have the prefix "(..\addon-sdk)".
7. Navigate to the FirefoxAddon directory and run the command: "cfx xpi".
8. Open Firefox, Add-Ons, Extensions. Select "Install Add-on from File", browse to the FirefoxAddon directory and select the .xpi file you created.
9. You can view/edit the Datawake Options you set in the package.json file through the browser.


## Google Authentication
1. First you need to set up your native application keys on the [Google Developer Console](https://console.developers.google.com/).
2. Second you need to go to the [Add-on page](about:addons) for Firefox.
3. Check the box that says Use Google Authentication.
4. Fill in the boxes that contain your Client Secret and Client ID.
5. Open up a new tab and Google Auth should be displayed.

*(Note: This assumes you have the server set up for Google Auth as well.)*

## Notes
- If you are trying to use the add-on through Tor, your datawake plugin server must be visible to the open web or exposed as a [hidden service](https://www.torproject.org/docs/tor-hidden-service.html.en).

## Bugs
- Currently, whenever you return from the Google Auth window, your tab closes and reopens a new one.  This is due to a bug in the Firefox SDK. See: [Bug 942511](https://bugzilla.mozilla.org/show_bug.cgi?id=942511)
- This version of the extension may not work with the latest version of Firefox.  The target version is Firefox 24 due to the Tor browser.

## Permissions Explained
- Private Browsing needs to be enabled due to the Tor Browser settings.

## Google Permissions
- We only get your email and full name to authenticate.


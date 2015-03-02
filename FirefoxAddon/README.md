# Firefox/Tor Add-on

## How to make the xpi file
1. First you need to get setup with the [Firefox SDK](https://developer.mozilla.org/en-US/Add-ons/SDK/Tutorials/Installation).
2. Second you need to download [OAuthorizer](https://github.com/mozilla/oauthorizer) and put it in $SDK/packages/.
3. After you have the SDK and OAuthorizer installed, navigate to the FirefoxAddon directory and run the command: `cfx xpi` .
4. You can now open Firefox/Tor and [install the add-on manually](http://www.accessfirefox.org/Install_Addon_Manually.php).
5. Before you use the datawake, go to the add-ons and set up the preferences specifically for your instance.
6. (Optional) Set up Google Authentication.

## Google Authentication
1. First you need to set up your native application keys on the [Google Developer Console](https://console.developers.google.com/).
2. Second you need to go to the [Add-on page](about:addons) for Firefox/Tor.
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


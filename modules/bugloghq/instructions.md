INSTRUCTIONS
============
Just drop into your modules folder or use the box-cli to install

`box install bugloghq`

## Settings
You can add configuration settings to your `ColdBox.cfc` under a structure called `bugloghq`:

```js
bugloghq = {
    // The location of the listener where to send the bug reports
    "bugLogListener" : "",
    // A comma-delimited list of email addresses to which send the bug reports in case
    "bugEmailRecipients" :  "",
    // The sender address to use when sending the emails mentioned above.
    "bugEmailSender" : "",
    // The api key in use to submit the reports, empty if none.
    "apikey" : "",
    // The hostname of the server you are on, leave empty for auto calculated
    "hostname" : "",
    // The aplication name
    "appName"   : "",
    // The max dump depth
    "maxDumpDepth" : 10,
    // Write out errors to CFLog
    "writeToCFLog" : true,
    // Enable the BugLogHQ LogBox Appender Bridge
    "enableLogBoxAppender" : false
};
```
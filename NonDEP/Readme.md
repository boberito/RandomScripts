This was my way to sort of simulate DEP the best of my ability without having DEP. It will skip the setup assistant and create an admin account, then take you right to your jamf enrollment page.

This could be put into Jamf or ran as a script at the command line.

Rename the file appropriately if you want and edit the scripts to replace YOURNAME, with well Your Name.

Also you can change the location of where the PostLogin.scpt gets deployed to. Edit PostLogin.scpt to point to your JamfPro Enrollment URL

Anyway how it works, create a pkg that puts the plist in the /Library/LaunchAgents directory this way it'll get installed there once High Sierra is reinstalled.
And then put the PostLogin.scpt somewhere as well /var/ or /var/tmp/ or where ever your heart decides. The PostInstallAutoSetup script is a post install script for the pkg.
I suggest editing the PostInstall script portion of the package as the default account created is admin with the password of password.

Once you create the pkg you may want to run the productbuild to make sure it's the right kind of flat package.
productbuild --package LOCATION-OF-PACKAGE.pkg OUTPUT-PACKAGE.pkg

If you run Select Installer.sh from the command line, it will ask you to pick the location of the HS installer and the post install package.
If you run Select Installer.sh as a script connected to a policy, pass along the location of the package to be installed post installion as the first argument allowed.

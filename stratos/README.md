# Stratos application description

In order to deploy the application found in [application.json](application.json) 
in a running Stratos setup (version 4.1.0-rc2), two steps are required:

1. the Puppet modules in folder [puppet-modules](puppet-modules) must be added
to the Puppet master modules.
  1. copy the folders into e.g. /etc/puppet/modules
  2. reference them in the manifest, e.g. add /etc/puppet/manifest/ghost.pp
   
	   ```
	   node /ghost/ inherits base {
		  $docroot = "/mnt/nodejs"

		  class {'ghost':}
		  class {'nodejs':}
	   }
	   ```
	   
2. on the Stratos console web dashboard, add the configurations in the folder 
[stratos-conf](stratos-conf) accordingly to their filenames 
(e.g. cartridge-ghost.json --> add file content as a new cartridge)


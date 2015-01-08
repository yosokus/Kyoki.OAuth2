class flow {
	exec {'flow-dbupdate':
    		path => ['/usr/bin/','/bin/','/var/www/Flow'],
    		command => 'flow doctrine:update',
    		cwd => '/var/www/Flow',
    		require => Exec['flow-checkout']

    	}

	exec {'flow-clone':
		command => '/usr/bin/git clone git://git.typo3.org/Flow/Distributions/Base.git /var/www/Flow --recursive',
		creates => '/var/www/Flow',
		require => Package['git-core']
	}
	
	exec {'flow-update':
		cwd => '/var/www/Flow',
		command => '/usr/bin/git submodule foreach "git pull origin master"',
		onlyif => 'ls -l /var/www/Flow/.git'
	}
	
	exec {'flow-checkout':
		cwd => '/var/www/Flow',
		command => '/usr/bin/git checkout $flowVersionTag ',
		require => Exec['flow-clone']
	}
	
	exec {'flow-permissions':
		command => 'chown www-data:www-data -R /var/www/Flow',
		require => Exec['flow-checkout']
	
	}

	file {'/var/www/Flow/Packages/Applications':
		ensure => directory,
		require => Exec['flow-clone']
	}
	
	exec {'flow-cacheflush':
		path => ['/usr/bin/','/bin/','/var/www/Flow'],
		command => 'flow flow:cache:flush',
		cwd => '/var/www/Flow',
		require => Exec['flow-checkout']
		
	}

	mysqldb { $flowdb_name:
    		user => $flowdb_username,
    		password => $flowdb_passwd
    	}
}

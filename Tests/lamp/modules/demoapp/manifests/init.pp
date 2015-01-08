class demoapp {


	file {'/var/www/Flow/Packages/Applications/Acme.Demoapp':
	    ensure => directory,
		source => '/vagrant/Acme.Demoapp',
		recurse => true,
		owner => 'www-data',
		group => 'www-data',
		require => File['/var/www/Flow/Packages/Applications'],
		notify => [Exec['flow-dbupdate'],Exec['flow-permissions']]

	}

	exec {'demoapp-createaccount':
    		path => ['/usr/bin/','/bin/','/var/www/Flow'],
    		command => 'flow init:createaccount',
    		cwd => '/var/www/Flow',
    		require => [Exec['flow-checkout'], File['/var/www/Flow/Packages/Applications/Acme.Demoapp'],Exec['flow-dbupdate']]

    	}

    exec {'demoapp-createapi':
    		path => ['/usr/bin/','/bin/','/var/www/Flow'],
    		command => 'flow init:createclientapi',
    		cwd => '/var/www/Flow',
    		require => [Exec['flow-checkout'], File['/var/www/Flow/Packages/Applications/Acme.Demoapp'],Exec['flow-dbupdate']]

    	}
    exec {'demoapp-createscope':
    		path => ['/usr/bin/','/bin/','/var/www/Flow'],
    		command => 'flow init:createscope',
    		cwd => '/var/www/Flow',
    		require => [Exec['flow-checkout'], File['/var/www/Flow/Packages/Applications/Acme.Demoapp'],Exec['flow-dbupdate']]

    	}

    file {'/var/www/Flow/Web/client':
    	    ensure => directory,
    		source => '/vagrant/client',
    		recurse => true,
    		owner => 'www-data',
    		group => 'www-data',
    		require => Exec['flow-checkout']
    	}
}

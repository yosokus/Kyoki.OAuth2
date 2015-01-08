class oauth {


	exec {'kyoki-oauth2':
		command => '/usr/bin/git clone git://github.com/farconada/Kyoki.OAuth2.git /var/www/Flow/Packages/Applications/Kyoki.OAuth2',
		require => File['/var/www/Flow/Packages/Applications'],
		creates => '/var/www/Flow/Packages/Applications/Kyoki.OAuth2',
		notify => Exec['flow-dbupdate']

	}
	
	file {'flow-settings':
		path => '/var/www/Flow/Configuration/Settings.yaml',
		content => template('/vagrant/modules/oauth/files/Settings.erb'),
		notify => [Exec['flow-dbupdate'],Exec['flow-cacheflush']],
		require => Exec['kyoki-oauth2']
		
	}
	
	file {'/var/www/Flow/Configuration/Routes.yaml':
		ensure => present,
		source => '/vagrant/modules/oauth/files/Routes.yaml',
		require => Exec['kyoki-oauth2'],
		notify => Exec['flow-cacheflush'],
	}

}

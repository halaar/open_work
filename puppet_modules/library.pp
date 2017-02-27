class msri::library {
	file {"/home/libguest/.local":
	ensure => absent,
	force => true,
	}
	
	file { "/home/libguest/Desktop":
	ensure => directory,
	recurse => true,
	force => true,
        owner => "libguest",
        group => "members",
	mode => 0755,
        source => "puppet:///files/library/libguest/Desktop",
	}
		
	file { "/home/libguest":
	ensure => directory,
	recurse => true,
	purge => true,
	force => true,
	owner => "libguest",
	group => "members",
	mode => 0644,
	ignore => ['.gvfs', '.cache', '.local'],
	source => "puppet:///files/library/libguest",
	require => File ['/home/libguest/.local'],
	}
		
}

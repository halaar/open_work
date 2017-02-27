class msri::packages {
        exec { 'apt-update':
        command => 'apt-get -y update',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        before => Exec ['autoremove'],
        }
	
        exec { 'autoremove':
        command => 'apt-get -y autoremove',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        }

        exec { 'apt-f':
        command => 'apt-get -y -f install',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
	before => Exec ['autoremove'],
        }
	
        exec {'debconf':
        command => 'echo debconf shared/accepted-oracle-license-v1-1 select true |debconf-set-selections; echo debconf shared/accepted-oracle-license-v1-1 seen true |debconf-set-selections; echo debconf acroread-common/default-viewer seen true | debconf-set-selections',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        }


	package { 'mutt-patched':
        	ensure => installed,
		require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf']],
	}

       	package { 'subversion':
        	ensure => installed,
        	require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf']],
      	}
      
       	package { 'git-all':
        	ensure => installed,
        	require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf']],
      	}

      	package { 'acroread':
	      	ensure => installed,
		require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf']],
     	}

      	package { 'auctex':
		ensure => installed,
	        require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf']],
     	} 
	
     	package { 'compizconfig-settings-manager' :
     		ensure => installed,
                require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf']],
        }

        package { 'zsh' :
	        ensure => installed,
                require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf']],
        }

        package { 'tcsh' :
	        ensure => installed,
                require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf']],
        }

        package { 'netbeans' :
	        ensure => installed,
                require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf']],
        }

        file {'Macaulay2-1.5-common.deb':
        path => '/tmp/Macaulay2-1.5-common.deb',
        ensure => present,
        mode => 0644,
        source => 'puppet:///files/packages/Macaulay2-1.5-common.deb',
        before => Exec ['macaulay-common'],
        }

        exec {'macaulay-common':
        command => 'dpkg -i /tmp/Macaulay2-1.5-common.deb',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
	before => Exec ['macaulay2'],
        }

        file {'Macaulay2-1.5-amd64-Linux-Ubuntu-12.04.deb':
        path => '/tmp/Macaulay2-1.5-amd64-Linux-Ubuntu-12.04.deb',
        ensure => present,
        mode => 0644,
        source => 'puppet:///files/packages/Macaulay2-1.5-amd64-Linux-Ubuntu-12.04.deb',
        before => Exec ['macaulay2'],
        }

        exec {'macaulay2':
        command => 'dpkg -i /tmp/Macaulay2-1.5-amd64-Linux-Ubuntu-12.04.deb',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        }
	
        file {'sources.list':
        path => '/etc/apt/sources.list',
        ensure => present,
        mode => 0644,
        source => 'puppet:///files/packages/sources.list',
        }
	
	package {'Surfer':
	ensure => installed,
	require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf'], File ['sources.list']],

	}
	
	file {'/etc/apt/apt.conf.d/99auth':       
 	owner     => root,
 	group     => root,
 	content   => "APT::Get::AllowUnauthenticated yes;",
 	mode      => 644,
	before => Exec['apt-update'],
 	}

}

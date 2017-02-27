class msri::privileged {
#       package { 'skype':
#       ensure => installed,
#       require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf']],
#      }
#       package {'xtightvncviewer':
#       ensure => installed,
#       require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf']],
#       }
#       package {'okular':
#       ensure => installed,
#       require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf']],
#       }

        file {'sources.list':
        path => '/etc/apt/sources.list',
        ensure => present,
        mode => 0644,
        source => 'puppet:///files/packages/sources.list',
        }

        exec { 'apt-update':
        command => 'apt-get -y update',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
	require =>  File ['sources.list'],
        }

	
        exec { 'autoremove':
        command => 'apt-get -y autoremove',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        }

	package {'texlive-full':
       	ensure => latest,
        require => [Exec['apt-update'], Exec['autoremove']],
       	}
	package {'texmaker':
       	ensure => latest,
        require => [Exec['apt-update'], Exec['autoremove']],
	}
	package {'firefox':
       	ensure => latest,
        require => [Exec['apt-update'], Exec['autoremove']],
	}
	package {'acroread':
       	ensure => latest,
        require => [Exec['apt-update'], Exec['autoremove']],
	}
}

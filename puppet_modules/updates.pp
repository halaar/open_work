class msri::updates {

#         file {'webupd8team-java-precise.list':
#         path => '/etc/apt/sources.list.d/webupd8team-java-precise.list',
#         ensure => present,
#         mode => 0644,
#         source => 'puppet:///files/packages/webupd8team-java-precise.list',
#        }

#	file {'Macaulay2-1.5-common.deb':
#	path => '/tmp/Macaulay2-1.5-common.deb',
#	ensure => present,
#	mode => 0644,
#	source => 'puppet:///files/packages/Macaulay2-1.5-common.deb',
#	before => Exec ['macaulay'],
#	}
#	exec {'macaulay':
#	command => 'dpkg -i /tmp/Macaulay2-1.5-common.deb',
#	path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
#	before => Exec ['dist-upgrade'],
# 	}
	package { 'openjdk-7-jre':
	ensure => purged,
	before => Exec ['install-java'],
 	}
	package { 'openjdk-6-jre':
        ensure => purged,
	before => Exec ['install-java'],
        }

   	package { 'openjdk-6-plugin':
        ensure => purged,
	before => Exec ['install-java'],
        }
	package { 'icedtea-6-plugin':
        ensure => purged,
	before => Exec ['install-java'],
        }
	package { 'openjdk-6-jdk':
        ensure => purged,
	before => Exec ['install-java'],
        }
	package { 'openjdk-7-jdk':
        ensure => purged,
	before => Exec ['install-java'],
        }
	package { 'icedtea-7-plugin':
        ensure => purged,
	before => Exec ['install-java'],
        }
	
#	exec { 'autoremove':
#	command => 'apt-get -y autoremove',
#	path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
#        before => Exec ['dist-upgrade'],
#	}

#        exec { 'apt-update':
#        command => 'apt-get -y update',
#        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
#        before => [Exec ['install-java'], Exec ['autoremove'], Exec ['dist-upgrade']],
#        }
	
	exec { 'add-apt':
        command => 'add-apt-repository -y ppa:webupd8team/java',
        path => '/usr/bin',
	before => [Exec ['install-java'], Exec['apt-update'], Exec ['dist-upgrade']],
        }

	exec { 'install-java':
	command => 'apt-get -y --force-yes install oracle-java7-installer',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        require => [Exec['apt-update'], Exec['autoremove'], Exec ['debconf']],
        before => Exec ['dist-upgrade'],
	}
	
       
#        exec {'debconf':
#        command => 'echo debconf shared/accepted-oracle-license-v1-1 select true |debconf-set-selections; echo debconf shared/accepted-oracle-license-v1-1 seen true |debconf-set-selections; echo debconf acroread-common/default-viewer seen true | debconf-set-selections',
#        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
#        before => Exec ['dist-upgrade'],
#        }
       
        exec {'dist-upgrade':
        command => 'apt-get -y dist-upgrade',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
	timeout => 0,
	require => [Exec [apt-update], Exec [debconf], Exec [autoremove]],
        }


#        package {'oracle-java7-installer':
#	ensure => installed,
#	require => [Exec['apt-update'], Exec['autoremove']],
#	}
	
       exec { '/usr/msri/hostnameset.sh':
       command => '/usr/msri/hostnameset.sh',
       path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
       }

}

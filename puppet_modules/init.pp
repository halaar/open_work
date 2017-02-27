class msri {
        file {'printers.conf':
         path => '/etc/cups/printers.conf',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/printers.conf',
        }
        file {'fstab':
         path => '/etc/fstab',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/fstab',
        }
	exec  { 'mount':
        command => 'mount -a',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
	subscribe => File ['fstab'],
        }
	
	exec { 'mkdir':
	command => 'mkdir -p /auto/www0/web_space',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
	subscribe => File ['fstab'],
	before => Exec ['mount'],
	}
	 file {'BashCommon':
         path => '/usr/local/Setup/BashCommon',
         ensure => present,
         mode => 0755,
         source => 'puppet:///files/BashCommon',
        }
         file {'puppet.conf':
         path => '/etc/puppet/puppet.conf',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/puppet/puppet.conf',
        }
       package { 'apache2':
       ensure => absent,
      }
	 file {'nsswitch.conf':
         path => '/etc/nsswitch.conf',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/nsswitch.conf',
        }
	 file {'idmapd.conf':
         path => '/etc/idmapd.conf',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/idmapd.conf',
        }

}


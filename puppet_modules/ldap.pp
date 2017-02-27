class msri::ldap {
         file {'common-password':
         path => '/etc/pam.d/common-password',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/common-password',
        }
         file {'ldap.conf':
         path => '/etc/ldap.conf',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/ldap/ldap.conf',
        }
         file {'ldap.secret':
         path => '/etc/ldap.secret',
         ensure => present,
         mode => 0600,
         source => 'puppet:///files/ldap/ldap.secret',
        }
         file {'nscd.conf':
         path => '/etc/nscd.conf',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/ldap/nscd.conf',
        }

}

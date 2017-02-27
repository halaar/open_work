class  msri::gnome {
         file {'maple17.desktop':
         path => '/usr/share/applications/maple17.desktop',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/gnome/maple17.desktop',
        }
         file {'maple16.desktop':
         path => '/usr/share/applications/maple16.desktop',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/gnome/maple16.desktop',
        }
         file {'applications.menu':
         path => '/etc/xdg/menus/applications.menu',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/gnome/applications.menu',
        }
        file {'alacarte-made-5.desktop':
         path => '/usr/share/applications/alacarte-made-5.desktop',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/gnome/alacarte-made-5.desktop',
        }
	file {'magma.desktop':
         path => '/usr/share/applications/magma.desktop',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/gnome/magma.desktop',
        }
        file {'mathematica.desktop':
         path => '/usr/share/applications/mathematica.desktop',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/gnome/mathematica.desktop',
        }

        file {'firefox.desktop':
         path => '/usr/share/applications/firefox.desktop',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/gnome/firefox.desktop',
        }

        file {'xsession.desktop':
         path => '/usr/share/xsessions/xsession.desktop',
         ensure => present,
         mode => 0644,
         source => 'puppet:///files/gnome/xsession.desktop',
        }

}

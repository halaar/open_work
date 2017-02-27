
#!/bin/sh

###
#
#            Name:  mathematica.pp
#     Description:  This is the starting class for mathematica.
#          Author:  Aaron Hale <ahale@msri.org>>
#         Created:  2016-02-26
#   Last Modified:  2016-02-26
#         Version:  1.0
#
###




class mathematica {

    $target_dir = "/opt/Wolfram/Mathematica/10.0"
    $mma_installer = "Mathematica_9.0.1_LINUX.sh"
    $version = "10.0"

    file { $mma_installer:
        ensure  => file,
        path    => "/tmp/$mma_installer",
        owner   => 'root',
        group   => 'root',
        mode    => 0755,
        source  => "puppet:///files/$mma_installer",
        links   => follow,
    }

    exec { "install Mathematica to $target_dir":
        path    => [ "/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/", "/usr/local/bin/", "/usr/local/sbin/" ],
        command => "/tmp/$mma_installer --nox11 -- -auto -targetdir=$target_dir",
        require => File[$mma_installer],
        unless  => "grep $version /opt/Wolfram/Mathematica/*/.VersionID 2>/dev/null",
    }
}

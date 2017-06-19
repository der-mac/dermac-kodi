# == Class: kodi::params
#
# This is the install-class to install the kodi-application
#
# === Parameters
#
# See the init-class.
#
# === Variables
#
# === Examples
#
# === Authors
#
# Martin Schneider <martin@dermac.de>
#
# === Copyright
#
# Copyright 2017 Martin Schneider
#
class kodi::install inherits kodi {

  case $::os['name'] {
    'windows': {
      case $::os['release']['full'] {
        '7', '10': {
          # Check installed version against package-version
          if (versioncmp($kodi::package_version, String($::kodi_installed_version)) > 0) or ($::kodi_installed_version == '') {
            notify{"${kodi::package_name} :: Version is older, installing Software from ${kodi::download_link}": }

            # Downlaod install-file
            download_file { "${kodi::download_dir}\\${kodi::destination_file}":
              url                   => $kodi::download_link,
              destination_directory => $kodi::download_dir,
              destination_file      => $kodi::destination_file,
              proxy_address         => $kodi::proxy_address,
              proxy_user            => $kodi::proxy_user,
              proxy_password        => $kodi::proxy_password,
              is_password_secure    => $kodi::is_password_secure
            }

            # Install exe-file
            package { $kodi::package_name:
              ensure          => $kodi::package_ensure,
              source          => "${kodi::download_dir}\\${kodi::destination_file}",
              install_options => [ '/S' ],
              require         => Download_file["${kodi::download_dir}\\${kodi::destination_file}"],
            }
          }
          else {
            # If cleanup true, delete the install-file
            if ( $kodi::download_cleanup ) {
              file { "${kodi::download_dir}\\${kodi::destination_file}":
                ensure => absent,
              }
            }
          }
        }
        default: {
          fail("The ${module_name} module is not supported on Windows Version ${::operatingsystemmajrelease} based system.")
        }
      }
    }
    'Fedora': {
      case $::os['release']['full'] {
        '25': {
          # Check installed version against package-version
          if (versioncmp($kodi::package_version, Strin($::kodi_installed_version)) > 0) or ($::kodi_installed_version == '') {
            notify{"${kodi::package_name} :: Version is older, installing Software from ${kodi::download_link}": }

            # Download the rpmfusion-repo
            include wget
            wget::fetch { "${kodi::download_dir}/${kodi::destination_file}":
              source             => $kodi::download_link,
              destination        => "${kodi::download_dir}/",
              timeout            => 0,
              nocheckcertificate => true,
              redownload         => true,
              verbose            => true,
            }

            # Install the rpmfusion-repo
            package { "${kodi::download_dir}/${kodi::destination_file}":
              ensure  => $kodi::package_ensure,
              require => Wget::Fetch["${kodi::download_dir}/${kodi::destination_file}"],
            }

            # Install the package from the new repository
            package { $kodi::package_name:
              ensure  => $kodi::package_ensure,
              require => Package["${kodi::download_dir}/${kodi::destination_file}"],
            }
          }
          else {
            # If cleanup true, delete the install-file
            if ( $kodi::download_cleanup ) {
              file { "${kodi::download_dir}\\${kodi::destination_file}":
                ensure => absent,
              }
            }
          }
        }
        default: {
          fail("The ${module_name} module is not supported on  Version ${::operatingsystemmajrelease} based system.")
        }
      }
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}

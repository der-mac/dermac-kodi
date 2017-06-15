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

  case $::osfamily {
    'windows': {
      case $::operatingsystemmajrelease {
        '7', '10': {
          # Installierte Version muss kleiner sein
          if (versioncmp($kodi::package_version, String($::kodi_installed_version)) > 0) or ($::kodi_installed_version == '') {
            notify{"${kodi::package_name} :: Version is older, installing Software from ${kodi::download_link}": }

            # Installationsdatei herunterladen
            download_file { "${kodi::download_dir}\\${kodi::destination_file}":
              url                   => $kodi::download_link,
              destination_directory => $kodi::download_dir,
              destination_file      => $kodi::destination_file,
              proxy_address         => $kodi::proxy_address,
              proxy_user            => $kodi::proxy_user,
              proxy_password        => $kodi::proxy_password,
              is_password_secure    => $kodi::is_password_secure
            }

            # Heruntergeladene Datei installieren
            package { $kodi::package_name:
              ensure          => $kodi::package_ensure,
              source          => "${kodi::download_dir}\\${kodi::destination_file}",
              install_options => [ '/S' ],
              require         => Download_file["${kodi::download_dir}\\${kodi::destination_file}"]
            }
          }
          else {
            # Wenn Cleanup true, dann heruntergeladene Downloaddatei loeschen
            if ( $kodi::default_download_cleanup ) {
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
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}

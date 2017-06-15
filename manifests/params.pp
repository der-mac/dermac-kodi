# == Class: kodi::params
#
# This is the paramter-class to configure the kodi-module
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
class kodi::params {

  $default_package_ensure     = 'present'
  $default_package_version    = '17.3'
  $default_package_name       = ['kodi-17.3-Krypton.exe']
  $default_install_dir        = 'C:\Program Files (x86)\Kodi'
  $default_download_link      = 'http://mirrors.kodi.tv/releases/win32/kodi-17.3-Krypton.exe'
  $default_download_dir       = $::kodi_curr_temp_dir
  $default_download_cleanup   = true
  $default_destination_file   = 'kodi-latest.exe'
  $default_proxy_address      = ''
  $default_proxy_user         = ''
  $default_proxy_password     = ''
  $default_is_password_secure = false


  case $::osfamily {
    'windows': {
      case $::operatingsystemmajrelease {
        '7', '10': {
          $package_version  = $default_package_version
          $package_name     = $default_package_name
          $download_link    = $default_download_link
          $install_dir      = $default_install_dir
          $download_dir     = $default_download_dir
          $destination_file = $default_destination_file
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

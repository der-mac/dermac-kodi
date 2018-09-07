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

  $package_ensure     = 'present'
  $download_dir       = $::kodi_curr_temp_dir
  $download_cleanup   = true
  $proxy_address      = ''
  $proxy_user         = ''
  $proxy_password     = ''
  $is_password_secure = false

  $default_package_version    = '17.3'
  $default_package_name       = ['kodi-17.3-Krypton.exe']
  $default_download_link      = 'http://mirrors.kodi.tv/releases/win32/kodi-17.3-Krypton.exe'
  $default_install_dir        = 'C:\Program Files (x86)\Kodi'
  $default_destination_file   = 'kodi-latest.exe'

  case $::os['name'] {
    'windows': {
      case $::os['release']['full'] {
        '7', '10': {
          $package_version  = $default_package_version
          $package_name     = $default_package_name
          $download_link    = $default_download_link
          $install_dir      = $default_install_dir
          $destination_file = $default_destination_file
        }
        default: {
          fail("The ${module_name} module is not supported on Windows Version ${::os['release']['full']} based system.")
        }
      }
    }
    'Fedora': {
      case $::os['release']['full'] {
        '25': {
          $package_version  = $default_package_version
          $package_name     = ['kodi']
          $download_link    = 'http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-25.noarch.rpm'
          $destination_file = 'rpmfusion-free-release-25.noarch.rpm'
          $install_dir      = '/bin/'
        }
        default: {
          fail("The ${module_name} module is not supported on Fedora Version ${::os['release']['full']} based system.")
        }
      }
    }
    'Ubuntu': {
      case $::os['release']['full'] {
        '18.04': {
          $package_version  = $default_package_version
          $package_name     = ['kodi']
          $download_link    = ''
          $destination_file = '',
          $install_dir      = '/bin/'
        }
        default: {
          fail("The ${module_name} module is not supported on Fedora Version ${::os['release']['full']} based system.")
        }
      }
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::os['name']} based system.")
    }
  }
}

# == Class: kodi
#
# Install and configure the kodi-mediaplayer-application (https://kodi.tv).
#
# === Parameters
#
# [*package_ensure*]
#   Install or remove package
# [*$package_name*]
#   Name of the package in the operatingsystem
# [*$package_version*]
#   Kodi-version, which should be present on the system 
# [*$download_link*]
#   Downloadlink for the kodi-version, which should be present on the system
# [*$install_dir*]
#   Install-directory for kodi (please do not change)
# [*$download_dir*]
#   Download-directory for the kodi-install-file
# [*$destination_file*]
#   Name of the downloaded kodi-install-file
# [*$download_cleanup*]
#   Remove the kodi-install-file once the installed version is the one
#   that should be installed
# [*$proxy_address*]
#   Proxy-server for the downlaod of the kodi-install-file
#   Have a look in the download_module doku
# [*$proxy_user*]
#   Proxy-user for the downlaod of the kodi-install-file
#   Have a look in the download_module doku
# [*$proxy_password*]
#   Proxy-passwort for the downlaod of the kodi-install-file
#   Have a look in the download_module doku
# [*$is_password_secure*]
#   Switch to change the way that proxyPassword is interpreted from secure string to plaintext
#   Have a look in the download_module doku
#
# === Variables
#
# === Examples
#
#  class { 'kodi': }
#
# === Authors
#
# Martin Schneider <martin@dermac.de>
#
# === Copyright
#
# Copyright 2017 Martin Schneider
#
class kodi (
  $package_ensure     = $kodi::params::package_ensure,
  $package_name       = $kodi::params::package_name,
  $package_version    = $kodi::params::package_version,
  $install_dir        = $kodi::params::install_dir,
  $download_link      = $kodi::params::download_link,
  $download_dir       = $kodi::params::download_dir,
  $download_cleanup   = $kodi::params::download_cleanup,
  $destination_file   = $kodi::params::destination_file,
  $proxy_address      = $kodi::params::proxy_address,
  $proxy_user         = $kodi::params::proxy_user,
  $proxy_password     = $kodi::params::proxy_password,
  $is_password_secure = $kodi::params::is_password_secure,

) inherits kodi::params {

  validate_array($package_name)
  validate_string($package_version)
  validate_absolute_path($install_dir)
  validate_string($download_link)
  validate_absolute_path($download_dir)
  validate_bool($download_cleanup)
  validate_string($destination_file)
  validate_string($proxy_address)
  validate_string($proxy_user)
  validate_string($proxy_password)
  validate_bool($is_password_secure)


  anchor { 'kodi::begin': }
  -> class { '::kodi::install': }
  -> class { '::kodi::config': }
  anchor { 'kodi::end': }

}

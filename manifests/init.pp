# == Class: zookeeper
#
# Full description of class zookeeper here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { zookeeper:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class zookeeper(
	$data_dir        = $zookeeper::params::data_dir,
	$zookeeper_nodes = [$::ipaddress],
	$init_style      = sysv,
	$java_xmx        = undef,
	$java_xmn        = undef,
	$java_xms        = undef,
	$java_opts       = undef,
) inherits zookeeper::params {
	include java

	class {zookeeper::install: }

	user{$user:
		ensure => present, 
		system => true
	}

	file{$conf_dir: ensure => directory, mode => 644}
	file{"${conf_dir}/zookeeper-env.sh":
		mode => 644,
		content => template("zookeeper/zookeeper-env.sh.erb"),
		notify => Service[zookeeper]
	}
	file{"${conf_dir}/log4j.properties":
		mode => 644,
		content => template("zookeeper/log4j.properties.erb"),
		notify => Service[zookeeper]
	}

	file{[$log_dir, $data_dir]: 
		ensure => directory,
		mode => 644,
		owner => $user,
		require => User[$user],
	}
	file{"${conf_dir}/zoo.cfg":
		content => template("zookeeper/zoo.cfg.erb"),
		mode => 644,
		notify => Service[zookeeper]
	}
	->
	file{"/opt/zookeeper/current/conf/zoo.cfg": 
		ensure => link,
		target => "${conf_dir}/zoo.cfg",
		before => Service[zookeeper]
	}

	class {zookeeper::service: 
		init_style => $init_style, 
		require => [File[$data_dir], File[$log_dir]]
	}
}

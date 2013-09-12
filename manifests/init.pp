# == Class: zookeeper
#
# === Examples
#
#  class { zookeeper:
#    zookeeper_nodes => ["zk1", "zk2", "zk3"]
#  }
#
# === Authors
#
# Avishai Ish-Shalom <avishai@fewbytes.com>
#
# === Copyright
#
# Copyright 2013 Fewbytes
#
class zookeeper(
	$data_dir        = $zookeeper::params::data_dir,
	$data_log_dir    = undef,
	$zookeeper_nodes = [$::ipaddress],
	$init_style      = sysv,
	$java_xmx        = undef,
	$java_xmn        = undef,
	$java_xms        = undef,
	$java_opts       = undef,
) inherits zookeeper::params {

	$zk_id = inline_template("<%= @zookeeper_nodes.find_index{|n| [scope.lookupvar('fqdn'), scope.lookupvar('ipaddress'), scope.lookupvar('hostname')].include? n } %>")
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
	file{"${data_dir}/myid":
		content => "${zk_id}",
		mode => 644,
		notify => Service[zookeeper]
	}
	class {zookeeper::service: 
		init_style => $init_style, 
		require => [File[$data_dir], File[$log_dir], Class["java"]]
	}
}

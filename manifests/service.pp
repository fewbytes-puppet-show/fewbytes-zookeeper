class zookeeper::service(
	$init_style = $zookeeper::params::init_style
) inherits zookeeper::params {
	case $init_style {
		"upstart": {
			upstart::service{zookeeper:
				exec => "bin/zkServer.sh start-foreground",
				user => $zookeeper::params::user,
				chdir => "/opt/zookeeper/current",
				env => {"ZOOCFGDIR" => $conf_dir}
			}
		}
		"sysv": {
			file{"/etc/init.d/zookeeper":
				ensure => present,
				mode => 755,
				content => template("zookeeper/init.sh.erb")
			} ->
			service{"zookeeper": ensure => running, enable => true}
		}
		"runit": {

		}
	}
	
}
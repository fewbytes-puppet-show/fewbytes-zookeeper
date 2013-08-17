This is the zookeeper Puppet module.

# Using

Install zookeeper using the zookeeper class:

	class{zookeeper: }

If you are on a platform that supports upstart, you can use it:

	class{zookeeper: init_sytle => upstart }

If you are running a cluster, you should provide `zookeeper_nodes` - an array of hostnames/ip addresses:

	class{zookeeper: zookeeper_nodes => ["zk1", "zk2", "zk3"]} 


## zookeeper class parameters
- `init_style` - _upstart_, _sysv_ are supported, _runit_ and _systemd_ will be supported eventually. Default is _sysv_
- `data_dir` - zookeeper data dir. Defaults to `/var/lib/zookeeper`
- `data_log_dir` - transaction logs directory. defaults to undef which means transaction logs will be saved in `data_dir`
- `java_xmx` - max heap size java parameter
- `java_xms` - initial heap size java parameter
- `java_xmn` - young generation size java parameter
- `java_opts` - additional/misc java parameters

License
-------
Apache V2

Support
-------

Please log tickets and issues at our [Projects site](https://github.com/fewbytes-puppet-show/fewbytes-zookeeper)

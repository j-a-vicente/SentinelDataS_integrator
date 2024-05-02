SELECT name 
     , setting
     , unit
	 , category
FROM pg_settings
WHERE name IN('autovacuum','archive_mode','config_file','data_directory','effective_cache_size',
			  'force_parallel_mode','hba_file','lc_collate','listen_addresses','log_truncate_on_rotation','log_filename','log_directory'
			  'max_connections','max_parallel_workers','max_wal_size','server_encoding','server_version',
			  'server_version_num','shared_buffers','temp_buffers','TimeZone','work_mem','maintenance_work_mem','port',
			 'unix_socket_directories')
ORDER BY category	 
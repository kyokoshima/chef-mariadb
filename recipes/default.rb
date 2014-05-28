#
# Cookbook Name:: mariadb
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


template "/etc/yum.repos.d/MariaDB.repo" do
	source "MariaDB.repo.erb"

	variables({
		:version => node['mariadb']['version'],
		:dist => "#{node['platform']}#{node['platform_version'].to_i}",
		:arch => node[:kernel][:machine].end_with?('64') ? "amd64" : "x86"
	})
	not_if { File.exist? path }
end

%w[MariaDB-server MariaDB-devel].each do |pkg|
	package pkg do
		subscribes :install, resources("template[/etc/yum.repos.d/MariaDB.repo]")
	end
end
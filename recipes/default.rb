include_recipe 'zfs' if platform_family?('gentoo')

package 'hdparm'
package 'smartmontools'

[node[:zfs_pools]].flatten.compact.each do |zfs_pool|
  %w[setup mount].each do |script_type|
    template "/.zfs_pool_#{script_type}-#{zfs_pool[:name]}.sh" do
      source "zfs_pool_#{script_type}.sh.erb"
      owner 'root'
      mode '0000'
      variables(zfs_pool)
    end
  end
end

execute "sed -i 's_#!/sbin/runscript_#!/sbin/openrc-run_' /etc/init.d/zfs*"

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

template '/.move_gentoo_changing_files_to_imported_zfs.sh' do
  source 'move_gentoo_changing_files_to_imported_zfs.sh.erb'
  owner 'root'
  mode '0000'
end

execute "sed -i 's_#!/sbin/runscript_#!/sbin/openrc-run_' /etc/init.d/zfs*"

# Ensure that all mountpoints are in mounted
# This ensures that any other operation requiring mountpoints will have proper storage
#
# Enabled by default and can be disabled by setting
if node[:zfs_pools_require_mountpoints_mounted]
  [node[:zfs_pools]].flatten.compact.each do |zfs_pool|
    execute "mount | grep -q ' on #{zfs_pool[:mountpoint]} type zfs '"

    subresource_mountpoints = zfs_pool[:sub_resources].values.flatten.map do |sub_resource_entire|
      sub_resource_entire[:mountpoint]
    end

    subresource_mountpoints.each do |sub_resource_mountpoint|
      execute "mount | grep -q ' on #{sub_resource_mountpoint} type zfs '"
    end
  end
end

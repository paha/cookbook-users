#
# Cookbook Name:: users
# Definitions File:: users.rb
#

define :users_add, :enable => true do
  
  # needed to manage passwords
  case node['platform']
  when "ubuntu"
    package "libshadow-ruby1.8"
  when "amazon"
    gem_package "ruby-shadow"
  else
    package "ruby-shadow"
  end
  
  search( :users, "groups:#{params[:name]}" ).sort_by {|u| u[:uid] }.each do |user|
    
    Chef::Log.debug("Adding #{user[:name]} with user id - #{user[:id]}")
    
    homedir = user[ :homedir ] || "/home/#{user[:id]}"
    
    user user[:id] do
      comment  user[:name]
      uid      user[:uid]
      shell    user[:shell] || "/bin/bash"
      password user[:password] if user[:password]
      home     homedir
      supports :manage_home => true
    end 
    
    directory homedir + "/.ssh" do
      owner user[:id]
      group user[:id]
      mode  0700
    end 

    template homedir + "/.ssh/authorized_keys" do
      owner user[:id]
      group user[:id]
      mode  0600
      variables( :keys => user[:ssh_keys] )
    end
    
    # add bashrc file if defined in the data-bag
    if user[:bashrc]
      remote_file "#{homedir}/.bashrc" do
        source    user[:bashrc]
        checksum  user[:checksum_bashrc]
      end
    end
  end
  
  # Manage the group
  g = data_bag_item('groups',"#{params[:name]}" )
  if params[:enable]
    Chef::Log.debug("Adding group #{g[:id]}")
    group g["id"] do
      gid     g["gid"]
      members g["members"]
      action  [:create, :manage]
    end
  else
    group(g["id"]) {action :remove}
  end
  
end

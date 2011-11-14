#
# Cookbook Name:: users
# Recipe:: default
#

node["accounts"]["groups"].each do |group|
  users_add group do 
    enable true
  end
end

#
# Cookbook Name:: railsbox
# Recipe:: github-deploys
# using the Github API to authorise the new public key
# from https://github.com/riceo/github-deploys/blob/master/libraries/GithubAPI.rb
#
# Copyright (C) 2013 zhiping Limited
# 


path_to_key = "/home/#{node[:github_deploys][:deploy_user]}/.ssh/id_rsa"


ruby_block "upload_key_to_github" do
	block do

		class Chef::Resource::RubyBlock
		  include GithubAPI
		end

		upload_key(
			node[:github_deploys][:github_api][:email],
			node[:github_deploys][:github_api][:password],
			node[:fqdn],
			"#{path_to_key}.pub")
	end
end

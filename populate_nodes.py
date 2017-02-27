#!/usr/bin/env python

'''

             Name:  nodes.py
      Description:  Fills in nodes on the site.pp from the members_endpoint output from Aarons script 
           Author:  Aldo Mendez
          Created:  2016-03-16
    Last Modified:  2016-03-16
          Version:  1.0

'''
node_declaration = lambda x: "node '" + x + "'{\n\n}\n\n"
nodes = []

with open("members_endpoints.txt") as f:
	endpoints = f.readlines()

for endpoint in endpoints:
		endpoint = endpoint[0:len(endpoint) - 1] #removes \n from every endpoint
		nodes.append(node_declaration(endpoint)) 

with open("/etc/puppet/manifests/site.pp","a") as f:
	f.writelines(nodes)
	f.close()

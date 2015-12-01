require 'savon'

client = Savon.client(wsdl: 'http://ws.tramtracker.com.au/pidsservice/pids.asmx?WSDL')

#puts client.operations
# => [:find_user, :list_users]

# call the 'findUser' operation
#response = client.call(:find_user, message: { id: 42 })

response = client.call(:get_main_routes)
puts response.body

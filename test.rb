require 'savon'

#Savon.client(soap_header: { "Token" => "secret" })

client = Savon.client(
	wsdl: 'http://ws.tramtracker.com.au/pidsservice/pids.asmx?WSDL',
	soap_header: { "PidsClientHeader" => 
			{ 
			  "@xmlns" => "http://www.yarratrams.com.au/pidsservice/",
			  "ClientGuid" => "ad076fbe-993d-4baa-819a-e25b93f673b3",
			  "ClientType" => "WEBPID",
			  "ClientVersion" => "0.02",
			  "ClientWebServiceVersion" => "6.4.0.0",
			}
		},
)


#client = Savon.client do
#  endpoint "http://ws.tramtracker.com.au/pidsservice/pids.asmx"
#  namespace "http://www.yarratrams.com.au/pidsservice/"
#end
#puts client.operations
# => [:find_user, :list_users]

# call the 'findUser' operation
#response = client.call(:find_user, message: { id: 42 })

#client.call(:authenticate, :soap_header => header)

response = client.call(:get_main_routes)
puts response.body


#pids = Pids.new()
#pids.get_main_routes
#pids.route(1).stop(1).next_arrival

#require "pids/version"
require 'savon'
require 'pids/route'

#module Pids

  class Pids
    attr_accessor :client_guid, :client_type, :client_version, :client_webservice_version

    def initialise( params = {})
      @client_guid = params[:client_guid] || get_client_guid
      @client_type = params[:client_type] || 'WEBPID'
      @client_version = params[:client_version] || Gem.loaded_specs["activesupport"].version
      @client_webservice_version = params[:client_webservice_version] || '6.4.0.0'
    end

    def client 
      Savon.client(
      	wsdl: 'http://ws.tramtracker.com.au/pidsservice/pids.asmx?WSDL',
      	soap_header: { 
          "PidsClientHeader" =>  {   
            "@xmlns"				=> "http://www.yarratrams.com.au/pidsservice/",
            "ClientGuid"			=> get_client_guid(),
            #"ClientGuid"			=> "ad076fbe-993d-4baa-819a-e25b93f673b3",
            "ClientType"			=> "WEBPID",
            "ClientVersion"			=> "0.02",
            "ClientWebServiceVersion"	=> "6.4.0.0",
          }
        },
      )
    end

    def get_main_routes
      response = client.call(:get_main_routes)
      routes = response.body[:get_main_routes_response][:get_main_routes_result][:diffgram][:document_element][:list_of_non_sub_routes]
      puts routes
      #puts response.body
    end
      
    def get_client_guid
      "ad076fbe-993d-4baa-819a-e25b93f673b3"
    end
  end
      
#end

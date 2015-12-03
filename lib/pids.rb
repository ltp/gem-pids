require "pids/version"
#require "pids/route"
require 'savon'
#require 'pids/route'

module Pids

  class Client
    attr_accessor :client_guid, :client_type, :client_version, :client_webservice_version, :routes

    def initialize( params = {})
      @client_guid = params[:client_guid] || get_client_guid
      @client_type = params[:client_type] || 'WEBPID'
      @client_version = params[:client_version] || '0.0.1'
      @client_webservice_version = params[:client_webservice_version] || '6.4.0.0'
      @routes = []

      @client = Savon.client(
        wsdl: 'http://ws.tramtracker.com.au/pidsservice/pids.asmx?WSDL',
        soap_header: {
          "PidsClientHeader" =>  {   
            "@xmlns"                  => "http://www.yarratrams.com.au/pidsservice/",
            "ClientGuid"              => @client_guid,
            "ClientType"              => @client_type,
            "ClientVersion"           => @client_version,
            "ClientWebServiceVersion" => @client_webservice_version,
          }
        },
      )
    end

    def get_main_routes
      response = @client.call(:get_main_routes)
      routes = response.body[:get_main_routes_response][:get_main_routes_result][:diffgram][:document_element][:list_of_non_sub_routes]
      routes.each do |route|
        @routes.push(route[:route_no])
      end

      @routes
    end

    def get_destinations_for_all_routes
      @client.call(:get_destinations_for_all_routes)
    end
      
    def get_client_guid
      client = Savon.client(
      	wsdl: 'http://ws.tramtracker.com.au/pidsservice/pids.asmx?WSDL',
      	soap_header: { 
          "PidsClientHeader" =>  {   
            "@xmlns"                  => "http://www.yarratrams.com.au/pidsservice/",
            "ClientType"              => @client_type,
            "ClientVersion"           => @client_version,
            "ClientWebServiceVersion" => @client_webservice_version,
          }
        },
      )
      client.call(:get_new_client_guid).body[:get_new_client_guid_response][:get_new_client_guid_result]
    end
  end
      
end

#get_next_predicted_routes_collection
#get_schedules_collection
#get_schedules_for_trip
#get_next_predicted_arrival_time_at_stops_for_tram_no
#get_destinations_for_all_routes
#get_stop_information
#get_main_routes_for_stop
#get_main_routes
#get_route_summaries
#get_destinations_for_route
#get_list_of_stops_by_route_no_and_direction
#get_platform_stops_by_route_and_direction
#get_route_stops_by_route
#get_stops_and_routes_updates_since
#get_new_client_guid

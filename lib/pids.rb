require "pids/version"
require "pids/route"
require 'savon'
require 'pids/destination'

module Pids

  class Client
    attr_accessor :client_guid,
                  :client_type,
                  :client_version,
                  :client_webservice_version,
                  :route_numbers,
                  :routes

    def initialize( params = {})
      @client_guid = params[:client_guid] || get_client_guid
      @client_type = params[:client_type] || 'WEBPID'
      @client_version = params[:client_version] || '0.0.1'
      @client_webservice_version = params[:client_webservice_version] || '6.4.0.0'
      @routes = []
      @route_numbers = []
      @destinations = []

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

    # This method is needed because all other API methods require a GUID
    # So we have this one off method that does not require a GUID to get a GUID.
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
      client.call(:get_new_client_guid).
        body[:get_new_client_guid_response][:get_new_client_guid_result]
    end

    def get_main_routes
      response = @client.call(:get_main_routes)
      routes = response.body[:get_main_routes_response]\
                            [:get_main_routes_result]\
                            [:diffgram]\
                            [:document_element]\
                            [:list_of_non_sub_routes]

      routes.each do |route|
        @route_numbers.push(route[:route_no])
      end

      @route_numbers
    end

    def get_destinations_for_all_routes
      @client.call(:get_destinations_for_all_routes)
        .body[:get_destinations_for_all_routes_response]\
             [:get_destinations_for_all_routes_result]\
             [:diffgram]\
             [:document_element]\
             [:list_of_destinations_for_all_routes]
        .each do |dest|
          @destinations.push(Pids::Destination.new(
                                               dest[:route_no],
                                               dest[:up_stop],
                                               dest[:destination] 
                                             ))
        end

      @destinations
    end

    #methods = 

    ['get_route_summaries'].each do |m|
      define_method m do
      @client.call(m.to_sym)
      .body["#{m}_response".to_sym]["#{m}_result".to_sym][:diffgram][:document_element][:route_summaries]
      end
    end

    def __get_route_summaries
      @client.call(:get_route_summaries)
        .body[:get_route_summaries_response]\
             [:get_route_summaries_result]\
             [:diffgram]\
             [:document_element]\
             [:route_summaries]
        .each do |route|
          @routes.push(Pids::Route.new(route[:route_no], route[:headboard_route_no]))
        end

      @routes
    end

    def get_stop_information(stop_id)
      response = @client.call(:get_stop_information)
    end

    def get_list_of_stops_by_route_no_and_direction
      response = @client.call(:get_list_of_stops_by_route_no_and_direction).body
      response
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

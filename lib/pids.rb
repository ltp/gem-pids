require "pids/version"
require "pids/route"
require "pids/route_summary"
require 'savon'
require 'pids/destination'
require 'pids/listed_stop'
require 'pids/route_destination'
require 'pids/predicted_arrival_time_data'
require 'pids/predicted_stop_detail'

module Pids

  class Client
    attr_accessor :client_guid,
                  :client_type,
                  :client_version,
                  :client_webservice_version,
                  :route_numbers,
                  :route_summaries

    def initialize( params = {})
      @client_guid = params[:client_guid] || get_client_guid
      @client_type = params[:client_type] || 'WEBPID'
      @client_version = params[:client_version] || '0.0.1'
      @client_webservice_version = params[:client_webservice_version] || '6.4.0.0'
      @route_summaries = []
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

    def get_route_summaries
      @client.call(:get_route_summaries)
        .body[:get_route_summaries_response]\
             [:get_route_summaries_result]\
             [:diffgram]\
             [:document_element]\
             [:route_summaries]
        .each do |route|
          @route_summaries.push(Pids::RouteSummary.new(
                                      route[:route_no],
                                      route[:headboard_route_no],
                                      route[:internal_route_no],
                                      route[:is_main_route],
                                      route[:main_route_no],
                                      route[:description],
                                      route[:up_destination],
                                      route[:down_destination],
                                      route[:has_low_floow],
                                      route[:last_modified]
                                      )
                      )
        end

      @route_summaries
    end

    def get_destinations_for_route( route_no )
      response = @client.call(:get_destinations_for_route, message: { routeNo: route_no })
        .body[:get_destinations_for_route_response]\
             [:get_destinations_for_route_result]\
             [:diffgram]\
             [:document_element]\
             [:route_destinations]

      up_destination = response[:up_destination]
      down_destination = response[:down_destination]

      dest = Pids::RouteDestination.new( up_destination, down_destination )
      dest

    end

    def get_list_of_stops_by_route_no_and_direction(route_no, is_up_direction=true)
      stops = []
      @client.call(:get_list_of_stops_by_route_no_and_direction, 
                    message: { routeNo: route_no, isUpDirection: is_up_direction }
                  )
        .body[:get_list_of_stops_by_route_no_and_direction_response]\
             [:get_list_of_stops_by_route_no_and_direction_result]\
             [:diffgram]\
             [:document_element]\
             [:s]
        .each do |stop|
          stops.push(Pids::ListedStop.new(stop[:tid],
                                          stop[:name],
                                          stop[:description],
                                          stop[:latitude],
                                          stop[:longitude],
                                          stop[:suburb_name])
                   )
        end

      stops
    end

    def get_main_routes_for_stop(stop_no)
      routes = []

      @client.call(:get_main_routes_for_stop, message: { stopNo: stop_no } )
        .body[:get_main_routes_for_stop_response]\
             [:get_main_routes_for_stop_result]\
             [:diffgram]\
             [:document_element]\
             [:list_of_main_routes_at_stop]
        .each do |route|
          routes.push(route[:route_no])
        end

      routes
    end

#
# get_list_of_routes
#   -> route_no
#     -> get_list_of_stops_for_route( route_no )
#       -> stop_no
#         -> get_next_predicted_routes_collection( stop_no, route_no )
#           -> vehicle_no
#             -> get_next_predicted_arrival_time_at_stops_for_tram_no( vehicle_no )
#
    def get_next_predicted_arrival_time_at_stops_for_tram_no(tram_no)

      res = @client.call( :get_next_predicted_arrival_time_at_stops_for_tram_no, 
                          message: { tramNo: tram_no } 
                        )
        .body[:get_next_predicted_arrival_time_at_stops_for_tram_no_response]\
             [:get_next_predicted_arrival_time_at_stops_for_tram_no_result]\
             [:diffgram]\
             [:new_data_set]

    data = Pids::PredictedArrivalTimeData.new(res)

    data
#                  )
#        .body[:get_next_predicted_arrival_time_at_stops_for_tram_no_response]\
#             [:get_next_predicted_arrival_time_at_stops_for_tram_no_result]\
#             [:document_element]\

    end

    def get_next_predicted_routes_collection(stop_no, route_no, low_floor=false)
    
      @client.call(:get_next_predicted_routes_collection, message: { stopNo: stop_no, routeNo: route_no, lowFloor: low_floor } )
        .body

    end

#    methods = {
#      'get_route_summaries' => {
#        'elem' => 'route_summaries',
#      }
#    }
#
#    d1 = 'diffgram'.to_sym
#    d2 = 'document_element'.to_sym
#
#    methods.keys.each do |m|
#      define_method (m) do
#        @client.call(m.to_sym)
#        .body["#{m}_response".to_sym]["#{m}_result".to_sym][d1][d2][ methods["#{m}"]["elem"].to_sym ]
#      end
#    end
#
#    def get_route_summaries
#      k1 = "#{__method__}_response".to_sym
#      k2 = "#{__method__}_result".to_sym
#      k3 = "#{__method__}".sub(/^get_/, '').to_sym
#
#      @client.call("#{__method__}".to_sym)
#        .body[k1][k2][:diffgram][:document_element][k3]
#        .each do |route|
#          @routes.push(Pids::Route.new(route[:route_no], route[:headboard_route_no]))
#      end
#
#      @client.call(:get_route_summaries)
#        .body[:get_route_summaries_response]\
#             [:get_route_summaries_result]\
#             [:diffgram]\
#             [:document_element]\
#             [:route_summaries]
#        .each do |route|
#          @routes.push(Pids::Route.new(route[:route_no], route[:headboard_route_no]))
#        end

    def get_stop_information(stop_id)
      response = @client.call(:get_stop_information)
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

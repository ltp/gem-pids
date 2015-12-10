require 'pids'

pids = Pids::Client.new()

n = pids.get_next_predicted_arrival_time_at_stops_for_tram_no( 3006 )
p n
exit

n = pids.get_next_predicted_routes_collection( 1721, 109 )
p n
exit
l = pids.get_list_of_stops_by_route_no_and_direction( 109 )
p l
exit
1721
summary = pids.get_route_summaries
p summary
exit

s = pids.get_main_routes_for_stop( 3201 )
p s
exit

l = pids.get_list_of_stops_by_route_no_and_direction( 96 )
p l
exit

dest = pids.get_destinations_for_route( 96 )
p dest
exit
#uu = pids.client()
#puts uu
summary = pids.get_route_summaries
p summary
exit
l = pids.get_list_of_stops_by_route_no_and_direction()
p l
exit
routes = pids.get_main_routes()
p routes
pids.get_destinations_for_all_routes.each do |dest|
  puts "#{dest.destination}"
end
#p d

require 'pids'

pids = Pids::Client.new()
uu = pids.client()
puts uu
pids.get_main_routes()

module Pids

  class Destination
    # Create a new pids destination
    # @param route_no [Int] the route number of the destination.
    # @param up_stop [Boolean] indicates if the route destination is an up stop.
    # @param destination [String] description of the route destination as a 
    #  human-readable location.
    attr_reader :route_no, :up_stop, :destination
    
    def initialize( route_no, up_stop, destination )
      @route_no = route_no
      @up_stop = up_stop
      @destination = destination
    end

  end

end

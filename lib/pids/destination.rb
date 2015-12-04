module Pids

  class Destination
    attr_reader :route_no, :up_stop, :destination
    
    def initialize( route_no, up_stop, destination )
      @route_no = route_no
      @up_stop = up_stop
      @destination = destination
    end

  end

end

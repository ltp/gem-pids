module Pids

  class RouteDestination
    attr_reader :up_destination, :down_destination
    
    def initialize( up_destination, down_destination )
      @up_destination = up_destination
      @down_destination = down_destination
    end

  end

end

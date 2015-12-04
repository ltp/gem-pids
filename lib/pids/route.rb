module Pids

  class Route
    attr_reader :route_no, 
                :headboard_route_no,
                :internal_route_no
    
    def initialize( route_no, headboard_route_no )
      @route_no = route_no
      @headboard_route_no = headboard_route_no
    end

  end

end

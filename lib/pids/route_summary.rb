module Pids

  class RouteSummary
    attr_reader :route_no, 
                :headboard_route_no,
                :internal_route_no
                :is_main_route,
                :main_route_no,
                :description,
                :up_destination,
                :down_destination,
                :has_low_floor,
                :last_modified
    
    def initialize( route_no, headboard_route_no )
      @route_no = route_no
      @headboard_route_no = headboard_route_no
    end

  end

end

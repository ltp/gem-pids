module Pids

  class PredictedArrivalTimeData
    attr_reader :tram_details, :predicted_stop_details

    def initialize( data )
      @tram_details = data[:tram_no_run_details_table]
      @predicted_stop_details = []

      data[:next_predicted_stops_details_table].each do |stop_detail|
        @predicted_stop_details.push( Pids::PredictedStopDetail.new(stop_detail) )
      end
      
    end

  end

end

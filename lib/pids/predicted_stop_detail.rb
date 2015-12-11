module Pids

  class PredictedStopDetail
    attr_reader :stop_no, :predicted_arrival_date_time

    def initialize(stop_detail)
      @stop_no = stop_detail[:stop_no]
      @predicted_arrival_date_time = stop_detail[:predicted_arrival_date_time]

    end

  end

end

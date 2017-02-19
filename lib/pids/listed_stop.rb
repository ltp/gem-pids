module Pids
  
  class ListedStop
  # Create a new Pids::ListedStop object.
  # @param tid [Int] the trackerID of the stop.
  # @param name [String] the name of the stop as a human-readable location.
  # @param description [String] a description of the stop as a human-readable
  #   description.
  # @param latitude [Float] the latitude of the stop.
  # @param longitude [Float] the longitude of the stop.
  # @param suburb_name [String] the suburb in which the stop is located as a
  #  human-readable value.
    attr_reader :tid,
                :name,
                :description,
                :latitude,
                :longitude,
                :suburb_name

    def initialize(tid, name, description, latitude, longitude, suburb_name)
      @tid = tid
      @name = name
      @description = description
      @latitude = latitude
      @longitude = longitude
      @suburb_name = suburb_name
    end

  end

end

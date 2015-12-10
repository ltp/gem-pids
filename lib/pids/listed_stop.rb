module Pids
  
  class ListedStop
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

defmodule Forecast.Formatter.Widgets.TodayWidget do

  def template do
    """
    ┌---------------------------------------------------------------------------┐
    |                                                                           |
    |  SAT                                                   Partially Cloudy   |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |  Humidity: 100%                                     Amsterdam             |
    |  Wind: ↖ 8.05 km/h                                                        |
    ├---------------------------------------------------------------------------┤
    """
  end

  def render(glyph, pos_x, pos_y, canvas) when is_binary(glyph) do
    size_x = glyph
              |> List.first
              |> length
    size_y = length glyph
    glyph_matrix = glyph
                    |> String.split("\n")
                    |> Enum.reverse
                    |> List.remove_at(0)
                    |> Enum.reverse
                    |> Enum.map(&(String.split(&1, "")))
    #XXX 
  end

  def render(_, _, _, _), do: "Glyph should be a binary string"

  def glyph('1') do
    """
      ##
     ###
    ####
      ##
      ##
     ####
    """
  end

  def glyph('2') do
    """
    .###.
    #  .#
      .#
    .#
    #
    #####
    """
  end

  def glyph('3') do
    """
    .###.
    *  .#
      *#
        #
    *  .#
     ###
    """
  end

  def glyph('4') do
    """
      .#
     .#
    .#  #
    #####
        #
        #
    """
  end

  def glyph('5') do
    """
    #####
    #
    ####.
        #
        #
    ####
    """
  end

  def glyph('6') do
    """
    .###.
    #
    ####.
    #   #
    #   #
     ###
    """
  end

  def glyph('7') do
    """
    #####
        #
       #
      #
     #
    #
    """
  end

  def glyph('8') do
    """
    .###.
    #   #
    .###.
    #   #
    #   #
     ###
    """
  end

  def glyph('9') do
    """
    .###.
    #   #
     ####
        #
    .   #
     ###
    """
  end

  def glyph('0') do
    """
    .###.
    #   #
    #   #
    #   #
    #   #
     ###
    """
  end

  def glyph('+') do
    """


      #
    ##### 
      #

    """
  end

  def glyph('-') do
    """


    
    ##### 
    

    """
  end

  def glyph(' ') do
    """
      
      
      
      
      
      
    """
  end


  def glyph(unknown) do
    raise "Unknown glyph: #{unknown}"
  end

end


defmodule Forecast.Formatter.Widgets.TodayWidget do

  def template do
    Forecast.Formatter.to_glyph """
    ┌---------------------------------------------------------------------------┐
    |                                                                           |
    |  XXX                                                   XXX                |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |  Humidity: XX                                       X                     |
    |  Wind: XXX                                                                |
    ├---------------------------------------------------------------------------┤
    """
  end

  def glyph(gl) do
    Forecast.Formatter.to_glyph(_glyph(gl))
  end

  defp _glyph('1') do
    """
      ##
     ###
    ####
      ##
      ##
     ####
    """
  end

  defp _glyph('2') do
    """
    .###.
    #  .#
      .#
    .#
    #
    #####
    """
  end

  defp _glyph('3') do
    """
    .###.
    *  .#
      *#
        #
    *  .#
     ###
    """
  end

  defp _glyph('4') do
    """
      .#
     .#
    .#  #
    #####
        #
        #
    """
  end

  defp _glyph('5') do
    """
    #####
    #
    ####.
        #
        #
    ####
    """
  end

  defp _glyph('6') do
    """
    .###.
    #
    ####.
    #   #
    #   #
     ###
    """
  end

  defp _glyph('7') do
    """
    #####
        #
       #
      #
     #
    #
    """
  end

  defp _glyph('8') do
    """
    .###.
    #   #
    .###.
    #   #
    #   #
     ###
    """
  end

  defp _glyph('9') do
    """
    .###.
    #   #
     ####
        #
    .   #
     ###
    """
  end

  defp _glyph('0') do
    """
    .###.
    #   #
    #   #
    #   #
    #   #
     ###
    """
  end

  defp _glyph('+') do
    """


      #
    ##### 
      #

    """
  end

  defp _glyph('-') do
    """


    
    ##### 
    

    """
  end

  defp _glyph(' ') do
    """
      
      
      
      
      
      
    """
  end

  defp _glyph(unknown) do
    raise "Unknown glyph: #{unknown}"
  end

end


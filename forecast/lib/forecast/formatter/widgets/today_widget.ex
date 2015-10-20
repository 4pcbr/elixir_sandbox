defmodule Forecast.Formatter.Widgets.TodayWidget do

  import Forecast.Formatter, only: [
    concat: 2,
    join_glyphs: 4,
    str_to_glyph: 1,
  ]

  def render_data(data) when is_map(data) do
    unknown     = "---"
    temperature = Map.get(data, :temperature, unknown)
    humidity    = Map.get(data, :humidity, unknown)
    wind        = Map.get(data, :wind, unknown)
    location    = Map.get(data, :location, unknown)
    temp_glyph  = temperature
                    |> String.split("")
                    |> Enum.join(" ")
                    |> String.split("")
                    |> Enum.map(&String.to_char_list/1)
                    |> _char_list_to_glyphs
    join_glyphs(template, 40, 3, temp_glyph)
      |> join_glyphs( 56, 11, [ String.to_char_list( location ) ] )
      |> join_glyphs( 13, 11, [ String.to_char_list( humidity ) ] )
      |> join_glyphs( 9, 12,  [ String.to_char_list( wind ) ] )
  end

  #defp _char_list_to_glyphs([]), do: []
  defp _char_list_to_glyphs(['']), do: []
  defp _char_list_to_glyphs([ch]), do: glyph(ch)
  defp _char_list_to_glyphs([ch | rest]) do
    IO.inspect glyph(ch)
    concat( glyph(ch), _char_list_to_glyphs(rest) )
  end

  def render_data(_), do: raise "The argument should be a map"

  def template do
    str_to_glyph """
    ┌---------------------------------------------------------------------------┐
    |                                                                           |
    |  XXX                                   XXX                                |
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
    str_to_glyph(_glyph(gl))
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

  defp _glyph('C') do
    """
    .###.
    #   #
    #    
    #    
    #   #
     ### 
    """
  end

  defp _glyph('F') do
    """
    #####
    #    
    #    
    ###  
    #    
    #    
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


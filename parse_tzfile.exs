defmodule TZFile do

  def parse(file_path) do
    case File.read(file_path) do
      {:ok, binary} ->
        do_parse(binary)
      _ ->
        IO.puts "Problem reading the file"
    end
  end

  defp do_parse(binary) do
    << header :: binary-size(44), _body :: binary >> = binary
    << tzif :: binary-size(4),
       version :: binary-size(1),
       reservred_15 :: binary-size(15),
       tzh_ttisgmtcnt :: binary-size(4),
       tzh_ttisstdcnt :: binary-size(4),
       tzh_leapcnt :: binary-size(4),
       tzh_timecnt :: binary-size(4),
       tzh_typecnt :: binary-size(4),
       tzh_charcnt :: binary-size(4) >> = header
    IO.puts """
      File identificator: #{tzif}
      version: 0x#{Base.encode16(version)}
      reserved: 0x#{Base.encode16(reservred_15)}
      tzh_ttisgmtcnt: 0x#{Integer.parse(tzh_ttisgmtcnt, 10)}
      tzh_ttisstdcnt: 0x#{Base.encode16 tzh_ttisstdcnt}
      tzh_leapcnt: 0x#{Base.encode16 tzh_leapcnt}
      tzh_timecnt: 0x#{Base.encode16 tzh_timecnt}
      tzh_typecnt: 0x#{Base.encode16 tzh_typecnt}
      tzh_charcnt: 0x#{Base.encode16 tzh_charcnt}
    """
  end


end

TZFile.parse("/usr/share/zoneinfo/Europe/Amsterdam")

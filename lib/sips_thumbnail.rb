# Sips Filter
# 
# Uses the 'sips' command line tool in Mac OS X to resample images

class SipsThumbnailFilter < Nanoc3::Filter
  identifier :sips_thumbnail
  type :binary

  def run(filename, params={})
    system(%{
      sips --resampleHeightWidthMax #{params[:size] || 100} -s format #{params[:format] || 'png'} #{filename.inspect} --out #{output_filename.inspect} > /dev/null 2> /dev/null
    })
  end
end

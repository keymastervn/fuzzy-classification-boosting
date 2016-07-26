require 'cgi'

class Helper
  def self.html2text(html)
    text = html.to_s.
      gsub(/(&nbsp;|\n|\s)+/im, ' ').squeeze(' ').strip.
      gsub(/<([^\s]+)[^>]*(src|href)=\s*(.?)([^>\s]*)\3[^>]*>\4<\/\1>/i,
  '\4')

    links = []
    linkregex = /<[^>]*(src|href)=\s*(.?)([^>\s]*)\2[^>]*>\s*/i
    while linkregex.match(text)
      links << $~[3]
      text.sub!(linkregex, "[#{links.size}]")
    end

    text = CGI.unescapeHTML(
      text.
        gsub(/<(script|style)[^>]*>.*<\/\1>/im, '').
        gsub(/<!--.*-->/m, '').
        gsub(/<hr(| [^>]*)>/i, "___\n").
        gsub(/<li(| [^>]*)>/i, "\n* ").
        gsub(/<blockquote(| [^>]*)>/i, '> ').
        gsub(/<(br)(| [^>]*)>/i, "\n").
        gsub(/<(\/h[\d]+|p)(| [^>]*)>/i, "\n\n").
        gsub(/<[^>]*>/, '')
    ).lstrip.gsub(/\n[ ]+/, "\n") + "\n"

    for i in (0...links.size).to_a
      text = text + "\n  [#{i+1}] <#{CGI.unescapeHTML(links[i])}>" unless
  links[i].nil?
    end
    links = nil
    text
  end

  def self.triangle_calculate_membership(left,core,right,value)
    # assume that value is in range of [left,right]
    case
    when value == core
      return 1.0
    when value > core
      return (right - value)/(right - core).to_f
    when value < core
      return (value - left)/(core - left).to_f
    end
  end

  def self.average_without_max(array, beta)
    length = array.length - 1
    value = self.array_total_value(array) - beta
    return value.to_f / length
  end

  def self.array_total_value(array)
    array.inject(0, :+)
  end

  def self.calculate_certainty_factor(array, beta)
    return (beta - self.average_without_max(array, beta)) / self.array_total_value(array)
  end

end

class Hash
  # like invert but not lossy
  # {"one"=>1,"two"=>2, "1"=>1, "2"=>2}.inverse => {1=>["one", "1"], 2=>["two", "2"]} 
  def safe_invert
    each_with_object({}) do |(key,value),out| 
      out[value] ||= []
      out[value] << key
    end
  end
end

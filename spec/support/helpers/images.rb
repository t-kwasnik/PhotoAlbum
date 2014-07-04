module Helpers
  module Images
    def match_url(full, relative)
      len = -relative.length
      relative == full[len..-1] ? true : false
    end
  end
end

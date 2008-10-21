
module Ruby

  def Ruby::parse par
    par.replace_all("(\\\\ruby\\{([^}]+)\\})",proc { | cmd | eval(cmd).to_s } )
  end

end

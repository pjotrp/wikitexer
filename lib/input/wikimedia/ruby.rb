
module Ruby

  def Ruby::parse par
    par.replace_all("(\\\\ruby\\{([^}]+)\\})",proc { | cmd, orig | eval(cmd).to_s } )
  end

end


module Ruby

  # Evaluate ruby code between braces and inject result into output
  #
  #    \ruby{execute this}
  #
  def Ruby::parse par
    par.replace_all("(\\\\ruby\\{([^}]+)\\})",proc { | cmd, orig | eval(cmd).to_s } )
  end

end
